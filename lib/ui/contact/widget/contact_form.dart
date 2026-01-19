import 'dart:io';

import 'package:contact_app/data/contact.dart';
import 'package:contact_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key, this.editedContact, this.contactIndex});

  final Contact? editedContact;
  final int? contactIndex;

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  late String _name;
  late String _email;
  late String _phoneNumber;
  File? _contactImageFile;

  bool get isEditMode =>
      widget.editedContact != null && widget.contactIndex != null;

  bool get hasSeletedCustomImage => _contactImageFile != null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (isEditMode) {
      _contactImageFile = widget.editedContact?.contactImageFile;
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          SizedBox(height: 16.0),
          _buildContactPicture(),
          SizedBox(height: 50.0),
          TextFormField(
            onSaved: (value) => _name = value!,
            initialValue: widget.editedContact?.name,
            validator: _validateName,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            initialValue: widget.editedContact?.email,
            validator: _validateEmail,
            onSaved: (value) => _email = value!,
            decoration: InputDecoration(
              labelText: 'Mail',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            initialValue: widget.editedContact?.phoneNumber,
            validator: _validatePhoneNumber,
            onSaved: (value) => _phoneNumber = value!,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          SizedBox(height: 30.0),
          ElevatedButton(
            onPressed: _onSaveContactButtonPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.save),
                SizedBox(width: 8.0),
                Text('Save Contact'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactPicture() {
    final halfScreenDiameter = MediaQuery.of(context).size.width / 2;
    return Hero(
      // Use editedContact's hashCode as tag in edit mode, else use 0
      // to avoid tag conflicts
      tag: widget.editedContact?.hashCode ?? 0,
      child: GestureDetector(
        onTap: _onContactPictureTapped,
        child: CircleAvatar(
          radius: halfScreenDiameter / 2,
          child: _buildCircleAvatar(halfScreenDiameter),
        ),
      ),
    );
  }

  void _onContactPictureTapped() {
    final ImagePicker _imagePicker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  final XFile? image = await _imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );
                  // Handle the selected image
                  setState(() {
                    if (image != null) {
                      _contactImageFile = File(image.path);
                    }
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () async {
                  final XFile? image = await _imagePicker.pickImage(
                    source: ImageSource.camera,
                  );
                  // Handle the captured image
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircleAvatar(double halfScreenDiameter) {
    if (isEditMode || hasSeletedCustomImage) {
      return _buildEditModeCircleAvatarContent(halfScreenDiameter);
    } else {
      return Icon(Icons.person, size: halfScreenDiameter / 2);
    }
  }

  Widget _buildEditModeCircleAvatarContent(double halfScreenDiameter) {
    if (_contactImageFile == null) {
      return Text(
        widget.editedContact?.name[0].toUpperCase() ?? '',
        style: TextStyle(fontSize: halfScreenDiameter / 2),
      );
    } else {
      return AspectRatio(
        aspectRatio: 1,
        child: ClipOval(
          child: Image.file(_contactImageFile!, fit: BoxFit.cover),
        ),
      );
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter an email';
    }
    // Simple email validation
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a phone number';
    }
    final phoneRegex = RegExp(
      r'^(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]\d{3}[\s.-]\d{4}$',
    );
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  void _onSaveContactButtonPressed() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final newOrEditedContact = Contact(
      name: _name,
      email: _email,
      phoneNumber: _phoneNumber,
      isFavorite: widget.editedContact?.isFavorite ?? false,
      contactImageFile: _contactImageFile,
    );

    if (isEditMode) {
      ScopedModel.of<ContactsModel>(
        context,
      ).updateContact(newOrEditedContact, widget.contactIndex!);
    } else {
      ScopedModel.of<ContactsModel>(context).addContact(newOrEditedContact);
    }

    Navigator.of(context).pop();
  }
}
