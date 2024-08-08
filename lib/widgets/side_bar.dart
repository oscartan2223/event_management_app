import 'package:assignment/models/profile_model.dart';
import 'package:assignment/services/auth_service.dart';
import 'package:assignment/theme/fonts.dart';
import 'package:assignment/widgets/components/empty_space.dart';
import 'package:flutter/material.dart';

class CustomSideBar extends StatelessWidget {
  const CustomSideBar(
      {super.key,
      required this.accountName,
      required this.imageUrl,
      required this.userType});

  final String accountName;
  final String imageUrl;
  final UserType userType;

  @override
  Widget build(BuildContext context) {
    late List<MenuItems> menuItems;
    if (userType == UserType.user) {
      menuItems = [
        MenuItems(
          icon: Icons.info,
          text: 'FAQs',
          actionOnTap: () {
            Navigator.of(context).pushNamed('/faq');
          },
        ),
        MenuItems(
          icon: Icons.flag,
          text: 'Provide Feedback',
          actionOnTap: () {
            Navigator.of(context).pushNamed('/make_request_feedback',
                arguments: 'Feedback');
          },
        ),
        MenuItems(
          icon: Icons.edit_document,
          text: 'Request for Event Organizer Role',
          actionOnTap: () {
            Navigator.of(context).pushNamed('/make_request_feedback',
                arguments: 'Organizer Role Request');
          },
        ),
        MenuItems(
          icon: Icons.history,
          text: 'Past Request & Feedback',
          actionOnTap: () {
            Navigator.of(context).pushNamed('/view_past_request');
          },
        ),
        MenuItems(
          icon: Icons.warning,
          text: 'Report User',
          actionOnTap: () {
            Navigator.of(context).pushNamed('/report_user', arguments: <String, String>{});
          },
          color: Colors.red,
        ),
        MenuItems(
          icon: Icons.logout,
          text: 'Logout',
          actionOnTap: () {
            AuthService().signOut();
            // Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
          },
          color: Colors.red,
        ),
      ];
    } else if (userType == UserType.organizer) {
      menuItems = [
        MenuItems(
          icon: Icons.info,
          text: 'FAQs',
          actionOnTap: () {
            Navigator.of(context).pushNamed('/faq');
          },
        ),
        MenuItems(
          icon: Icons.flag,
          text: 'Provide Feedback',
          actionOnTap: () {
            Navigator.of(context).pushNamed('/make_request_feedback',
                arguments: 'Provide Feedback');
          },
        ),
        MenuItems(
          icon: Icons.history,
          text: 'Past Request & Feedback',
          actionOnTap: () {
            Navigator.of(context).pushNamed('/view_past_request');
          },
        ),
        MenuItems(
          icon: Icons.warning,
          text: 'Report User',
          actionOnTap: () {
            Navigator.of(context).pushNamed('/report_user', arguments: <String, String>{});
          },
          color: Colors.red,
        ),
        MenuItems(
          icon: Icons.logout,
          text: 'Logout',
          actionOnTap: () {
            AuthService().signOut();
            // FirebaseAuth.instance.signOut();
            // Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
          },
          color: Colors.red,
        ),
      ];
    } else {
      menuItems = [
        MenuItems(
          icon: Icons.info,
          text: 'FAQs',
          actionOnTap: () {
            Navigator.of(context).pushNamed('/faq');
          },
        ),
        // MenuItems(
        //   icon: Icons.edit_document,
        //   text: 'Manage Requests',
        //   actionOnTap: () {},
        // ),
        // MenuItems(
        //   icon: Icons.warning,
        //   text: 'Ban User',
        //   actionOnTap: () {
        //     Navigator.of(context).pushNamed('/ban_user', arguments: {});
        //   },
        //   color: Colors.red,
        // ),
        MenuItems(
          icon: Icons.logout,
          text: 'Logout',
          actionOnTap: () {
            AuthService().signOut();
            // FirebaseAuth.instance.signOut();
            // Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
          },
          color: Colors.red,
        ),
      ];
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
              height: 288,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 152, 152, 152),
                  Colors.amber,
                ])),
                child: Column(
                  children: [
                    ClipOval(
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        color: Colors.white,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                          radius: 65,
                        ),
                      ),
                    ),
                    const VerticalEmptySpace(),
                    Text(
                      'Welcome to GesT!',
                      style: largeTextStyle.copyWith(color: Colors.white),
                    ),
                    Text(
                      accountName,
                      style: mediumTextStyle.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              )),
          Container(
              height: 500,
              padding: const EdgeInsets.only(left: 10),
              child: ListView.builder(
                  itemCount: menuItems.length,
                  itemBuilder: (context, index) => ListTile(
                        leading: Icon(
                          menuItems[index].icon,
                          color: menuItems[index].color ?? Colors.black,
                          size: 28,
                        ),
                        title: Text(
                          menuItems[index].text,
                          style: smallTextStyle.copyWith(
                              color: menuItems[index].color ?? Colors.black),
                        ),
                        onTap: menuItems[index].actionOnTap,
                      )))
        ],
      ),
    );
  }
}

class MenuItems {
  final IconData icon;
  final String text;
  final VoidCallback actionOnTap;
  final Color? color;

  MenuItems({
    required this.icon,
    required this.text,
    required this.actionOnTap,
    this.color,
  });
}
