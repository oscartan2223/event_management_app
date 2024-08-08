import 'dart:io';

import 'package:assignment/models/event_model.dart';
import 'package:assignment/providers/event_provider.dart';
import 'package:assignment/providers/profile_provider.dart';
import 'package:assignment/utils/formatter.dart';
import 'package:assignment/widgets/pickers/datetime_picker.dart';
import 'package:assignment/widgets/pickers/file_picker.dart';
import 'package:assignment/widgets/pickers/image_picker.dart';
import 'package:assignment/widgets/pickers/location_picker.dart';
import 'package:assignment/theme/fonts.dart';
import 'package:assignment/utils/form_vadidator.dart';
import 'package:assignment/widgets/components/custom_buttons.dart';
import 'package:assignment/widgets/components/custom_input_fields.dart';
import 'package:assignment/widgets/components/empty_space.dart';
import 'package:assignment/widgets/header_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class OrganizeEventScreen extends StatefulWidget {
  const OrganizeEventScreen({super.key});

  @override
  State<OrganizeEventScreen> createState() => _OrganizeEventScreenState();
}

class _OrganizeEventScreenState extends State<OrganizeEventScreen> {
  int _currentPage = 0;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();
  late ProfileProvider provider;

  final ScrollController _scrollController = ScrollController();

  LatLng? _location = const LatLng(3.15, 101.689);
  final List<Map<DateTime, DateTime>> _eventDateTime = [
    {DateTime.now(): DateTime.now().add(const Duration(hours: 2))}
  ];
  EventType _eventType = EventType.exhibition;
  String? _eventTitle = 'TemporaryTitle';
  String? _eventDesc = 'Temporary Description';
  String? _contact = '0101101010';
  double? _eventFees = 10;
  int? _capacity = 10;

  // LatLng? _location;
  // final List<Map<DateTime, DateTime>> _eventDateTime = [
  //   {DateTime.now(): DateTime.now().add(const Duration(hours: 2))}
  // ];
  // EventType _eventType = EventType.exhibition;
  // String? _eventTitle;
  // String? _eventDesc;
  // String? _contact;
  // double? _eventFees;
  // int? _capacity;
  bool _isAnonymous = false;
  File? _image;
  final Map<String, File> _eventMaterials = {};

  @override
  void initState() {
    _locationController.addListener(() {
      final text = _locationController.text.trim();
      if (!text.isValidLocation) {
        _locationController.value = TextEditingValue(
            text: _location != null ? formatLocationToString(_location!) : '');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickLocation() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => (CustomLocationPicker(
          setLocation: (LatLng location) {
            setState(() {
              _location = location;
            });
          },
          controller: _locationController,
          initialValue: _location,
        )),
      ),
    );
  }

  Future<void> organizeEvent() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    EventProvider eventProvider =
        Provider.of<EventProvider>(context, listen: false);
    // String email = Provider.of<ProfileProvider>(context, listen: false).userProfile!.email;
    eventProvider
        .organizeEvent(
            EventModel(
              organizerEmail:
                  Provider.of<ProfileProvider>(context, listen: false)
                      .userProfile!
                      .email,
              title: _eventTitle!,
              description: _eventDesc!,
              venue: formatLocationToString(_location!),
              fees: _eventFees!,
              contact: _contact!,
              type: _eventType,
              datetime: _eventDateTime,
              capacity: _capacity!,
              imageLink: 'temp',
              isAnonymous: _isAnonymous,
              status: EventStatus.scheduled,
            ),
            _image!,
            _eventMaterials)
        .then((eventOrganized) => {
              Navigator.of(context).pop(),
              if (eventOrganized != null)
                {
                  Navigator.of(context)
                      .pushReplacementNamed('/event_details', arguments: eventOrganized)
                }
              else
                {
                  ScaffoldMessenger.of(context).clearSnackBars(),
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Event Organized Failed!'),
                    ),
                  ),
                  // Navigator.of(context).pop(),
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    //-------------------------------------First Page-----------------------------------------//
    List<Widget> firstPage = [
      Text(
        'Step 1: Event Info',
        style: largeTextStyle.copyWith(decoration: TextDecoration.underline),
      ),
      const VerticalEmptySpace(),
      Text(
        'Event Type',
        style: mediumTextStyle.copyWith(decoration: TextDecoration.underline),
      ),
      const VerticalEmptySpace(),
      Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        trackVisibility: true,
        child: Container(
          height: 250,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(10)),
          child: GridView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 4 / 10),
            itemCount: EventType.values.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _eventType = EventType.values[index];
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: _eventType == EventType.values[index]
                        ? Colors.amber
                        : const Color.fromARGB(255, 182, 182, 182),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    EventType.values[index].toString().split('.').last,
                    style: mediumTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      const VerticalEmptySpace(),
      Text(
        'Location',
        style: mediumTextStyle.copyWith(decoration: TextDecoration.underline),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _location == null
              ? const Text(
                  'N/A',
                  style: mediumTextStyle,
                )
              : CustomLink(
                  displayText: formatLocationToString(_location!),
                  actionOnPressed: _pickLocation,
                  fontSize: 20,
                ),
          IconButton(
              onPressed: _pickLocation,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.map,
                size: 28,
                color: Colors.blue,
              ))
        ],
      ),
      const VerticalEmptySpace(),
      Text(
        'Datetime',
        style: mediumTextStyle.copyWith(decoration: TextDecoration.underline),
      ),
      SizedBox(
        height: _eventDateTime.length * 110,
        child: ListView.builder(
            itemCount: _eventDateTime.length,
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
                          setState(() {
                            _eventDateTime[index] = {start: end};
                          });
                        },
                        lastDateTime: index > 0
                            ? _eventDateTime[index - 1].values.first
                            : DateTime.now().add(const Duration(days: 1)),
                      ),
                      Visibility(
                        visible: _eventDateTime.length > 1,
                        child: CustomLink(
                          displayText: 'Remove',
                          actionOnPressed: () {
                            setState(() {
                              _eventDateTime.removeAt(index);
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
                      _eventDateTime[index].isNotEmpty
                          ? formatDateTimeToString(
                              _eventDateTime[index].keys.first)
                          : 'N/A',
                      style: smallTextStyle,
                    )),
                    Expanded(
                        child: Text(
                      _eventDateTime[index].isNotEmpty
                          ? formatDateTimeToString(
                              _eventDateTime[index].values.first)
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
              if (_eventDateTime.last.isNotEmpty) {
                _eventDateTime.add({});
              } else {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select datetime for all sessions'),
                  ),
                );
              }
            });
          }),
      // const VerticalEmptySpace(
      //   height: 24,
      // ),
      // Center(
      //   child: ,
      // ),
      // const VerticalEmptySpace(),
    ];
    Widget firstPageButton = CustomActionButton(
            displayText: 'Continue',
            actionOnPressed: () {
              setState(() {
                if (_eventDateTime.last.isEmpty) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select datetime for all sessions.'),
                    ),
                  );
                } else if (_location == null) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select the location.'),
                    ),
                  );
                } else {
                  _currentPage++;
                }
              });
            });
    //-------------------------------------Second Page-----------------------------------------//
    List<Widget> secondPage = [
      Text(
        'Step 2: Event Info',
        style: largeTextStyle.copyWith(decoration: TextDecoration.underline),
      ),
      const VerticalEmptySpace(),
      CustomTextFormField(
          text: 'Event Title',
          initialValue: _eventTitle,
          validator: emptyValidator(),
          actionOnChanged: (value) {
            _eventTitle = value;
          }),
      const VerticalEmptySpace(
        height: 18,
      ),
      CustomTextArea(
        text: 'Event Description',
        initialValue: _eventDesc,
        validator: emptyValidator(),
        actionOnChanged: (value) {
          _eventDesc = value;
        },
      ),
      const VerticalEmptySpace(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: CustomNumericalTextFormField(
              text: 'Fees (RM)',
              initialValue: _eventFees.toString(),
              validator: emptyValidator(),
              actionOnChanged: (value) {
                _eventFees = double.parse(value);
              },
              allowDecimal: true,
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              child: CustomNumericalTextFormField(
                text: 'Capacity',
                initialValue: _capacity.toString(),
                validator: emptyValidator(),
                actionOnChanged: (value) {
                  _capacity = int.parse(value);
                },
                hintText: '0 for no limit',
              )),
        ],
      ),
      const VerticalEmptySpace(),
      CustomNumericalTextFormField(
          text: 'Event Contact',
          initialValue: _contact,
          validator: contactValidator(),
          actionOnChanged: (value) {
            _contact = value;
          }),
      // const VerticalEmptySpace(
      //   height: 24,
      // ),
      // Center(
      //   child: ,
      // ),
      // const VerticalEmptySpace(),
    ];
    Widget secondPageButton = CustomActionButton(
            displayText: 'Continue',
            actionOnPressed: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _currentPage++;
                });
              }
            });
    //-------------------------------Third Page------------------------------//
    List<Widget> thirdPage = [
      Text(
        'Step 3: Event Info',
        style: largeTextStyle.copyWith(decoration: TextDecoration.underline),
      ),
      const VerticalEmptySpace(),
      Row(
        children: [
          Checkbox(
            value: _isAnonymous,
            onChanged: (_) {
              setState(() {
                _isAnonymous = !_isAnonymous;
              });
            },
            activeColor: Colors.amber,
            checkColor: const Color.fromARGB(255, 255, 239, 192),
            shape: const RoundedRectangleBorder(),
          ),
          const Text(
            'Keep Participants Anonymous',
            style: mediumTextStyle,
          )
        ],
      ),
      const VerticalEmptySpace(),
      CustomImagePicker(
        actionOnPressed: (image) {
          setState(() {
            _image = image;
          });
        },
        text: 'Event Image*',
      ),
      const VerticalEmptySpace(),
      Center(
        child: SizedBox(
          width: 100,
          height: 100,
          child: _image != null
              ? Image.file(_image!, height: 200, width: 200)
              : const Text(
                  "Event Image Goes Here...",
                  style: smallTextStyle,
                ),
        ),
      ),
      const VerticalEmptySpace(
        height: 24,
      ),
      const Text(
        'Event Documents (optional)',
        style: mediumTextStyle,
      ),
      CustomFilePicker(
          text: 'Pick a file',
          actionOnPressed: (names, files) {
            if (names.isNotEmpty && files.isNotEmpty) {
              for (int i = 0; i < names.length; i++) {
                setState(() {
                  _eventMaterials[names[i]!] = files[i]!;
                });
              }
            }
          }),
      const VerticalEmptySpace(),
      SizedBox(
        height: _eventMaterials.length < 3 ? 100 : _eventMaterials.length * 40,
        child: _eventMaterials.isEmpty
            ? const Center(
                child: Text(
                "Event Documents Goes Here...",
                style: smallTextStyle,
              ))
            : ListView.builder(
                itemCount: _eventMaterials.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  String fileName = _eventMaterials.keys.elementAt(index);
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
                                _eventMaterials.remove(fileName);
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
      // const VerticalEmptySpace(
      //   height: 84,
      // ),
    ];
    Widget thirdPageButton = CustomActionButton(
            displayText: 'Organize',
            actionOnPressed: () {
              if (_image != null) {
                organizeEvent();
              } else {
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Image is required'),
                  ),
                );
              }
            });
    List<List<Widget>> pages = [firstPage, secondPage, thirdPage];
    List<Widget> pagesButtons = [firstPageButton, secondPageButton, thirdPageButton];
    return Scaffold(
        appBar: HeaderBar(
          headerTitle: 'Organize Event',
          menuRequired: false,
          customAction: _currentPage == 0
              ? null
              : () {
                  setState(() {
                    _currentPage--;
                  });
                },
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(25, 35, 25, 0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: pages[_currentPage],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: pagesButtons[_currentPage],
        ),
      ),
        );
  }
}
