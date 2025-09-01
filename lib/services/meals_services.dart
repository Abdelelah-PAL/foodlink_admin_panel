import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodlink_admin_panel/providers/storage_provider.dart';

import '../controllers/meal_types.dart';
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

  Future<Meal> addPlannedMeal(Meal meal) async {
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

  Future<Meal> updatePlannedMeal(Meal meal) async {
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

  Future<void> deletePlannedMeal(String docId) async {
    await fireStore.collection('planned_meals').doc(docId).delete();
  }

  Future<List<Meal>> addSuggestedMeals(
      List<Meal> suggestedMeals,
      StorageProvider storageProvider,
      ) async {
    try {
      final batch = fireStore.batch();
      final mealsRef = fireStore.collection("meals");
      final createdMeals = <Meal>[];

      for (var i = 0; i < suggestedMeals.length; i++) {
        final meal = suggestedMeals[i];
        String? imageUrl;

        if (i < storageProvider.suggestionsImagesArePicked.length &&
            storageProvider.suggestionsImagesArePicked[i]) {
          imageUrl = await StorageProvider().uploadFile(
            storageProvider.suggestionsPickedImages[i],
            "suggested_meals_images",
          );
        }

        final newMeal = Meal(
          name: meal.name,
          categoryId: meal.categoryId,
          ingredients: meal.ingredients,
          recipe: meal.recipe,
          source: "",
          imageUrl: imageUrl,
          typeId: MealTypes.suggestedMeal,
        );

        final docRef = mealsRef.doc();
        batch.set(docRef, newMeal.toMap());

        createdMeals.add(newMeal..documentId = docRef.id);
      }

      await batch.commit();

      return createdMeals;
    } catch (ex) {
      log("Error adding suggested meals: $ex");
      rethrow;
    }
  }
}
