import 'package:assignment/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:assignment/utils/form_vadidator.dart';

class PasswordField extends StatefulWidget {
  final String text;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? customValidator;

  const PasswordField({super.key, required this.text, this.initialValue, this.onChanged, this.customValidator,});

  @override
  State<PasswordField> createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: mediumTextStyle,
        ),
        TextFormField(
          initialValue: widget.initialValue,
          onChanged: widget.onChanged,
          obscureText: _isHidden,
          decoration: InputDecoration(
            // icon: Icon(Icons.password),
            // hintText: 'sample123!Pass',
            // labelText: 'Passowrd*',
            suffixIcon: IconButton(
              icon: Icon(_isHidden ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(
                  () {
                    _isHidden = !_isHidden;
                  },
                );
              },
            ),
          ),
          validator: widget.customValidator ?? passwordValidator(),
        )
      ],
    );
  }
}
