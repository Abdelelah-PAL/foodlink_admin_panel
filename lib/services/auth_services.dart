import 'package:flutter/foundation.dart';
import 'package:foodlink_admin_panel/controllers/dashboard_controller.dart';
import 'package:foodlink_admin_panel/providers/dashboard_provider.dart';
import 'package:foodlink_admin_panel/screens/auth_screens/login_screen.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'translation_services.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      return user;
    } catch (ex) {
      rethrow;
    }
  }

  Future<UserCredential?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        AuthController().errorText =
            TranslationService().translate("user_not_found");
      } else if (e.code == 'wrong-password') {
        AuthController().errorText =
            TranslationService().translate("wrong_password");
      } else {
        AuthController().errorText = e.message!;
      }
    }
    return null;
  }
  void logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      DashboardProvider().changeIndex(0);
      Get.to(const LoginScreen());
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}
