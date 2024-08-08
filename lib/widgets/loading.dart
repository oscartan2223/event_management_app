import 'package:assignment/theme/fonts.dart';
import 'package:flutter/material.dart';

class CustomLoading extends StatelessWidget {
  const CustomLoading({super.key, required this.loadingText});

  final String loadingText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(loadingText, style: headerTextStyle,),
      ),
    );
  }
}