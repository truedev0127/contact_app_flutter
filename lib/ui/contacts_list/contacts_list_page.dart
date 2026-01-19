import 'package:contact_app/data/contact.dart';
import 'package:contact_app/ui/contacts_list/widget/contact_title.dart';
import 'package:flutter/material.dart';
import 'package:faker/faker.dart';

class ContactsListPage extends StatefulWidget {
  const ContactsListPage({super.key});

  @override
  State<ContactsListPage> createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
  late List<Contact> _contacts;

  @override
  void initState() {
    super.initState();
    _contacts = List.generate(50, (index) {
      return Contact(
        name: Faker().person.name(),
        email: Faker().internet.email(),
        phoneNumber: Faker().phoneNumber.us(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts', style: TextStyle(fontSize: 35)),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        // Runs and Builds every single item list item
        itemBuilder: (context, index) {
          return ContactTitle(
            contact: _contacts[index],
            onFavoriteToggle: () {
              setState(() {
                _contacts[index].isFavorite = !_contacts[index].isFavorite;
                _contacts.sort((a, b) {
                  if (a.isFavorite && !b.isFavorite) return -1;
                  if (!a.isFavorite && b.isFavorite) return 1;
                  return 0;
                });
              });
            },
          );
        },
      ),
    );
  }
}
