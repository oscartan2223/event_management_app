import 'package:assignment/models/profile_model.dart';
import 'package:assignment/models/request_model.dart';
import 'package:assignment/providers/profile_provider.dart';
import 'package:assignment/services/auth_service.dart';
import 'package:assignment/utils/formatter.dart';
import 'package:assignment/widgets/header_bar.dart';
import 'package:flutter/material.dart';

class BanUserScreen extends StatefulWidget {
  const BanUserScreen({super.key});

  @override
  State<BanUserScreen> createState() => _BanUserScreenState();
}

class _BanUserScreenState extends State<BanUserScreen> {
  int _banDuration = 5;

  String _reasons = '';

  Future<void> _banUser(ProfileModel targetUser) async {

    if (targetUser.email == ProfileProvider().userProfile!.email) {
      ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Don\'t try to ban yourself!'),
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

    AuthService().banUser(
        targetUser,
        ReportModel(
            userEmail: ProfileProvider().userProfile!.email,
            reportedUserEmail: targetUser.email,
            date: formatDateTime(DateTime.now()),
            status: 'Approved',
            type: 'Report User',
            description: _reasons,
            supportingDocs: {}), false).then((status) {
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
  }

  @override
  Widget build(BuildContext context) {
    ProfileModel targetUser =
        ModalRoute.of(context)!.settings.arguments as ProfileModel;
    return Scaffold(
      appBar: const HeaderBar(headerTitle: 'Ban User', menuRequired: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ban Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              initialValue: targetUser.email,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              initialValue: targetUser.username,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Duration',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.timer, color: Color.fromARGB(255, 0, 0, 0)),
                const SizedBox(width: 8),
                Text(
                  '$_banDuration days',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () async {
                    int? duration = await _showEditDurationDialog(context);
                    if (duration != null) {
                      setState(() {
                        _banDuration = duration;
                      });
                    }
                  },
                  child: const Text(
                    'edit',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: '',
              decoration: const InputDecoration(
                labelText: 'Reasons',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              onChanged: (val) {
                _reasons = val;
              },
            ),
            const SizedBox(height: 32),
            const SizedBox(height: 16), // Extra space before the button
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            _banUser(targetUser);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
            minimumSize: const Size(double.infinity, 48),
          ),
          child: const Text(
            'Ban',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
