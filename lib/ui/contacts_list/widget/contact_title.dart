import 'package:contact_app/data/contact.dart';
import 'package:contact_app/ui/contact/contact_edit_page.dart';
import 'package:contact_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class ContactTitle extends StatelessWidget {
  const ContactTitle({super.key, required this.contactIndex});

  final int contactIndex;

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<ContactsModel>(context);
    final displayedContact = model.contacts[contactIndex];
    return Slidable(
      key: ValueKey(0),
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        dismissible: DismissiblePane(onDismissed: () {}),

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (context) =>
                _callPhoneNumber(context, displayedContact.phoneNumber),
            backgroundColor: Color.fromARGB(255, 31, 125, 212),
            foregroundColor: Colors.white,
            icon: Icons.call,
            label: 'Call',
          ),
          SlidableAction(
            onPressed: (context) => _sendEmail(context, displayedContact.email),
            backgroundColor: Color.fromARGB(255, 82, 207, 66),
            foregroundColor: Colors.white,
            icon: Icons.mail,
            label: 'Mail',
          ),
        ],
      ),

      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            onPressed: _deleteContact,
            backgroundColor: Color.fromARGB(255, 230, 18, 18),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: _buildContent(context, displayedContact, model),
    );
  }

  Container _buildContent(
    BuildContext context,
    Contact displayedContact,
    ContactsModel model,
  ) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: ListTile(
        title: Text(displayedContact.name),
        subtitle: Text(displayedContact.email),
        leading: _buildCircleAvatar(displayedContact),
        trailing: IconButton(
          onPressed: () {
            model.changeFavoriteStatus(displayedContact);
          },
          icon: Icon(
            displayedContact.isFavorite ? Icons.star : Icons.star_border,
            color: displayedContact.isFavorite ? Colors.amber : Colors.grey,
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ContactEditPage(editedContact: displayedContact),
            ),
          );
        },
      ),
    );
  }

  Hero _buildCircleAvatar(Contact displayedContact) {
    return Hero(
      tag: displayedContact.hashCode,
      child: CircleAvatar(child: _buildCircleAvatarContent(displayedContact)),
    );
  }

  Widget _buildCircleAvatarContent(Contact displayedContact) {
    if (displayedContact.contactImageFile == null) {
      return Text(displayedContact.name[0].toUpperCase());
    } else {
      return ClipOval(
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.file(
            displayedContact.contactImageFile!,
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  void _deleteContact(BuildContext context) {
    final model = ScopedModel.of<ContactsModel>(context);
    final displayedContact = model.contacts[contactIndex];

    model.deleteContact(displayedContact);
  }

  Future _callPhoneNumber(BuildContext context, String number) async {
    // Implement call functionality here
    final Uri launchUri = Uri(scheme: 'tel', path: number);
    await url_launcher.launchUrl(launchUri);

    // if (await url_launcher.canLaunchUrl(launchUri)) {
    //   await url_launcher.launchUrl(launchUri);
    // } else {
    //   final snackBar = SnackBar(content: Text('Could not launch $launchUri'));
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // }
  }

  Future _sendEmail(BuildContext context, String emailAddress) async {
    // Implement email functionality here
    final Uri launchUri = Uri(scheme: 'mailto', path: emailAddress);
    await url_launcher.launchUrl(launchUri);
  }
}
