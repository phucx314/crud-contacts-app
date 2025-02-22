class ModelContact {
  final int? id;
  final String name;
  final String phoneNumber;
  final String email;
  final String homeAddress;
  final String avatarUrl;

  ModelContact({
    this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.homeAddress,
    required this.avatarUrl,
  });

  factory ModelContact.fromJson(Map<String, dynamic> json) {
    return ModelContact(
      id: json['id'] ?? 0,
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      homeAddress: json['homeAddress'],
      avatarUrl: (json['avatarUrl'] != 'none') ? json['avatarUrl'] : 'https://sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'homeAddress': homeAddress,
      'avatarUrl': avatarUrl,
    };
  }
}

// AddNewContactResponse
class AddNewContactResponse {
  final bool? success;
  final ModelContact contact;

  AddNewContactResponse({
    this.success,
    required this.contact,
  });

  factory AddNewContactResponse.fromJson(Map<String, dynamic> json) {
    return AddNewContactResponse(
      success: json['success'] ?? false,
      contact: ModelContact.fromJson(json['contact']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'contact': contact.toJson(),
    };
  }
}
