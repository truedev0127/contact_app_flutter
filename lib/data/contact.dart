class Contact {
  String name;
  String email;
  // +1234567890 - not all phone bumbers are valid mathematical numbers
  String phoneNumber;
  bool isFavorite;

  Contact({
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.isFavorite = false,
  });
}
