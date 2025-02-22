class ApiEndpoint {
  static String apiEndpoint = 'http://192.168.1.8:8080/api/Contacts';

  static String getAllContacts(int page, int pageSize) => '$apiEndpoint/get-all-contacts?page=$page&contactsPerPage=$pageSize';
  static String getContactById(int id) => '$apiEndpoint/get-a-contact/$id';
  static String addNewContact = '$apiEndpoint/add-new-contact';
  static String addMultiContact = '$apiEndpoint/add-multiple-contacts';
  static String updateContactById(int id) => '$apiEndpoint/update-contact/$id';
  static String deleteContact(int id) => '$apiEndpoint/delete-contact/$id';
}