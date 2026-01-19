import 'package:contact_app/data/contact.dart';
import 'package:contact_app/ui/contacts_list/widget/contact_title.dart';
import 'package:contact_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactsListPage extends StatefulWidget {
  const ContactsListPage({super.key});

  @override
  State<ContactsListPage> createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts', style: TextStyle(fontSize: 35)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ScopedModelDescendant<ContactsModel>(
        builder: (context, child, model) {
          return ListView.builder(
            itemCount: model.contacts.length,
            // Runs and Builds every single item list item
            itemBuilder: (context, index) {
              return ContactTitle(contactIndex: index);
            },
          );
        },
      ),
    );
  }
}
