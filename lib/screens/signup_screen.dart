import 'dart:io';

import 'package:assignment/models/profile_model.dart';
import 'package:assignment/providers/file_provider.dart';
import 'package:assignment/services/auth_service.dart';
import 'package:assignment/theme/fonts.dart';
import 'package:assignment/utils/form_vadidator.dart';
import 'package:assignment/utils/formatter.dart';
import 'package:assignment/widgets/components/custom_buttons.dart';
import 'package:assignment/widgets/components/custom_input_fields.dart';
import 'package:assignment/widgets/components/empty_space.dart';
import 'package:assignment/widgets/components/password_field.dart';
import 'package:assignment/widgets/header_bar.dart';
import 'package:assignment/widgets/loading.dart';
import 'package:assignment/widgets/pickers/profile_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _dateOfBirthController = TextEditingController();

  @override
  void dispose() {
    _dateOfBirthController.dispose();
    super.dispose();
  }

  String? errorMessage = '';
  bool isFirstPage = true;
  final _formKey = GlobalKey<FormState>();

  // FOR TESTING PURPOSES ONLY
  String? _username = 'Golden Lim';
  String _email = 'goldenlimjc@gmail.com';
  String? _password = 'New1234!';
  String? _dateOfBirth = '2003-08-05';
  Gender _gender = Gender.female;
  String? _contact = '0101237890';
  File? _image;

  // String? _username;
  // String _email = '';
  // String? _password;
  // String? _dateOfBirth;
  // Gender _gender = Gender.female;
  // String? _contact;
  // File? _image;

  void signUp(BuildContext ctx) {
    try {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) =>
              (const CustomLoading(loadingText: 'Signing up...'))));
      FileProvider.uploadProfileImage(_image!, _email)
          .then((imageUrl) => {
                AuthService().createNewUser(
                    newProfile: ProfileModel(
                        type: UserType.user,
                        dateOfBirth: _dateOfBirth!,
                        username: _username!,
                        gender: _gender,
                        email: _email.toLowerCase(),
                        contact: _contact!,
                        creditScore: 100,
                        imageLink: imageUrl!,
                        status: AccountStatus.active,
                        lastLoggedInDate: formatDateTimeToDate(DateTime.now())),
                    password: _password!,
                    context: ctx)
              })
          .then((_) => {
                // AuthService().signInWithEmailAndPassword(email: _email, password: _password!),
                // debugPrint(AuthService().currentUser?.email),
                    Navigator.of(ctx).pushReplacementNamed(
                        '/authSignUp')
              });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(ctx).clearSnackBars();
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Sign up failed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> firstPage = [
      const Text(
        'Signup Step 1 out of 2',
        style: titleTextStyle,
      ),
      const VerticalEmptySpace(
        height: 20,
      ),
      CustomTextFormField(
        text: 'Username*',
        initialValue: _username,
        validator: emptyValidator(),
        actionOnChanged: (value) {
          _username = value;
        },
      ),
      const VerticalEmptySpace(),
      CustomTextFormField(
        text: 'Email*',
        initialValue: _email,
        validator: emailValidator(),
        actionOnChanged: (value) {
          _email = value;
        },
      ),
      const VerticalEmptySpace(),
      CustomTextFormField(
        text: 'Contact*',
        initialValue: _contact,
        validator: contactValidator(),
        actionOnChanged: (value) {
          _contact = value;
        },
      ),
      const VerticalEmptySpace(),
      PasswordField(
          text: 'New Password*',
          initialValue: _password,
          onChanged: (value) {
            setState(() {
              _password = value;
            });
          }),
      const VerticalEmptySpace(),
      PasswordField(
        text: 'Confirm Password*',
        initialValue: _password,
        customValidator: confirmPasswordValidator(_password),
      ),
      const VerticalEmptySpace(
        height: 50,
      ),
    ];
    Widget firstPageButton = CustomActionButton(
        displayText: 'Next',
        actionOnPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              isFirstPage = false;
            });
          }
        });
    List<Widget> secondPage = [
      const Text(
        'Signup Step 2 out of 2',
        style: titleTextStyle,
      ),
      const VerticalEmptySpace(
        height: 20,
      ),
      const Text(
        'Profile Picture*',
        style: mediumTextStyle,
      ),
      const VerticalEmptySpace(),
      CustomProfileImagePicker(
          actionOnPressed: (image) {
            setState(() {
              _image = image;
            });
          },
          imageFile: _image,
          imageLink:
              'https://firebasestorage.googleapis.com/v0/b/mae-assignment-f43cb.appspot.com/o/profile%2Fprofile_placeholder.jpeg?alt=media&token=029415b7-5f68-4361-aee0-53be1d212d60'),
      const VerticalEmptySpace(),
      const Text(
        'Date of Birth*',
        style: mediumTextStyle,
      ),
      TextFormField(
        controller: _dateOfBirthController,
        validator: dateValidator(),
        decoration: const InputDecoration(
          labelText: 'Date of Birth',
          prefixIcon: Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () {
          _selectDate(context);
        },
      ),
      const VerticalEmptySpace(),
      CustomGenderTextFormField(
          initialValue: _gender,
          actionOnChanged: (value) {
            setState(() {
              _gender = value;
            });
          }),
      const VerticalEmptySpace(
        height: 40,
      ),
    ];
    Widget secondPageButton = CustomActionButton(
        displayText: 'Sign Up',
        actionOnPressed: () {
          if (_formKey.currentState!.validate()) {
            if (_image == null) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please select an image.'),
                ),
              );
            } else {
              signUp(context);
            }
          }
        });
    return Scaffold(
      appBar: HeaderBar(
        headerTitle: 'Create New Account',
        menuRequired: false,
        textStyle: largeTextStyle,
        customAction: isFirstPage
            ? null
            : () {
                setState(() {
                  isFirstPage = !isFirstPage;
                });
              },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1,
              35, MediaQuery.of(context).size.width * 0.1, 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: isFirstPage ? firstPage : secondPage,
                    ))
              ]),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: isFirstPage ? firstPageButton : secondPageButton,
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
        _dateOfBirthController.text =
            formatDateTimeToStringDate(pickedDate); // Format the date
      });
    }
  }
}

class DateOfBirthPicker extends StatelessWidget {
  const DateOfBirthPicker(
      {super.key, required this.dateOfBirth, required this.dateOfBirthSetter});

  final String? dateOfBirth;
  final Function(String?) dateOfBirthSetter;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Initial date for the date picker
      firstDate: DateTime(1924), // The earliest date that can be selected
      lastDate: DateTime.now(), // The latest date that can be selected
    );

    if (pickedDate != null) {
      dateOfBirthSetter(formatDateTimeToStringDate(pickedDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: dateOfBirth,
      validator: dateValidator(),
      decoration: const InputDecoration(
        labelText: 'Date of Birth',
        prefixIcon: Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () {
        _selectDate(context);
      },
    );
  }
}
