import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FileRepository {

  final FirebaseStorage _fileStorage = FirebaseStorage.instance;

  Future<String?> uploadFile(File file, String path) async {

    try{
      Reference ref = _fileStorage.ref().child(path);
      TaskSnapshot taskSnapshot = await ref.putFile(file);
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
    
  }

}