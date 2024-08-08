import 'package:assignment/models/profile_model.dart';
import 'package:assignment/providers/event_provider.dart';
import 'package:assignment/providers/profile_provider.dart';
import 'package:assignment/theme/fonts.dart';
import 'package:assignment/utils/formatter.dart';
import 'package:assignment/widgets/header_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:assignment/models/event_model.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late EventModel event;
  String? _organizerImage;
  Map<String, String>? _participantsImage;

  void loadDate(EventModel event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: event.datetime.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<DateTime, DateTime> dateRange = entry.value;
                  debugPrint(dateRange.keys.first.toString());
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Session ${index + 1}',
                          style: mediumTextStyle,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Start Datetime: ${formatDateTimeToString(dateRange.keys.first)}',
                          // 'Start',
                          style: smallTextStyle,
                        ),
                        Text(
                          'End Datetime: ${formatDateTimeToString(dateRange.values.first)}',
                          // 'End',
                          style: smallTextStyle,
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData getFileIcon(String fileName) {
    if (fileName.endsWith('.pdf')) {
      return Icons.picture_as_pdf;
    } else if (fileName.endsWith('.png') ||
        fileName.endsWith('.jpg') ||
        fileName.endsWith('.jpeg')) {
      return Icons.image;
    } else if (fileName.endsWith('.xlsx') || fileName.endsWith('.xls')) {
      return Icons.table_chart;
    }
    return Icons.insert_drive_file;
  }

  void openFile(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      // print('Attempting to open URL: $uri');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        // print('URL successfully opened: $url');
      } else {
        // print('Could not open the URL: $url');
        throw 'Could not open the URL: $url';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  void launchLocation(String location) async {
    try {
      Uri uri = Uri.parse('https://maps.google.com/?q=$location');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not open the URL: ${uri.toString()}';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  bool isOrganizer(String organizer) {
    return Provider.of<ProfileProvider>(context, listen: false)
            .userProfile!
            .email ==
        organizer;
  }

  bool isParticipant(List<String>? participants) {
    if (participants == null) {
      return false;
    }
    return participants.contains(
        Provider.of<ProfileProvider>(context, listen: false)
            .userProfile!
            .email);
  }

  bool isViewOnly() {
    return Provider.of<ProfileProvider>(context, listen: false)
            .userProfile!
            .type ==
        UserType.administrator;
  }

  void joinEvent(EventModel event) {
    if (Provider.of<ProfileProvider>(context, listen: false)
            .userProfile!
            .creditScore <
        90) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your credit score is not enough! (less than 90)'),
        ),
      );
      return;
    }
    EventProvider().joinEvent(event);
  }

  void leaveEvent(EventModel event) {
    EventProvider().leaveEvent(event);
  }

  void editEvent(EventModel event) {
    Navigator.of(context).pushNamed('/edit_event', arguments: event);
  }

  @override
  Widget build(BuildContext context) {
    event = ModalRoute.of(context)!.settings.arguments as EventModel;
    _fetchProfileImage(event.organizerEmail, event.participants);
    void Function()? actionOnPressed;
    String actionButtonText;
    Color actionButtonColor;
    if (isViewOnly()) {
      actionOnPressed = null;
      actionButtonText = '';
      actionButtonColor = Colors.transparent;
    } else if (isOrganizer(event.organizerEmail)) {
      actionOnPressed = () {
        editEvent(event);
      };
      actionButtonText = 'Edit';
      actionButtonColor = Colors.blueAccent;
    } else if (isParticipant(event.participants)) {
      actionOnPressed = () {
        leaveEvent(event);
      };
      actionButtonText = 'Leave';
      actionButtonColor = Colors.redAccent;
    } else {
      actionOnPressed = () {
        joinEvent(event);
      };
      actionButtonText = 'Join';
      actionButtonColor = Colors.blueAccent;
    }
    return Scaffold(
      appBar:
          const HeaderBar(headerTitle: 'Event Details', menuRequired: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    height: 150,
                    decoration: const BoxDecoration(color: Colors.amber),
                    child: Center(child: Image.network(event.imageLink)),
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _viewOthersProfile(event.organizerEmail);
                      },
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: _organizerImage == null
                            ? const NetworkImage('https://firebasestorage.googleapis.com/v0/b/mae-assignment-f43cb.appspot.com/o/profile%2Fprofile_placeholder.jpeg?alt=media&token=029415b7-5f68-4361-aee0-53be1d212d60')
                            : NetworkImage(_organizerImage!),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      event.organizerEmail,
                      style: smallTextStyle,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Container(
              constraints: const BoxConstraints(minHeight: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            launchLocation(event.venue);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Wrap(
                                  children: [
                                    Text(
                                      event.venue,
                                      style: linkTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            loadDate(event);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.date_range,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Wrap(
                                  children: [
                                    Text(
                                        'Sessions: ${event.datetime.length}',
                                        style: linkTextStyle),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              constraints: const BoxConstraints(minHeight: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.attach_money),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Wrap(
                                children: [
                                  Text(
                                    event.fees.toString(),
                                    style: smallTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.people),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Wrap(
                                children: [
                                  Text(
                                    event.capacity.toString(),
                                    style: smallTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Flexible(
                    child: Column(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              constraints: const BoxConstraints(minHeight: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.phone),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Wrap(
                                children: [
                                  Text(
                                    event.contact,
                                    style: smallTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.category),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Wrap(
                                children: [
                                  Text(
                                    event.type.toString().split('.').last,
                                    style: smallTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Flexible(
                    child: Column(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            if ((isOrganizer(event.organizerEmail) ||
                    isParticipant(event.participants)) &&
                event.materials!.isNotEmpty)
              const Text("Materials",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if ((isOrganizer(event.organizerEmail) ||
                    isParticipant(event.participants)) &&
                event.materials!.isNotEmpty)
              ...event.materials!.keys.map((key) {
                return ListTile(
                  leading: Icon(getFileIcon(key)),
                  title: Text(
                    key,
                    style: smallTextStyle,
                  ),
                  onTap: () {
                    openFile(event.materials![key]!);
                  },
                );
              }),
            const SizedBox(height: 8.0),
            Text(
              'Event Description',
              style: mediumTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              event.description,
              style: smallTextStyle,
            ),
            const SizedBox(height: 16.0),
            Text(
                'Participants (${event.participants?.length ?? 0}/${event.capacity})',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            if (!event.isAnonymous && _participantsImage != null)
              SizedBox(
                height: (70 * _participantsImage!.length).toDouble(),
                child: ListView.builder(
                    itemCount: _participantsImage!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _viewOthersProfile(_participantsImage!.keys.elementAt(
                            index,
                          ));
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              _participantsImage!.values.elementAt(index)),
                        ),
                      );
                    }),
              ),
          ],
        ),
      ),
      bottomNavigationBar: isViewOnly()
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: actionOnPressed,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: actionButtonColor,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(actionButtonText,
                    style: mediumTextStyle.copyWith(color: Colors.white)),
              ),
            ),
    );
  }

  Future<void> _fetchProfileImage(
      String organizerEmail, List<String>? participantsEmails) async {
    Map<String, String> eventUserImages = await EventProvider()
        .getEventUserImages(organizerEmail, participantsEmails);
    if (mounted) {
      setState(() {
        _organizerImage = eventUserImages[organizerEmail]!;
        eventUserImages.remove(organizerEmail);
        _participantsImage = eventUserImages;
      });
    }
  }

  Future<void> _viewOthersProfile(String email) async {
    await ProfileProvider().getOthersProfile(email).then((othersProfile) {
      Navigator.of(context)
          .pushNamed('/others_profile', arguments: othersProfile);
    });
  }
}
