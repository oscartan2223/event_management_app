import 'package:assignment/services/auth_service.dart';
import 'package:assignment/theme/fonts.dart';
import 'package:assignment/utils/form_vadidator.dart';
import 'package:assignment/widgets/components/custom_buttons.dart';
import 'package:assignment/widgets/components/custom_input_fields.dart';
import 'package:assignment/widgets/components/empty_space.dart';
import 'package:assignment/widgets/header_bar.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String email = '';
  final _formKey = GlobalKey<FormState>();

  Future<void> sendResetEmail() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    bool status =
        await AuthService().sendResetEmail(email.toLowerCase().trim());
    if (mounted) {
      if (status) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reset Password Email is Sent!'),
          ),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reset Password Sending Failed!'),
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeaderBar(headerTitle: 'Forgot Password', menuRequired: false),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 18),
        child: 
        Form(
          key: _formKey,
          child: 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reset Password',
              style:
                  titleTextStyle.copyWith(decoration: TextDecoration.underline),
            ),
            const VerticalEmptySpace(),
            CustomTextFormField(
                text: 'Email*',
                validator: emailValidator(),
                actionOnChanged: (value) {
                  email = value;
                }),
            const VerticalEmptySpace(),
            
          ],
        ),
      ),),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CustomActionButton(
                displayText: 'Send Link to Email', actionOnPressed: () {
                  if (_formKey.currentState!.validate()) {
                    sendResetEmail();
                  }
                }),
        ),
      ),
    );
  }
}
