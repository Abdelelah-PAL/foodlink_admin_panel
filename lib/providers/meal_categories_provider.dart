import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/meal_category.dart';
import '../services/meal_categories_services.dart';

class MealCategoriesProvider with ChangeNotifier {
  static final MealCategoriesProvider _instance =
      MealCategoriesProvider._internal();

  factory MealCategoriesProvider() => _instance;

  MealCategoriesProvider._internal();

  List<MealCategory> mealCategories = [];
  final MealCategoriesServices _mcs = MealCategoriesServices();
  bool isLoading = false;


  void getAllMealCategories() async {
    try {
      mealCategories = [];
        isLoading = true;
        QuerySnapshot<Map<String, dynamic>> mealQuery =
            await _mcs.getAllMealCategories();
        for (var doc in mealQuery.docs) {
          MealCategory mealCategory = MealCategory(
              id: doc['id'],
              name: doc['name'],
              imageUrl: doc['image_url'],
              mealsName: doc['meals_name']);
          mealCategories.add(mealCategory);
        }
        isLoading = false;
        mealCategories.sort((a, b) => a.id!.compareTo(b.id!));
        notifyListeners();
    } catch (ex) {
      rethrow;
    }
  }
}
