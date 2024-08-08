import 'dart:io';

import 'package:assignment/models/profile_model.dart';
import 'package:assignment/providers/profile_provider.dart';
import 'package:assignment/services/auth_service.dart';
import 'package:assignment/utils/form_vadidator.dart';
import 'package:assignment/utils/formatter.dart';
import 'package:assignment/widgets/components/custom_buttons.dart';
import 'package:assignment/widgets/components/empty_space.dart';
import 'package:assignment/widgets/header_bar.dart';
import 'package:assignment/widgets/pickers/profile_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  bool _showPassword = false;

  final _formKey = GlobalKey<FormState>();

  late ProfileModel profile;

  File? _image;
  // Controllers for text fields

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void didChangeDependencies() {
    profile = Provider.of<ProfileProvider>(context).userProfile!;
    _nameController.text = profile.username;
    _dobController.text = profile.dateOfBirth;
    // _emailController.text = profile.email;
    _contactController.text = profile.contact;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _nameController.dispose();
    _dobController.dispose();
    // _emailController.dispose();
    _contactController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _editProfile() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    await AuthService()
        .reauthenticateUser(_currentPasswordController.text)
        .then((status) async {
      if (status) {
        await AuthService()
            .changePassword(_newPasswordController.text.trim())
            .then((_) async {
          await Provider.of<ProfileProvider>(context, listen: false)
              .updateProfile(profile, image: _image)
              .then((status) => {
                    Navigator.of(context).pop(),
                    if (status)
                      {
                        Navigator.of(context).pop(),
                      }
                    else
                      {
                        ScaffoldMessenger.of(context).clearSnackBars(),
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile Update Failed!'),
                          ),
                        ),
                      }
                  });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(headerTitle: 'Edit Profile', menuRequired: false),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              CustomProfileImagePicker(
                  imageLink: profile.imageLink,
                  actionOnPressed: (image) {
                    _image = image;
                  }),
              const VerticalEmptySpace(),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const VerticalEmptySpace(),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dobController,
                      decoration: const InputDecoration(
                        labelText: 'Date of Birth',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 16), // Space between fields
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'male',
                          child: Text('Male'),
                        ),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text('Female'),
                        ),
                      ],
                      onChanged: (String? value) {},
                      value: profile.gender.toString().split('.').last,
                    ),
                  ),
                ],
              ),
              const VerticalEmptySpace(),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                ),
                keyboardType: TextInputType.phone,
                validator: contactValidator(),
              ),
              const VerticalEmptySpace(),
              TextFormField(
                controller: _currentPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                ),
                obscureText: true,
              ),
              const VerticalEmptySpace(),
              TextFormField(
                controller: _newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                ),
                obscureText: !_showPassword,
                validator: passwordValidator(),
                onChanged: (value) {
                  setState(() {
                    _newPasswordController.text = value;
                  });
                },
              ),
              const VerticalEmptySpace(),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: !_showPassword,
                onChanged: (value) {
                  setState(() {
                    _confirmPasswordController.text = value;
                  });
                },
                validator:
                    confirmPasswordValidator(_newPasswordController.text),
              ),
              const VerticalEmptySpace(),
              Row(
                children: [
                  Switch(
                    value: _showPassword,
                    onChanged: (bool value) {
                      setState(() {
                        _showPassword = value;
                      });
                    },
                  ),
                  const Text('Show Password'),
                ],
              ),
              const SizedBox(height: 16),
              CustomActionButton(
                displayText: 'Update',
                actionOnPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _editProfile();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Initial date for the date picker
      firstDate: DateTime(1924), // The earliest date that can be selected
      lastDate: DateTime.now(), // The latest date that can be selected
    );

    if (pickedDate != null) {
      setState(() {
        _dobController.text =
            formatDateTimeToStringDate(pickedDate); // Format the date
      });
    }
  }
}
