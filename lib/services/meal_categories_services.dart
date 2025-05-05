import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MealCategoriesServices with ChangeNotifier {
  final _firebaseFireStore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getAllMealCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> mealQuery =
          await _firebaseFireStore.collection('meal_categories').get();

      return mealQuery;
    } catch (e) {
      rethrow;
    }
  }
}
