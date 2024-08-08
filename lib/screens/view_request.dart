import 'package:assignment/models/request_model.dart';
import 'package:assignment/providers/profile_provider.dart';
import 'package:assignment/providers/request_provider.dart';
import 'package:assignment/services/auth_service.dart';
import 'package:assignment/theme/fonts.dart';
import 'package:assignment/utils/formatter.dart';
import 'package:assignment/widgets/components/custom_buttons.dart';
import 'package:assignment/widgets/header_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewRequestScreen extends StatefulWidget {
  const ViewRequestScreen({super.key});

  @override
  State<ViewRequestScreen> createState() => _ViewRequestScreenState();
}

class _ViewRequestScreenState extends State<ViewRequestScreen> {
  //Import the data initially

  late BaseRequestModel _request;

  int? durationDisplayed;
  // int _requestId = 001;
  // String _date = '18/5/2024';
  // String _status = 'Pending Review';
  // String _requestType = 'Request for Organizer Role';
  // String _requestDescription = 'Description...';
  // Map<String, String> _supportingDocs = {
  //   'image1.png':
  //       'https://firebasestorage.googleapis.com/v0/b/mae-assignment-a88ea.appspot.com/o/images%2FScreenshot%202023-05-19%20031809.png?alt=media&token=48f860ff-6960-404e-84f1-373b27cfd029',
  //   'document1.pdf':
  //       'https://firebasestorage.googleapis.com/v0/b/mae-assignment-a88ea.appspot.com/o/images%2FLab%2010%20-%20Queues.pdf?alt=media&token=98f856ae-d110-40dc-8a76-bfe78332ac59',
  // };

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
      // print('Error: $e');
    }
  }

  Future<void> updateStatus(String status, {int? duration}) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    if (status == 'Approved Ban') {
      if (_request is! ReportModel) {
        debugPrint('false');
        return;
      }
      ReportModel report = _request as ReportModel;
      if (report.reportedUserEmail == ProfileProvider().userProfile!.email) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Don\'t try to ban yourself!'),
          ),
        );
        Navigator.of(context).pop();
        return;
      }
      AuthService()
          .banUserUsingEmail(
              report.reportedUserEmail,
              report.copyWith(
                  status: 'Approved',
                  days: durationDisplayed,
                  date: DateTime.now()),
              true)
          .then((status) {
        Navigator.of(context).pop();
        if (status) {
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ban Failed!'),
            ),
          );
        }
      });
    } else if (status == 'Approved') {
      //for event organizer role request
      RequestProvider()
          .approveEventOrganizerRoleRequest(_request)
          .then((status) {
        Navigator.of(context).pop();
        if (status) {
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$status failed'),
            ),
          );
        }
      });
    } else {
      RequestProvider()
          .updateRequest(_request.copyWith(status: status))
          .then((status) {
        Navigator.of(context).pop();
        if (status) {
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$status failed'),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _request = ModalRoute.of(context)!.settings.arguments as BaseRequestModel;
    List<Widget> updateStatusButtons;
    if (_request.type == 'Feedback') {
      updateStatusButtons = [
        CustomActionButton(
            displayText: 'Reviewed',
            actionOnPressed: () {
              updateStatus('Reviewed');
            }),
      ];
    } else if (_request.type == 'Report User') {
      updateStatusButtons = [
        CustomActionButton(
            displayText: 'Ban User',
            width: 150,
            height: 60,
            actionOnPressed: () {
              updateStatus('Approved Ban');
            }),
        CustomActionButton(
            displayText: 'Reject',
            width: 150,
            height: 60,
            color: Colors.red,
            actionOnPressed: () {
              updateStatus('Rejected');
            }),
      ];
    } else {
      //Organizer Role Request
      updateStatusButtons = [
        CustomActionButton(
            displayText: 'Approve',
            width: 150,
            height: 60,
            actionOnPressed: () {
              updateStatus('Approved');
            }),
        CustomActionButton(
            displayText: 'Reject',
            width: 150,
            height: 60,
            color: Colors.red,
            actionOnPressed: () {
              updateStatus('Rejected');
            }),
      ];
    }
    return Scaffold(
      appBar: const HeaderBar(headerTitle: 'View Request', menuRequired: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Request Details',
              style: largeTextStyle,
            ),
            const SizedBox(height: 18),
            Row(children: [
              const Text(
                'Request ID: ',
                style: mediumTextStyle,
              ),
              const SizedBox(width: 8),
              Text(
                _request.id!,
                style: linkTextStyle.copyWith(
                    decoration: TextDecoration.none, fontSize: 20),
              ),
            ]),
            const SizedBox(height: 18),
            Row(children: [
              const Text(
                'Request by: ',
                style: mediumTextStyle,
              ),
              const SizedBox(width: 8),
              Text(
                _request.userEmail,
                style: linkTextStyle.copyWith(
                    decoration: TextDecoration.none, fontSize: 20),
              ),
            ]),
            const SizedBox(height: 18),
            if (_request is ReportModel)
              Row(children: [
                const Text(
                  'Reporting: ',
                  style: mediumTextStyle,
                ),
                const SizedBox(width: 8),
                Text(
                  (_request as ReportModel).reportedUserEmail,
                  style: linkTextStyle.copyWith(
                      decoration: TextDecoration.none, fontSize: 20),
                ),
              ]),
            if (_request is ReportModel) const SizedBox(height: 18),
            if (_request is ReportModel)
              Row(children: [
                const Text(
                  'Ban duration: ',
                  style: mediumTextStyle,
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () async {
                    int? duration = await _showEditDurationDialog(context);
                    if (duration != null) {
                      _request =
                          (_request as ReportModel).copyWith(days: duration);
                      debugPrint((_request as ReportModel).days.toString());
                      setState(() {
                        durationDisplayed = duration;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 24,
                      ),
                      Text(
                        '${durationDisplayed ?? 0} days',
                        style: linkTextStyle
                            .copyWith(
                                decoration: TextDecoration.none, fontSize: 20)
                            .copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                )
              ]),
            if (_request is ReportModel) const SizedBox(height: 18),
            Row(children: [
              const Text(
                'Request Date: ',
                style: mediumTextStyle,
              ),
              const SizedBox(width: 8),
              Text(
                formatDateTimeToStringDate(_request.date),
                style: linkTextStyle.copyWith(
                    decoration: TextDecoration.none, fontSize: 20),
              ),
            ]),
            const SizedBox(height: 18),
            Row(children: [
              const Text(
                'Status: ',
                style: mediumTextStyle,
              ),
              const SizedBox(width: 8),
              Text(
                _request.status,
                style: linkTextStyle.copyWith(
                    decoration: TextDecoration.none, fontSize: 20),
              ),
            ]),
            const SizedBox(height: 18),
            Row(children: [
              const Text(
                'Request Type: ',
                style: mediumTextStyle,
              ),
              const SizedBox(width: 8),
              Text(
                _request.type,
                style: linkTextStyle.copyWith(
                    decoration: TextDecoration.none, fontSize: 20),
              ),
            ]),
            const SizedBox(height: 18),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Request Description: ',
                style: mediumTextStyle,
              ),
              const SizedBox(height: 8),
              Text(
                _request.description,
                style: linkTextStyle.copyWith(
                    decoration: TextDecoration.none, fontSize: 20),
              ),
            ]),
            const SizedBox(
              height: 18,
            ),
            const Text(
              'Supporting Documents: ',
              style: mediumTextStyle,
            ),
            if (_request.supportingDocs != null)
              ..._request.supportingDocs!.keys.map((fileName) {
                return ListTile(
                  leading: Icon(getFileIcon(fileName)),
                  title: Text(fileName),
                  onTap: () {
                    openFile(_request.supportingDocs![fileName]!);
                  },
                );
              }),
            const SizedBox(height: 18),
          ],
        ),
      ),
      bottomNavigationBar:
          _request.status == 'Approved' || _request.status == 'Reviewed'
              ? null
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: updateStatusButtons),
                ),
    );
  }

  Future<int?> _showEditDurationDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Duration'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Ban Duration (days)',
              hintText: 'Enter number of days',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                int? duration = int.tryParse(controller.text);
                Navigator.of(context).pop(duration);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
