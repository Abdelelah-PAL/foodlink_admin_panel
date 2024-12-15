import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_compression/image_compression.dart';
import 'package:image_picker/image_picker.dart';
import '../models/meal.dart';
import 'dart:html' as html;


class MealsServices with ChangeNotifier {
  final _firebaseFireStore = FirebaseFirestore.instance;

    Future<String?> uploadImage(FilePickerResult image, String destination) async {
        String downloadURL = '';
        Uint8List? fileBytes = image.files.first.bytes;
        // final input = ImageFile(
        //   rawBytes: bytes,
        //   filePath: image.path,
        // );
        // final output = compress(ImageFileConfiguration(input: input));
        final imageRef = FirebaseStorage.instance
            .ref()
            .child("$destination/${image.names[0]}");
        print('moew');
        try {
          await imageRef.putData(fileBytes!);
        }
        catch(ex){
          print(ex.toString());
        }
        print('moew2');
        downloadURL = await imageRef.getDownloadURL();
        print('moew3');

        return downloadURL;

  }
  Future<List<Meal>> getAllPlannedMeals() async {
    try {
      QuerySnapshot<Map<String, dynamic>> mealQuery = await _firebaseFireStore
          .collection('planned_meals')
          .get();

      List<Meal> meals = mealQuery.docs.map((doc) {
        return Meal.fromJson(doc.data(), doc.id);
      }).toList();

      return meals;
    } catch (ex) {
      rethrow;
    }
  }


  Future<Meal> addMeal(meal) async {
    try {
      var addedMeal =
          await _firebaseFireStore.collection('planned_meals').add(meal.toMap());
      var mealSnapshot = await addedMeal.get();

      return Meal.fromJson(mealSnapshot.data()!, addedMeal.id);
    } catch (ex) {
      rethrow;
    }
  }


  Future<Meal> updateMeal(Meal meal) async {
    try {
      await _firebaseFireStore.collection('meals').doc(meal.documentId).set(
            meal.toMap(),
            SetOptions(merge: false),
          );
      var docRef = _firebaseFireStore.collection('meals').doc(meal.documentId);
      var docSnapshot = await docRef.get();

      Meal updatedMeal = Meal.fromJson(docSnapshot.data()!, meal.documentId);
      return updatedMeal;
    } catch (ex) {
      rethrow;
    }
  }
}
