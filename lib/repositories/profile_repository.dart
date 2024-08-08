import 'package:assignment/models/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileRepository {
  final _profileCollection = FirebaseFirestore.instance.collection('users');

  Future<ProfileModel> getProfile(String email) async =>
      _profileCollection.doc(email).get().then((DocumentSnapshot doc) =>
          ProfileModel.fromMap(doc.data() as Map<String, dynamic>));

  Future<bool> addProfile(ProfileModel profile) async => _profileCollection
      .doc(profile.email)
      .set(profile.toMap())
      .then((_) => true)
      .catchError((_) => false);

  Future<bool> updateProfile(ProfileModel profile) async => _profileCollection
      .doc(profile.email)
      .update(profile.toMap())
      .then((_) => true)
      .catchError((_) => false);

  Future<String?> checkIfUserExist(String email) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(email).get();
      if (doc.data() != null) {
        return (doc.data() as Map<String, dynamic>)['username'];
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
