import 'package:contact_app/data/contact.dart';
import 'package:faker/faker.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactsModel extends Model {
  List<Contact> _contacts = List.generate(50, (index) {
    return Contact(
      name: Faker().person.name(),
      email: Faker().internet.email(),
      phoneNumber: Faker().phoneNumber.us(),
    );
  });

  // get only property, makes sure that
  List<Contact> get contacts => _contacts;

  void changeFavoriteStatus(int index) {
    _contacts[index].isFavorite = !_contacts[index].isFavorite;
    _sortContacts();
    notifyListeners();
  }

  void _sortContacts() {
    _contacts.sort((a, b) {
      int comparisonResult;
      comparisonResult = _compareBasedOnFavoriteStatues(a, b);
      if (comparisonResult == 0) {
        comparisonResult = _compareAlphabetically(a, b);
      }
      return comparisonResult;
    });
  }

  int _compareBasedOnFavoriteStatues(Contact a, Contact b) {
    if (a.isFavorite && !b.isFavorite) return -1;
    if (!a.isFavorite && b.isFavorite) return 1;
    return 0;
  }

  int _compareAlphabetically(Contact a, Contact b) {
    return a.name.compareTo(b.name);
  }
}
