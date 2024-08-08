import 'package:assignment/models/profile_model.dart';
import 'package:assignment/models/request_model.dart';
import 'package:assignment/providers/profile_provider.dart';
import 'package:assignment/repositories/profile_repository.dart';
import 'package:assignment/repositories/request_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  String? get userEmail => _firebaseAuth.currentUser?.email;

  Future<String> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      debugPrint(e.code);
      switch (e.code) {
        case 'invalid-credential':
          errorMessage = "Invalid credentials.";
          break;
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        case 'user-disabled':
          errorMessage = 'User with this email has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage =
              'Too many attempts to sign in. Please try again later.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Signing in with email and password is not enabled.';
          break;
        default:
          errorMessage = 'An unknown error occurred. Please try again.';
      }
      return errorMessage;
    }
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createNewUser({
    required ProfileModel newProfile,
    required String password,
    required BuildContext context,
  }) async {
    if (await Provider.of<ProfileProvider>(context, listen: false)
        .addProfile(newProfile)) {
      await createUserWithEmailAndPassword(
          email: newProfile.email, password: password);
    }
  }

  Future<bool> sendResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> reauthenticateUser(String password) async {
    try {
      if (currentUser == null) {
        return false;
      }
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: password,
      );

      await _firebaseAuth.currentUser!.reauthenticateWithCredential(credential);
      return true;
    } on FirebaseAuthException {
      return false;
    }
  }

  Future<void> changePassword(String password) async {
    await currentUser?.updatePassword(password);
  }

  Future<bool> banUserUsingEmail(String email, ReportModel banModel, bool isExisting) async {
    ProfileModel targetUser = await ProfileProvider().getOthersProfile(email);
    return await banUser(targetUser, banModel, isExisting);
  }

  Future<bool> banUser(ProfileModel targetUser, ReportModel banModel, bool isExisting) async {
    bool status1 = await ProfileRepository()
        .updateProfile(targetUser.copyWith(status: AccountStatus.banned));
    String status2; 
        if (isExisting) {
          if (await RequestRepository().updateRequest(banModel)) {
            status2 = 'succcess';
          } else {
            status2 = 'failed';
          }
        } else {
            status2 = await RequestRepository().addRequest(banModel);

        }
    return status1 && status2 != '';
  }
}
