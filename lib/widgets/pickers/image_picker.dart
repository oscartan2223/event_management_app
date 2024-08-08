import 'dart:io';

import 'package:assignment/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker extends StatefulWidget {
  const CustomImagePicker(
      {super.key, required this.actionOnPressed, this.text});

  final Function(File?) actionOnPressed;
  final String? text;

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  File? _selectedImage;

  Future<void> _pickImageFromGallery() async {
    
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
    widget.actionOnPressed(_selectedImage);

  }

  @override
  Widget build(BuildContext context) {
    return 
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text ?? 'Pick an Image',
          style: mediumTextStyle,
        ),
        GestureDetector(
      onTap: _pickImageFromGallery,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Row(
          children: [
            Icon(Icons.drive_folder_upload, size: 40),
            SizedBox(width: 16),
            Text(
              'Pick an Image',
              style: mediumTextStyle,
            ),
          ],
        ),
      ),
    ),
        
            // Text(_selectedImage != null ? _selectedImage.toString() : '')
      ],
    );
    
    
    
  }
}
