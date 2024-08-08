import 'package:assignment/services/auth_service.dart';
import 'package:assignment/widgets/components/custom_buttons.dart';
import 'package:assignment/widgets/components/password_field.dart';
import 'package:assignment/theme/fonts.dart';
import 'package:assignment/utils/form_vadidator.dart';
import 'package:assignment/widgets/loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = '';
  bool isLogin = true;

  String _email = '';
  String _password = '';
  final _formKey = GlobalKey<FormState>();

  Future<void> signInWithEmailAndPassword() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => (const CustomLoading(loadingText: 'Logging in...'))));
    String message = await AuthService()
        .signInWithEmailAndPassword(
      email: _email.toLowerCase(),
      password: _password,
    )
        .then((message) {
      Navigator.of(context).pop();
      return message;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
      if (message == 'Success') {
        // Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: HeaderBar(headerTitle: 'Login'),
        body: SafeArea(
            child: Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: 0, horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                width: 180,
                height: 180,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // const HeaderText(text: 'Login'),

            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login',
                    style: titleTextStyle,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'Email*',
                    style: mediumTextStyle,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      _email = value;
                    },
                    decoration: const InputDecoration(
                        // icon: Icon(Icons.email),
                        // hintText: 'example@gmail.com',
                        // labelText: 'Email*',
                        ),
                    validator: emailValidator(),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  PasswordField(
                    text: 'Password*',
                    onChanged: (value) {
                      _password = value;
                    },
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    CustomLink(
                      displayText: "Forgot Password?",
                      actionOnPressed: () {
                        Navigator.of(context).pushNamed('/forgotPassword');
                      },
                    ),
                  ]),
                  const SizedBox(
                    height: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomActionButton(
              displayText: 'Login',
              actionOnPressed: () {
                if (_formKey.currentState!.validate()) {
                  signInWithEmailAndPassword();
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Divider(
                  height: 2,
                  thickness: 5,
                  indent: 0,
                  endIndent: 0,
                  color: Colors.black,
                ),
                // Text(
                //   'or login with',
                //   style: mediumTextStyle,
                // ),
              ],
            ),
            RichText(
                text: TextSpan(children: <TextSpan>[
              const TextSpan(
                text: 'New to GesT? Register ',
                style: smallTextStyle,
              ),
              TextSpan(
                  text: 'here',
                  style: linkTextStyle,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.of(context).pushNamed('/signup');
                    })
            ])),
            // const SizedBox(
            //   height: 15,
            // ),
          ],
        ),
      ),
    )));
  }
}
