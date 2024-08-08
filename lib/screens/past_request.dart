// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:assignment/models/request_model.dart';
import 'package:assignment/providers/profile_provider.dart';
import 'package:assignment/providers/request_provider.dart';
import 'package:assignment/theme/fonts.dart';
import 'package:assignment/utils/formatter.dart';
import 'package:assignment/widgets/header_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PastRequestScreen extends StatefulWidget {
  const PastRequestScreen({super.key});

  @override
  State<PastRequestScreen> createState() => _PastRequestScreenState();
}

class _PastRequestScreenState extends State<PastRequestScreen> {
  List<BaseRequestModel>? _requests;
  //Import the data initially
  // String _date = '18/5/2024';
  // String _status = 'Pending Review';
  // String _requestType = 'Request for Organizer Role';
  // String _requestDescription = 'Description...';
  // Map<String, String> files = {
  //   'document1.pdf':
  //       'https://firebasestorage.googleapis.com/v0/b/mae-assignment-a88ea.appspot.com/o/images%2FScreenshot%202023-05-19%20031809.png?alt=media&token=48f860ff-6960-404e-84f1-373b27cfd029',
  //   'image1.png':
  //       'https://firebasestorage.googleapis.com/v0/b/mae-assignment-a88ea.appspot.com/o/images%2FNew1234%40gmail.com?alt=media&token=75388f82-e280-4d43-8e79-30ff42c6107b'
  // };

  void loadRequests() {}

  @override
  void didChangeDependencies() async {
    String email =
        Provider.of<ProfileProvider>(context, listen: false).userProfile!.email;
    debugPrint(email);
    await Provider.of<RequestProvider>(context, listen: false)
        .getPersonalRequests(email)
        .then((_) {
      if (mounted) {
        setState(() {
          _requests =
              Provider.of<RequestProvider>(context, listen: false).requests;
        });
      }
    });
    debugPrint(_requests.toString());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderBar(headerTitle: 'Past Requests', menuRequired: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_requests != null)
              ..._requests!.map((request) {
                return Column(
                  children: [
                    RequestPreview(
                        index: _requests!.indexOf(request), request: request),
                    Divider(),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }
}

class RequestPreview extends StatelessWidget {
  const RequestPreview({super.key, required this.index, required this.request});

  final int index;
  final BaseRequestModel request;

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
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not open the URL.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${index + 1}. Request Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(children: [
          const Text(
            'Request Date: ',
            style: smallTextStyle,
          ),
          const SizedBox(width: 8),
          Text(
            formatDateTimeToStringDate(request.date),
            style: const TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 0, 136, 255)),
          ),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          const Text(
            'Status: ',
            style: smallTextStyle,
          ),
          const SizedBox(width: 8),
          Text(
            request.status,
            style: const TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 0, 136, 255)),
          ),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          const Text(
            'Request Type: ',
            style: smallTextStyle,
          ),
          const SizedBox(width: 8),
          Text(
            request.type,
            style: const TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 0, 136, 255)),
          ),
        ]),
        const SizedBox(height: 16),
        const Text(
          'Request Description: ',
          style: smallTextStyle,
        ),
        const SizedBox(width: 8),
        Text(
          request.description,
          style: const TextStyle(
              fontSize: 16, color: Color.fromARGB(255, 0, 136, 255)),
        ),
        const SizedBox(height: 16),
        const Text(
          'Supporting Documents: ',
          style: smallTextStyle,
        ),
        const SizedBox(height: 8),
        if (request.supportingDocs != null)
          ...request.supportingDocs!.keys.map((fileName) {
            return ListTile(
              leading: Icon(getFileIcon(fileName)),
              title: Text(
                fileName,
                style: smallTextStyle,
              ),
              onTap: () {
                openFile(request.supportingDocs![fileName]!);
              },
            );
          }),
        const SizedBox(height: 16),
      ],
    );
  }
}
