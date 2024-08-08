import 'package:assignment/models/profile_model.dart';
import 'package:assignment/theme/fonts.dart';
import 'package:assignment/utils/form_vadidator.dart';
import 'package:assignment/widgets/components/empty_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.text,
    this.initialValue,
    required this.validator,
    required this.actionOnChanged,
    this.hintText,
    this.controller,
  });

  final String text;
  final String? initialValue;
  final String? Function(String?)? validator;
  final Function(String) actionOnChanged;
  final String? hintText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: mediumTextStyle,
        ),
        TextFormField(
          initialValue: initialValue,
          onChanged: actionOnChanged,
          decoration: InputDecoration(hintText: hintText ?? ''),
          validator: validator,
          controller: controller,
        )
      ],
    );
  }
}

class CustomTextArea extends StatelessWidget {
  const CustomTextArea({
    super.key,
    required this.text,
    this.initialValue,
    required this.validator,
    required this.actionOnChanged,
  });

  final String text;
  final String? initialValue;
  final String? Function(String?)? validator;
  final Function(String) actionOnChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: mediumTextStyle,
        ),
        const VerticalEmptySpace(
          height: 5,
        ),
        TextFormField(
          initialValue: initialValue,
          onChanged: actionOnChanged,
          decoration: InputDecoration(
            labelText: text,
            border: const OutlineInputBorder()),
          validator: validator,
          maxLines: 8,
        )
      ],
    );
  }
}

class CustomNumericalTextFormField extends StatelessWidget {
  const CustomNumericalTextFormField(
      {super.key,
      required this.text,
      this.initialValue,
      required this.validator,
      required this.actionOnChanged,
      this.hintText,
      this.allowDecimal});

  final String text;
  final String? initialValue;
  final String? Function(String?)? validator;
  final Function(String) actionOnChanged;
  final String? hintText;
  final bool? allowDecimal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: mediumTextStyle,
        ),
        TextFormField(
          initialValue: initialValue,
          onChanged: actionOnChanged,
          decoration: InputDecoration(hintText: hintText ?? ''),
          validator: validator,
          keyboardType: allowDecimal == true
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            allowDecimal == true
                ? FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                : FilteringTextInputFormatter.digitsOnly
          ],
        )
      ],
    );
  }
}

class CustomGenderTextFormField extends StatefulWidget {
  final Gender initialValue;
  final void Function(Gender) actionOnChanged;

  const CustomGenderTextFormField(
      {super.key, required this.initialValue, required this.actionOnChanged});

  @override
  State<CustomGenderTextFormField> createState() =>
      _CustomGenderTextFormFieldState();
}

class _CustomGenderTextFormFieldState extends State<CustomGenderTextFormField> {
  late Gender selectedGender;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender*',
          style: mediumTextStyle,
        ),
        DropdownButtonFormField(
          validator: emptyEnumValidator(),
          hint: const Text(
            'Select your gender',
          ),
          items: Gender.values.map((Gender gender) {
            return DropdownMenuItem<Gender>(
              value: gender,
              child: Text(gender.toString().split('.').last),
            );
          }).toList(),
          onChanged: (Gender? gender) {
            setState(() {
              selectedGender = gender!;
            });
            widget.actionOnChanged(selectedGender);
          },
          value: selectedGender,
          // decoration: const InputDecoration(border: OutlineInputBorder()),
          iconSize: 28,
        )
      ],
    );
  }
}
