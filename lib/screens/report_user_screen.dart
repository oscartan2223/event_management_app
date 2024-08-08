// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:assignment/models/request_model.dart';
import 'package:assignment/providers/profile_provider.dart';
import 'package:assignment/providers/request_provider.dart';
import 'package:assignment/theme/fonts.dart';
import 'package:assignment/utils/form_vadidator.dart';
import 'package:assignment/utils/formatter.dart';
import 'package:assignment/widgets/components/custom_buttons.dart';
import 'package:assignment/widgets/components/empty_space.dart';
import 'package:assignment/widgets/header_bar.dart';
import 'package:assignment/widgets/pickers/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportUserScreen extends StatefulWidget {
  const ReportUserScreen({super.key});

  @override
  State<ReportUserScreen> createState() => _ReportUserScreenState();
}

class _ReportUserScreenState extends State<ReportUserScreen> {
  final Map<String, File> _supportingDocs = {};
  final _formKey = GlobalKey<FormState>();
  late Map<String, String> targetUser;
  String? _desc;

  Future<void> _validateUserEmail(String? email) async {
    if (email != null) {
      String? username = await ProfileProvider().userExist(email);
      if (username != null) {
        targetUser['email'] = email;
        setState(() {
          targetUser['username'] = username;
        });
      } else {
        setState(() {
          targetUser['email'] = '';
          targetUser['username'] = '';
        });
      }
    }
  }

  Future<void> _submitReport() async {

    if (targetUser['email']! == ProfileProvider().userProfile!.email) {
      ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Don\'t try to report yourself!'),
          ),
        );
      Navigator.of(context).pop();
      return;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    RequestProvider()
        .makeRequest(
            ReportModel(
                userEmail: Provider.of<ProfileProvider>(context, listen: false)
                    .userProfile!
                    .email,
                reportedUserEmail: targetUser['email']!,
                date: formatDateTime(DateTime.now()),
                status: 'Pending Review',
                type: 'Report User',
                description: _desc!,
                supportingDocs: {}),
            _supportingDocs)
        .then((status) {
      Navigator.of(context).pop();
      if (status) {
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report Failed!'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //will have three keys and values (control, email, username)
    targetUser =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    return Scaffold(
      appBar: const HeaderBar(headerTitle: 'Report User', menuRequired: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Report Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: targetUser['control'] != null,
                initialValue: targetUser['email'] ?? '',
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: emailValidator(),
                onSaved: (value) {
                  if (value != null) {
                    _validateUserEmail(value);
                  }
                },
                onFieldSubmitted: (value) {
                  _validateUserEmail(value);
                },
              ),
              if (targetUser['control'] != null)
              const VerticalEmptySpace(height: 20),
              if (targetUser['control'] != null)
              TextFormField(
                readOnly: true,
                initialValue: targetUser['username'] ?? '',
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),
              const VerticalEmptySpace(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Request Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: emptyValidator(),
                onSaved: (value) {
                  _desc = value;
                },
              ),
              const SizedBox(height: 16),
              CustomFilePicker(actionOnPressed: (names, files) {
                if (names.isNotEmpty && files.isNotEmpty) {
                  for (int i = 0; i < names.length; i++) {
                    setState(() {
                      _supportingDocs[names[i]!] = files[i]!;
                    });
                  }
                }
              }),
              const VerticalEmptySpace(),
              SizedBox(
                height: _supportingDocs.length < 3
                    ? 100
                    : _supportingDocs.length * 40,
                child: _supportingDocs.isEmpty
                    ? const Center(
                        child: Text(
                        "Supporting Documents Goes Here...",
                        style: smallTextStyle,
                      ))
                    : ListView.builder(
                        itemCount: _supportingDocs.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          String fileName =
                              _supportingDocs.keys.elementAt(index);
                          IconData fileIcon;
                          if (fileName.endsWith('.pdf')) {
                            fileIcon = Icons.picture_as_pdf;
                          } else if (fileName.endsWith('.png') ||
                              fileName.endsWith('.jpg') ||
                              fileName.endsWith('.jpeg')) {
                            fileIcon = Icons.image;
                          } else if (fileName.endsWith('.xlsx') ||
                              fileName.endsWith('.xls')) {
                            fileIcon = Icons.table_chart;
                          } else {
                            fileIcon = Icons.insert_drive_file;
                          }
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Icon(fileIcon),
                                  Expanded(
                                    child: Text(
                                      fileName,
                                      style: smallTextStyle,
                                    ),
                                  ),
                                  CustomLink(
                                    displayText: 'Remove',
                                    actionOnPressed: () {
                                      setState(() {
                                        _supportingDocs.remove(fileName);
                                      });
                                    },
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          );
                        }),
              ),
              // const SizedBox(height: 32),
              const SizedBox(height: 48), // Add spacing before button
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: CustomActionButton(
            displayText: 'Submit Request',
            actionOnPressed: () {
              if (_formKey.currentState!.validate()) {
                if (_supportingDocs.isEmpty) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please provide a supporting document.'),
                    ),
                  );
                } else {
                  _formKey.currentState!.save();
                  _submitReport();
                }
              }
            }),
      ),
    );
  }
}
