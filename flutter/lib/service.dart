import 'dart:convert';

import 'package:testapi_nashtech/api_endpoint.dart';
import 'package:testapi_nashtech/model.dart';
import 'package:http/http.dart' as http;

class Service {
  Future<List<ModelContact>> getAllContacts({int page = 1, int pageSize = 15}) async {
    final url = Uri.parse(ApiEndpoint.getAllContacts(page, pageSize));
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      // print(jsonData);
      List<dynamic> data = jsonData['data'];
      return data.map((contact) => ModelContact.fromJson(contact)).toList();
    } else {
      throw Exception('Lấy danh bạ thất bại');
    }
  }

  Future<ModelContact> getContactById(int id) async {
    final url = Uri.parse(ApiEndpoint.getContactById(id));
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      return ModelContact.fromJson(jsonData);
    } else {
      throw Exception('Lấy thông tin contact thất bại');
    }
  }

  Future<AddNewContactResponse> addNewContact(ModelContact modelContact) async {
    final url = Uri.parse(ApiEndpoint.addNewContact);
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'name': modelContact.name,
      'phoneNumber': modelContact.phoneNumber,
      'email': modelContact.email,
      'homeAddress': modelContact.homeAddress,
      'avatarUrl': modelContact.avatarUrl,
    });

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
      var jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonData['success'] == true) {
        return AddNewContactResponse.fromJson(jsonData);
      }
    }
    throw Exception('Tạo contact mới thất bại');
  }

  Future<void> deleteContact(int id) async {
    final url = Uri.parse(ApiEndpoint.deleteContact(id));
    final response = await http.delete(url);

    if (response.statusCode != 204) {
      throw Exception('Xóa contact thất bại');
    }
  }

  Future<void> updateContact(int id, ModelContact modelContact) async {
    final url = Uri.parse(ApiEndpoint.updateContactById(id));
    final headers = {
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'id': id,
      'name': modelContact.name,
      'phoneNumber': modelContact.phoneNumber,
      'email': modelContact.email,
      'homeAddress': modelContact.homeAddress,
      'avatarUrl': modelContact.avatarUrl,
    });

    final response = await http.put(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode != 204) {
      throw Exception('Cập nhật contact thất bại');
    }
  }
}
