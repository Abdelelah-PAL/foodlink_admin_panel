import 'package:flutter/cupertino.dart';
import '../services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  static final AuthProvider _instance = AuthProvider._internal();
  factory AuthProvider() => _instance;

  AuthProvider._internal();

  final AuthService _authService = AuthService();
  bool isLoading = false;
  User? user;
  final String errorMessage = "";


  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    isLoading = true;
    notifyListeners();
    user = await _authService.signUpWithEmailAndPassword(email, password);
    isLoading = false;
    notifyListeners();
    return user;
  }

  Future<UserCredential?> login(String email, String password) async {
     isLoading = true;
     notifyListeners();
     var userCredential = await _authService.login(email, password);
     isLoading = false;
     notifyListeners();
     return userCredential;
  }
}
