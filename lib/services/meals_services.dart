import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

import 'package:foodlink_admin_panel/models/meal.dart';

class MealsServices with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(
      FilePickerResult image, String destination) async {
    try {
      final fileBytes = image.files.first.bytes;
      final fileName = image.files.first.name;

      if (fileBytes == null || fileName.isEmpty) {
        throw Exception("Invalid file data.");
      }

      final imageRef = _storage.ref().child("$destination/$fileName");

      await imageRef.putData(fileBytes);

      return await imageRef.getDownloadURL();
    } catch (ex) {
      debugPrint("Error uploading image: ${ex.toString()}");
      return null;
    }
  }

  Future<List<Meal>> getAllPlannedMeals() async {
    try {
      final querySnapshot = await _firestore.collection('planned_meals').get();
      return querySnapshot.docs.map((doc) {
        return Meal.fromJson(doc.data(), doc.id);
      }).toList();
    } catch (ex) {
      debugPrint("Error fetching planned meals: ${ex.toString()}");
      rethrow;
    }
  }

  Future<Meal?> addMeal(Meal meal) async {
    try {
      final mealRef =
          await _firestore.collection('planned_meals').add(meal.toMap());
      final mealSnapshot = await mealRef.get();
      return Meal.fromJson(mealSnapshot.data()!, mealRef.id);
    } catch (ex) {
      debugPrint("Error adding meal: ${ex.toString()}");
      return null;
    }
  }

  Future<Meal?> updateMeal(Meal meal) async {
    try {
      final mealRef = _firestore.collection('meals').doc(meal.documentId);
      await mealRef.set(meal.toMap(), SetOptions(merge: false));

      final updatedSnapshot = await mealRef.get();
      return Meal.fromJson(updatedSnapshot.data()!, meal.documentId);
    } catch (ex) {
      debugPrint("Error updating meal: ${ex.toString()}");
      return null;
    }
  }
}
