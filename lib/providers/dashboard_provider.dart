import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../screens/home_screen/home_screen.dart';

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


  Future<void> handleIndexChanged(int index) async {
    switch (index) {
      case 0:
        await Get.to(const HomeScreen());
        selectedIndex = 0;
        break;
      case 1:
        // await Get.to(AppRoutes.notificationScreen);
        selectedIndex = 0;
        break;

      case 2:
        // await Get.to(AppRoutes.profileScreen);
        selectedIndex = 0;
        break;
      case 3:
        // await Get.to(AppRoutes.profileScreen);
        selectedIndex = 0;
        break;
      default:
        selectedIndex = index;
    }
  }
}
