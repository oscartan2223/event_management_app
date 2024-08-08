// ignore_for_file: unused_import

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
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class RequestFeedbackScreen extends StatefulWidget {
  const RequestFeedbackScreen({super.key});

  @override
  State<RequestFeedbackScreen> createState() => _RequestFeedbackScreenState();
}

class _RequestFeedbackScreenState extends State<RequestFeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  // List<String> requestTypes = [
  //   'Request for Event Organizer Role',
  //   'Provide Feeback'
  // ];
  final Map<String, File> _supportingDocs = {};
  late String _requestType;
  String? _desc;

  Future<void> _submitRequest() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    RequestProvider().makeRequest(
        RequestModel(
            userEmail: Provider.of<ProfileProvider>(context, listen: false)
                .userProfile!
                .email,
            date: formatDateTimeToDate(DateTime.now()),
            status: 'Pending Review',
            type: _requestType,
            description: _desc!,
            supportingDocs: {}),
        _supportingDocs).then((status) {
      Navigator.of(context).pop();
      if (status) {
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$_requestType Failed!'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _requestType = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: HeaderBar(headerTitle: _requestType, menuRequired: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Request Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                readOnly: true,
                initialValue: _requestType,
                decoration: const InputDecoration(
                  labelText: 'Request Type',
                ),
              ),
              // DropdownButtonFormField<String>(
              //   value: _requestType,
              //   hint: const Text('Request for Event Organizer Role'),
              //   onChanged: (String? newValue) {
              //     if (newValue != null) {
              //       setState(() {
              //         _requestType = newValue;
              //       });
              //     }
              //   },
              //   items: requestTypes.map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(value),
              //     );
              //   }).toList(),
              //   decoration: const InputDecoration(
              //     labelText: 'Request Type',
              //     border: OutlineInputBorder(),
              //   ),
              // ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Report Description',
                  hintText: 'Add text',
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
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
                  _submitRequest();
                }
              }
            }),
      ),
    );
  }
}
