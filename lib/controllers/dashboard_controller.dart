import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/screens/beyond_calories_articles_screen/add_article_screen.dart';
import 'package:foodlink_admin_panel/screens/food_screens/add_dish_of_the_week_screen.dart';
import 'package:foodlink_admin_panel/screens/food_screens/add_meal_screen.dart';
import 'package:foodlink_admin_panel/screens/food_screens/meals_list_screen.dart';
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
    const AddMealScreen(
      isAddScreen: true,
    ),
    const AddDishOfTheWeekScreen(),
    const AddArticleScreen(),
    const SettingsScreen(),
  ];
}
