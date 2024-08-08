import 'package:assignment/models/profile_model.dart';
import 'package:assignment/providers/profile_provider.dart';
import 'package:assignment/theme/fonts.dart';
import 'package:assignment/widgets/header_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserType userType = Provider.of<ProfileProvider>(context).userProfile!.type;
    ProfileModel userProfile =
        ModalRoute.of(context)!.settings.arguments as ProfileModel;
    return Scaffold(
      appBar: const HeaderBar(headerTitle: 'Profile', menuRequired: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column 1: Avatar and User Type
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(userProfile.imageLink),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userProfile.type.toString().split('.').last,
                      style: smallTextStyle
                    ),
                  ],
                ),
                const SizedBox(width: 20),

                // Column 2: Remaining Space (for Event Joined and Credit Score)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row for Event Joined and Credit Score with enforced height
                      SizedBox(
                        height: 70, // Set the height for the row
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // Center vertically
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center vertically within column
                                children: [
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minHeight: 70,
                                      maxHeight: 70,
                                    ),
                                    child: const Center(
                                      // Center text vertically
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('0'),
                                          Text('Event Joined'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                                width: 20), // Space between the columns
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center vertically within column
                                children: [
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minHeight: 70,
                                      maxHeight: 70,
                                    ),
                                    child: const Center(
                                      // Center text vertically
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('100'),
                                          Text('Credit Score'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Row for Report User Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.warning,
                            color: Colors.red,
                          ),
                          if (userType == UserType.administrator)
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/ban_user', arguments: userProfile);
                              },
                              child: const Text('Ban User', style: TextStyle(color: Colors.red)),
                            )
                          else
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed('/report_user', arguments: {'control': '', 'email': userProfile.email, 'username': userProfile.username});
                              },
                              child: const Text('Report User', style: TextStyle(color: Colors.red)),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Text fields for additional user information
            TextFormField(
              readOnly: true,
              initialValue: userProfile.username,// Default value
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    initialValue: userProfile.dateOfBirth,
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    initialValue: userProfile.gender.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              initialValue: userProfile.email,
              decoration: const InputDecoration(
                labelText: 'Email Address',
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              readOnly: true,
              initialValue: userProfile.contact,
              decoration: const InputDecoration(
                labelText: 'Contact Number',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
