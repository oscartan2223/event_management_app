import 'dart:io';

import 'package:assignment/repositories/file_repository.dart';

class FileProvider {

  static final FileRepository _fileRepository = FileRepository();

  static Future<String?> uploadProfileImage(File image, String email) async {
    return await _fileRepository.uploadFile(image, 'profile/$email');
  }

  static Future<String?> uploadEventImage(File image, String id) async {
    return await _fileRepository.uploadFile(image, 'event/images/$id');
  }

  static Future<String?> uploadEventFile(File file, String folderName, String fileName) async {
    return await _fileRepository.uploadFile(file, 'event/files/$folderName/$fileName');
  }

  static Future<String?> uploadSupportingDoc(File file, String folderName, String fileName) async {
    return await _fileRepository.uploadFile(file, 'request/$folderName/$fileName');
  } 

}
