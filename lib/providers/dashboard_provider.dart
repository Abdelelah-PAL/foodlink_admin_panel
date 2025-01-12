import 'package:flutter/cupertino.dart';

class DashboardProvider with ChangeNotifier {
  static final DashboardProvider _instance = DashboardProvider._internal();

  factory DashboardProvider() => _instance;

  DashboardProvider._internal();

  String language = 'ar';

  bool isExpanded = false;
  int selectedIndex = 0;
  bool userPressed = false;
  bool cookerPressed = false;

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void toggleExpanded() {
    isExpanded = !isExpanded;
    notifyListeners();
  }

  void changeIndex(value) {
    selectedIndex = value;
    notifyListeners();
  }
}
