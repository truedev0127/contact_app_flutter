import 'package:contact_app/data/contact.dart';
import 'package:contact_app/data/db/contact_dao.dart';
import 'package:faker/faker.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactsModel extends Model {
  final ContactDao _contactDao = ContactDao();

  // List<Contact> _contacts = List.generate(5, (index) {
  //   return Contact(
  //     id: index,
  //     name: Faker().person.name(),
  //     email: Faker().internet.email(),
  //     phoneNumber: Faker().phoneNumber.us(),
  //   );
  // });
  List<Contact> _contacts = [];

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  // get only property, makes sure that
  List<Contact> get contacts => _contacts;

  Future loadContacts() async {
    _isLoading = true;
    notifyListeners();
    _contacts = await _contactDao.getAllInSortedOrder();
    _isLoading = false;
    notifyListeners();
  }

  Future addContact(Contact contact) async {
    await _contactDao.insert(contact);
    await loadContacts();
    //_sortContacts();
    notifyListeners();
  }

  Future updateContact(Contact contact) async {
    await _contactDao.update(contact);
    await loadContacts();
    notifyListeners();
  }

  Future deleteContact(Contact contact) async {
    await _contactDao.delete(contact);
    await loadContacts();
    notifyListeners();
  }

  Future changeFavoriteStatus(Contact contact) async {
    contact.isFavorite = !contact.isFavorite;
    await updateContact(contact);
    _contacts = await _contactDao.getAllInSortedOrder();
    notifyListeners();
  }

  // void _sortContacts() {
  //   _contacts.sort((a, b) {
  //     int comparisonResult;
  //     comparisonResult = _compareBasedOnFavoriteStatues(a, b);
  //     if (comparisonResult == 0) {
  //       comparisonResult = _compareAlphabetically(a, b);
  //     }
  //     return comparisonResult;
  //   });
  // }

  // int _compareBasedOnFavoriteStatues(Contact a, Contact b) {
  //   if (a.isFavorite && !b.isFavorite) return -1;
  //   if (!a.isFavorite && b.isFavorite) return 1;
  //   return 0;
  // }

  // int _compareAlphabetically(Contact a, Contact b) {
  //   return a.name.compareTo(b.name);
  // }
}
