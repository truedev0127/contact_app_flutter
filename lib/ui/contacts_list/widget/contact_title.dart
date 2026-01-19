import 'package:contact_app/data/contact.dart';
import 'package:flutter/material.dart';

class ContactTitle extends StatelessWidget {
  const ContactTitle({
    super.key,
    required this.contact,
    required this.onFavoriteToggle,
  });

  final Contact contact;
  final void Function() onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(contact.name),
      subtitle: Text(contact.email),
      trailing: IconButton(
        onPressed: onFavoriteToggle,
        icon: Icon(
          contact.isFavorite ? Icons.star : Icons.star_border,
          color: contact.isFavorite ? Colors.amber : Colors.grey,
        ),
      ),
    );
  }
}
