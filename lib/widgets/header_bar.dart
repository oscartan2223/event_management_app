import 'package:flutter/material.dart';

class HeaderBar extends StatelessWidget implements PreferredSizeWidget {
  const HeaderBar({
    super.key,
    required this.headerTitle,
    required this.menuRequired,
    this.textStyle,
    this.customAction,
  });

  final String headerTitle;
  final bool menuRequired;
  final TextStyle? textStyle;
  final VoidCallback? customAction;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(
          headerTitle,
        ),
        leading: customAction != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: customAction,
              )
            : null,
        // actions: menuRequired ? [
        //   GestureDetector(
        //     onTap: () {},
        //     child: Container(
        //       margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        //       alignment: Alignment.center,
        //       child: const MenuIconButton(),
        //     ),
        //   ),
        // ] : null
        );
  }

  @override
  Size get preferredSize => const Size.fromHeight(66);
}
