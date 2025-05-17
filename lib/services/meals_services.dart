import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/meal.dart';

class MealsServices with ChangeNotifier {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<List<Meal>> getAllPlannedMeals() async {
    try {
      final querySnapshot = await fireStore.collection('planned_meals').get();
      return querySnapshot.docs.map((doc) {
        return Meal.fromJson(doc.data(), doc.id);
      }).toList();
    } catch (ex) {
      log("Error fetching planned meals: ${ex.toString()}");
      rethrow;
    }
  }

  Future<Meal> addMeal(Meal meal) async {
    try {
      final mealRef =
          await fireStore.collection('planned_meals').add(meal.toMap());
      final mealSnapshot = await mealRef.get();
      return Meal.fromJson(mealSnapshot.data()!, mealRef.id);
    } catch (ex) {
      log("Error adding meal: ${ex.toString()}");
      rethrow;
    }
  }

  Future<Meal> updateMeal(Meal meal) async {
    try {
      await fireStore.collection('planned_meals').doc(meal.documentId).set(
            meal.toMap(),
            SetOptions(merge: false),
          );
      var docRef = fireStore.collection('planned_meals').doc(meal.documentId);
      var docSnapshot = await docRef.get();

      Meal updatedMeal = Meal.fromJson(docSnapshot.data()!, meal.documentId);
      return updatedMeal;
    } catch (ex) {
      log("Error updating meal: ${ex.toString()}");
      rethrow;
    }
  }

  Future<void> deleteMeal(String docId) async {
    await fireStore.collection('planned_meals').doc(docId).delete();
  }
}
