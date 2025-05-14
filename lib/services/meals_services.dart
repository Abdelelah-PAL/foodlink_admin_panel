import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:foodlink_admin_panel/models/meal.dart';

class MealsServices with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(
    FilePickerResult path,
    String tag,
  ) async {
    try {
      final fileBytes = path.files.first.bytes;
      final fileName = path.files.first.name;

      if (fileBytes == null || fileName.isEmpty) {
        throw Exception("Invalid file data.");
      }

      final imageRef = _storage.ref().child("$tag/$fileName");

      await imageRef.putData(fileBytes);

      return await imageRef.getDownloadURL();
    } catch (ex) {
      log("Error uploading image: ${ex.toString()}");
      return null;
    }
  }

  Future<void> saveImageMetadata({
    required String imageUrl,
    required double dx,
    required double dy,
    required double width,
    required double height,
  }) async {
    try {
      final data = {
        "imageUrl": imageUrl,
        "position": {"x": dx, "y": dy},
        "width": width,
        "height": height,
        "uploadedAt": FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection("dish_of_the_week").add(data);
    } catch (ex) {
      log("Error saving image metadata: ${ex.toString()}");
    }
  }

  Future<List<Meal>> getAllPlannedMeals() async {
    try {
      final querySnapshot = await _firestore.collection('planned_meals').get();
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
          await _firestore.collection('planned_meals').add(meal.toMap());
      final mealSnapshot = await mealRef.get();
      return Meal.fromJson(mealSnapshot.data()!, mealRef.id);
    } catch (ex) {
      log("Error adding meal: ${ex.toString()}");
      rethrow;
    }
  }

  Future<Meal> updateMeal(Meal meal) async {
    try {
      await _firestore.collection('planned_meals').doc(meal.documentId).set(
        meal.toMap(),
        SetOptions(merge: false),
      );
      print(meal);
      var docRef = _firestore.collection('planned_meals').doc(meal.documentId);
      var docSnapshot = await docRef.get();

      Meal updatedMeal = Meal.fromJson(docSnapshot.data()!, meal.documentId);
      return updatedMeal;
    } catch (ex) {
      log("Error updating meal: ${ex.toString()}");
      rethrow;
    }
  }

  Future<void> deleteMeal(String docId) async {
    await _firestore.collection('planned_meals').doc(docId).delete();
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }
}
