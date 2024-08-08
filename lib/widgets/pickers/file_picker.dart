import 'dart:io';

import 'package:assignment/theme/fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CustomFilePicker extends StatelessWidget {
  const CustomFilePicker({super.key, required this.actionOnPressed, this.text});

  final Function(List<String?>, List<File?>) actionOnPressed;
  final String? text;

  Future<void> _uploadFile() async {
    FilePickerResult? selectedFiles =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (selectedFiles == null ||
        selectedFiles.names.isEmpty ||
        selectedFiles.paths.isEmpty) return;
    actionOnPressed(selectedFiles.names.map((name) => name).toList(),
        selectedFiles.paths.map((path) => File(path!)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Call your upload file action here
        _uploadFile();
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            const Icon(Icons.upload_file, size: 40),
            const SizedBox(width: 16),
            Text(
              text ?? 'Supporting Documents',
              style: mediumTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
