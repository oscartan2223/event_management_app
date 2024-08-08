import 'package:assignment/models/profile_model.dart';
import 'package:assignment/services/auth_service.dart';
import 'package:assignment/theme/fonts.dart';
import 'package:assignment/widgets/components/empty_space.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userProfile});

  final ProfileModel userProfile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
              color: const Color.fromARGB(255, 222, 222, 222),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
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
                        style: smallTextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),

                  // Column 2: Remaining Space (for Event Joined and Credit Score)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                                      child: Center(
                                        // Center text vertically
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              userProfile.eventHistory!.length
                                                  .toString(),
                                              style: smallTextStyle,
                                            ),
                                            const Text(
                                              'Event Joined',
                                              style: smallTextStyle,
                                            ),
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
                                      child: Center(
                                        // Center text vertically
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              userProfile.creditScore
                                                  .toString(),
                                              style: smallTextStyle,
                                            ),
                                            const Text(
                                              'Credit Score',
                                              style: smallTextStyle,
                                            ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed('/edit_profile');
                              },
                              child: const Text('Edit Profile', style: linkTextStyle,),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              initialValue: userProfile.username,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const VerticalEmptySpace(),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    initialValue: userProfile.dateOfBirth,
                    decoration: const InputDecoration(
                      labelText: 'Date of birth',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    initialValue: userProfile.gender.toString().split('.').last,
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                    ),
                  ),
                ),
              ],
            ),
            const VerticalEmptySpace(),
            TextFormField(
              readOnly: true,
              initialValue: userProfile.email,
              decoration: const InputDecoration(
                labelText: 'Email Address',
              ),
            ),
            const VerticalEmptySpace(),
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
            
          ],
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: () {
                  AuthService().signOut();
                },
                child: const Icon(Icons.logout),
              ),
              const VerticalEmptySpace(),
              const Text(
                'Logout',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
