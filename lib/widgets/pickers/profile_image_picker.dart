import 'dart:io';

import 'package:assignment/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomProfileImagePicker extends StatefulWidget {
  const CustomProfileImagePicker(
      {super.key, required this.actionOnPressed, this.imageFile, required this.imageLink});

  final Function(File?) actionOnPressed;
  final File? imageFile;
  final String imageLink;

  @override
  State<CustomProfileImagePicker> createState() =>
      _CustomProfileImagePickerState();
}

class _CustomProfileImagePickerState extends State<CustomProfileImagePicker> {
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
    if (widget.imageFile != null) {
      _selectedImage = widget.imageFile;
    }
    ImageProvider<Object> profilePic;
    if (_selectedImage == null) {
      profilePic = NetworkImage(widget.imageLink);
    } else {
      profilePic = FileImage(_selectedImage!);
    }
    return GestureDetector(
        onTap: _pickImageFromGallery,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              backgroundImage: profilePic,
              radius: 50,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.white,
                ),
                Text(
                  'edit',
                  style: smallTextStyle.copyWith(color: Colors.white),
                )
              ],
            ),
          ],
        ));
  }
}
