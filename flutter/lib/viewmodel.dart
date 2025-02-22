import 'package:flutter/material.dart';
import 'package:testapi_nashtech/model.dart';
import 'package:testapi_nashtech/service.dart';
import 'package:flutter/foundation.dart';

class Viewmodel extends ChangeNotifier {
  final Service _service = Service();
  ModelContact _modelContact = ModelContact(
    name: '',
    phoneNumber: '',
    email: '',
    homeAddress: '',
    avatarUrl: '',
  );
  List<ModelContact> _contactsList = [];
  bool _isLoading = true; // đôi rmawjc định thành false
  int _currentPage = 1;
  bool _hasMore = true;
  final ScrollController scrollController = ScrollController();

  ModelContact get modelContact => _modelContact;
  List<ModelContact> get contactsList => _contactsList;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Viewmodel() {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100 && !_isLoading && _hasMore) {
      getAllContacts(); // gọi api khi gần đến cuối list
    }
  }

  Future<void> getAllContacts() async {
    // if (_isLoading || !_hasMore) return; // nếu đang load hoặc hết data thì dừng luôn

    // _isLoading = true;
    // notifyListeners();

    // print("Fetching contacts - Current page: $_currentPage");

    try {
      List<ModelContact> newContacts =
          await _service.getAllContacts(page: _currentPage, pageSize: 25);
      // print("Fetched ${newContacts.length} new contacts");

      if (newContacts.isEmpty) {
        _hasMore = false; // hết data để load
      } else {
        _contactsList
            .addAll(newContacts); // thêm data ở trang đã load vào list contacts
        _currentPage++; // sang trang
      }
      // print(_contactsList);
    } catch (e) {
      print('Lỗi khi lấy data danh bạ: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onRefreshAllContacts(BuildContext context) async {
    _contactsList = [];
    _currentPage = 1;
    _hasMore = true;
    getAllContacts();
    notifyListeners();
  }

  Future<void> getContactById(int id) async {
    try {
      _isLoading = true;
      _modelContact = await _service.getContactById(id);
      notifyListeners();
    } catch (e) {
      print('Lỗi khi lấy data contact: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onRefreshContactDetails(BuildContext context, int id) async {
    getContactById(id);
    notifyListeners();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController homeAddressController = TextEditingController();
  final TextEditingController avatarUrlController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    homeAddressController.dispose();
    avatarUrlController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<int?> addNewContact() async {
    final newContact = ModelContact(
      name: nameController.text,
      phoneNumber: phoneNumberController.text,
      email: emailController.text,
      homeAddress: homeAddressController.text,
      avatarUrl: avatarUrlController.text,
    );

    print(
        'Creating new contact: ${newContact.name}, ${newContact.phoneNumber}, ${newContact.email}, ${newContact.homeAddress}');

    try {
      final response = await _service.addNewContact(newContact);
      if (response != null && response.success!) {
        return response.contact.id;
      } else {
        return null;
      }
    } catch (e) {
      print('Lỗi khi tạo contact mới: $e');
      return null;
    }
  }

  Future<void> deleteContact(int id) async {
    try {
      await _service.deleteContact(id);
      _contactsList.removeWhere((contact) => contact.id == id);
      notifyListeners();
    } catch (e) {
      print('Lỗi khi xóa contact: $e');
    }
  }

  Future<void> updateContact(int id) async {
    final updatedContact = ModelContact(
      id: id,
      name: nameController.text,
      phoneNumber: phoneNumberController.text,
      email: emailController.text,
      homeAddress: homeAddressController.text,
      avatarUrl: avatarUrlController.text,
    );

    try {
      await _service.updateContact(id, updatedContact);
      final index = _contactsList.indexWhere((contact) => contact.id == id);
      if (index != -1) {
        _contactsList[index] = updatedContact;
        notifyListeners();
      }
    } catch (e) {
      print('Lỗi khi cập nhật contact: $e');
    }
  }

  void fillContactFields(ModelContact contact) {
    nameController.text = contact.name;
    phoneNumberController.text = contact.phoneNumber;
    emailController.text = contact.email;
    homeAddressController.text = contact.homeAddress;
    avatarUrlController.text = contact.avatarUrl;
  }
}
