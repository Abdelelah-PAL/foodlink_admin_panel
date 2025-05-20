import 'package:flutter/material.dart';
import '../screens/features_screens/beyond_calories_articles_screen.dart';
import '../screens/features_screens/show_features_screen.dart';
import '../screens/food_screens/add_dish_of_the_week_screen.dart';
import '../screens/food_screens/meals_list_screen.dart';
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
    const MealsListScreen(),
    const AddDishOfTheWeekScreen(),
    const BeyondCaloriesArticlesScreen(),
    const ShowFeaturesScreen(),
    const SettingsScreen(),
  ];
}
