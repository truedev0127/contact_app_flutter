import 'dart:io';

class Contact {
  late int id;
  String name;
  String email;
  // +1234567890 - not all phone bumbers are valid mathematical numbers
  String phoneNumber;
  bool isFavorite;
  File? contactImageFile;

  Contact({
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.isFavorite = false,
    this.contactImageFile,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'isFavorite': isFavorite ? 1 : 0,
      'contactImageFilePath': contactImageFile?.path,
    };
  }

  static Contact fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      isFavorite: map['isFavorite'] == 1 ? true : false,
      contactImageFile: map['contactImageFilePath'] != null
          ? File(map['contactImageFilePath'])
          : null,
    );
  }
}
