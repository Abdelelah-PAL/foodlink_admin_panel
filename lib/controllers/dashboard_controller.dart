import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/screens/food_screens/add_meal_screen.dart';
import '../screens/food_screens/favorites_screen.dart';
import '../screens/settings_screen/settings_screen.dart';

class DashboardController {
  static final DashboardController _instance = DashboardController._internal();
  factory DashboardController() => _instance;
  DashboardController._internal();
  TextEditingController userNameController = TextEditingController();
  TextEditingController cookerNameController = TextEditingController();

  bool isExpanded = false;
  int selectedIndex = 0;

  void onItemTapped(int index) {
    selectedIndex = index;
  }
  List<Widget> dashBoardList = [
    const AddMealScreen(isAddScreen: true,),
    const Favorites(),
    Container(),
    const SettingsScreen(),
  ];
}
