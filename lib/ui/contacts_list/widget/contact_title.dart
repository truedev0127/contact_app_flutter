import 'package:contact_app/data/contact.dart';
import 'package:contact_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactTitle extends StatelessWidget {
  const ContactTitle({super.key, required this.contactIndex});

  final int contactIndex;

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<ContactsModel>(context);
    final displayedContact = model.contacts[contactIndex];
    return ListTile(
      title: Text(displayedContact.name),
      subtitle: Text(displayedContact.email),
      trailing: IconButton(
        onPressed: () {
          model.changeFavoriteStatus(contactIndex);
        },
        icon: Icon(
          displayedContact.isFavorite ? Icons.star : Icons.star_border,
          color: displayedContact.isFavorite ? Colors.amber : Colors.grey,
        ),
      ),
    );
  }
}
