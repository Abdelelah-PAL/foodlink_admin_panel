import '../models/admin_details.dart';
import '../services/admin_services.dart';
import 'package:flutter/cupertino.dart';

class AdminsProvider with ChangeNotifier {
  static final AdminsProvider _instance = AdminsProvider._internal();

  factory AdminsProvider() => _instance;

  AdminsProvider._internal();

  AdminDetails? selectedAdmin;

  bool cookerFirstLogin = false;
  bool adminFirstLogin = false;

  List<AdminDetails> loggedInAdmins = [];
  final AdminsServices _as = AdminsServices();

  void addAdminDetails(AdminDetails adminDetails) async {
    await _as.addAdminDetails(adminDetails);
  }

  Future<AdminDetails?> getAdminByEmail(String email) async {
    var admin = await _as.getAdminByEmail(email);
    return admin;
  }
}
