import 'package:assignment/theme/fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:assignment/theme/colors.dart';

class CustomLink extends StatelessWidget {
  const CustomLink(
      {super.key, required this.displayText, required this.actionOnPressed, this.color, this.fontSize});

  final String displayText;
  final VoidCallback actionOnPressed;
  final Color? color;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: actionOnPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap
        ),
        child: Text(
          displayText,
          style: linkTextStyle.copyWith(color: color, decorationColor: color, fontSize: fontSize),
        ));
  }
}

class CustomLogoutButton extends StatelessWidget {
  const CustomLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        FirebaseAuth.instance.signOut();
        Navigator.of(context).pushReplacementNamed('/login');
      },
      icon: const Icon(Icons.logout),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
            const Color.fromARGB(194, 235, 235, 235)),
        fixedSize: WidgetStateProperty.all<Size>(const Size(50, 50)),
      ),
    );
  }
}

class CustomLogoutButtonText extends StatelessWidget {
  const CustomLogoutButtonText({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
          Navigator.of(context).pushReplacementNamed('/login');
        },
        child: const Text(
          'Logout',
          style: mediumTextStyle,
        ));
  }
}

class CustomActionButton extends StatelessWidget {
  ///A button with white color font
  ///blue background & blue violet outline
  final double? width;
  final double? height;
  final Color? color;
  const CustomActionButton(
      {super.key, required this.displayText, required this.actionOnPressed, this.width, this.height, this.color});

  final String displayText;
  final VoidCallback actionOnPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: actionOnPressed,
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all<Color>(color ?? const Color(0xFF27A1FF)),
          minimumSize: WidgetStateProperty.all<Size>(
          Size(width ?? MediaQuery.of(context).size.width * 0.8, height ?? 60)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  side: const BorderSide(
                      color: CustomizedColors.selectedColor, width: 2),
                  borderRadius: BorderRadius.circular((height ?? 60) / 5))),
        ),
        child: Text(
          displayText,
          style: largeTextStyle.copyWith(color: Colors.white),
        ));
  }
}



class MenuIconButton extends StatelessWidget {
///this is for menu
  const MenuIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: const Icon(Icons.menu),
      color: Colors.black,
      iconSize: 36,
    );
  }
}
