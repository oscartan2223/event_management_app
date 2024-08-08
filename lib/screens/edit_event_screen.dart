import 'dart:io';

import 'package:assignment/models/event_model.dart';
import 'package:assignment/providers/event_provider.dart';
import 'package:assignment/theme/fonts.dart';
import 'package:assignment/utils/formatter.dart';
import 'package:assignment/widgets/components/custom_buttons.dart';
import 'package:assignment/widgets/components/empty_space.dart';
import 'package:assignment/widgets/header_bar.dart';
import 'package:assignment/widgets/pickers/datetime_picker.dart';
import 'package:assignment/widgets/pickers/file_picker.dart';
import 'package:assignment/widgets/pickers/image_picker.dart';
import 'package:flutter/material.dart';

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({super.key});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  File? newImage;

  late List<Map<DateTime, DateTime>> sessions;
  late Map<String, String> materials;
  Map<String, File> newMaterials = {};

  bool isSessionsChanged = false;
  bool isMaterialsChanged = false;

  @override
  Widget build(BuildContext context) {
    EventModel event = ModalRoute.of(context)!.settings.arguments as EventModel;
    sessions = event.datetime;
    materials = event.materials ?? {};
    final String image = event.imageLink;
    return Scaffold(
      appBar: const HeaderBar(headerTitle: 'Edit Event', menuRequired: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(25, 35, 25, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: sessions.length * 110,
                child: ListView.builder(
                    itemCount: sessions.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Session ${index + 1}',
                                style: mediumTextStyle,
                              ),
                              CustomDateTimePicker(
                                setDatetime: (DateTime start, DateTime end) {
                                  isSessionsChanged = true;
                                  setState(() {
                                    sessions[index] = {start: end};
                                  });
                                },
                                lastDateTime: index > 0
                                    ? sessions[index - 1].values.first
                                    : DateTime.now()
                                        .add(const Duration(days: 1)),
                              ),
                              Visibility(
                                visible: sessions.length > 1,
                                child: CustomLink(
                                  displayText: 'Remove',
                                  actionOnPressed: () {
                                    isSessionsChanged = true;
                                    setState(() {
                                      sessions.removeAt(index);
                                    });
                                  },
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const Row(children: [
                            Expanded(
                                child: Text(
                              'Start Datetime: ',
                              style: smallTextStyle,
                            )),
                            Expanded(
                                child: Text(
                              'End Datetime:',
                              style: smallTextStyle,
                            ))
                          ]),
                          Row(children: [
                            Expanded(
                                child: Text(
                              sessions[index].isNotEmpty
                                  ? formatDateTimeToString(
                                      sessions[index].keys.first)
                                  : 'N/A',
                              style: smallTextStyle,
                            )),
                            Expanded(
                                child: Text(
                              sessions[index].isNotEmpty
                                  ? formatDateTimeToString(
                                      sessions[index].values.first)
                                  : 'N/A',
                              style: smallTextStyle,
                            ))
                          ]),
                          const Divider(),
                        ],
                      );
                    }),
              ),
              CustomLink(
                  displayText: 'Add one more day',
                  actionOnPressed: () {
                    setState(() {
                      if (sessions.last.isNotEmpty) {
                        isSessionsChanged = true;
                        sessions.add({});
                      } else {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Please select datetime for all sessions'),
                          ),
                        );
                      }
                    });
                  }),
              const VerticalEmptySpace(
                height: 24,
              ),
              CustomImagePicker(
                actionOnPressed: (image) {
                  setState(() {
                    newImage = image;
                  });
                },
                text: 'Event Image*',
              ),
              const VerticalEmptySpace(),
              Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: newImage != null
                        ? Image.file(newImage!, height: 200, width: 200)
                        : Image.network(image, height: 200, width: 200)),
              ),
              CustomFilePicker(
                  text: 'Pick a file',
                  actionOnPressed: (names, files) {
                    if (names.isNotEmpty && files.isNotEmpty) {
                      isMaterialsChanged = true;
                      for (int i = 0; i < names.length; i++) {
                        setState(() {
                          newMaterials[names[i]!] = files[i]!;
                          materials[names[i]!] = names[i]!;
                        });
                      }
                    }
                  }),
              const VerticalEmptySpace(),
              SizedBox(
                height: materials.length < 3 ? 100 : materials.length * 40,
                child: materials.isEmpty
                    ? const Center(
                        child: Text(
                        "Event Documents Goes Here...",
                        style: smallTextStyle,
                      ))
                    : ListView.builder(
                        itemCount: materials.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          String fileName = materials.keys.elementAt(index);
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
                                      isMaterialsChanged = true;
                                      setState(() {
                                        materials.remove(fileName);
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
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomActionButton(
                  displayText: 'Update',
                  width: 120,
                  height: 60,
                  actionOnPressed: () {
                    if (sessions.last.isEmpty) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Please select datetime for all sessions.'),
                        ),
                      );
                    } else {
                      _updateEvent(event);
                    }
                  }),
              CustomActionButton(
                  displayText: 'Cancel',
                  width: 120,
                  height: 60,
                  color: Colors.red,
                  actionOnPressed: () async {
                    bool? status = await _showConfirmationDialog(context);
                    if (status != null) {
                      if (status) {
                        _cancelEvent(event);
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateEvent(EventModel event) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    EventProvider()
        .editEvent(event,
            materials: isMaterialsChanged ? materials : null,
            newMaterials: isMaterialsChanged ? newMaterials : null,
            sessions: isSessionsChanged ? sessions : null,
            image: newImage)
        .then((updatedEvent) => {
              Navigator.of(context).pop(),
              if (updatedEvent != null)
                {
                  Navigator.of(context).pop(),
                  Navigator.of(context).pushReplacementNamed('/event_details',
                      arguments: updatedEvent)
                }
              else
                {
                  ScaffoldMessenger.of(context).clearSnackBars(),
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Update Event Failed!'),
                    ),
                  ),
                }
            });
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Cancellation',
            style: largeTextStyle,
          ),
          content: const Text(
            'Are you sure you want to cancel the event?',
            style: mediumTextStyle,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Back',
                style: mediumTextStyle,
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text(
                'Cancel',
                style: mediumTextStyle,
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelEvent(EventModel event) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    EventProvider().cancelEvent(event).then((updatedEvent) => {
          Navigator.of(context).pop(),
          if (updatedEvent != null)
            {
              Navigator.of(context).pop(),
              Navigator.of(context).pushReplacementNamed('/event_details',
                  arguments: updatedEvent)
            }
          else
            {
              ScaffoldMessenger.of(context).clearSnackBars(),
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Event Cancellation Failed!'),
                ),
              ),
            }
        });
  }
}
