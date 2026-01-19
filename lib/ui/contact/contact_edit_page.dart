import 'package:contact_app/data/contact.dart';
import 'package:contact_app/ui/contact/widget/contact_form.dart';
import 'package:flutter/material.dart';

class ContactEditPage extends StatelessWidget {
  const ContactEditPage({
    super.key,
    required this.editedContact,
    required this.contactIndex,
  });

  final Contact editedContact;
  final int contactIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Contact'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ContactForm(
        editedContact: editedContact,
        contactIndex: contactIndex,
      ),
    );
  }
}
