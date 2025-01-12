import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../models/beyond_calories_article.dart';

class BeyondCaloriesArticlesServices with ChangeNotifier {
  final _firebaseFireStore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadImage(
      FilePickerResult path,
      ) async {
    try {
      final fileBytes = path.files.first.bytes;
      final fileName = path.files.first.name;

      if (fileBytes == null || fileName.isEmpty) {
        throw Exception("Invalid file data.");
      }

      final imageRef = _storage.ref().child("articles/$fileName");

      await imageRef.putData(fileBytes);

      return await imageRef.getDownloadURL();
    } catch (ex) {
      log("Error uploading image: ${ex.toString()}");
      return null;
    }
  }
  Future<List<BeyondCaloriesArticle>> getAllArticles() async {
    try {
      QuerySnapshot<Map<String, dynamic>> articleQuery =
          await _firebaseFireStore.collection('beyond_calories_articles').get();

      List<BeyondCaloriesArticle> articles = articleQuery.docs.map((doc) {
        return BeyondCaloriesArticle.fromJson(doc.data(), doc.id);
      }).toList();

      return articles;
    } catch (ex) {
      rethrow;
    }
  }

  Future<BeyondCaloriesArticle> addArticle(article) async {
    try {
      var addedBeyondCaloriesArticle = await _firebaseFireStore
          .collection('beyond_calories_articles')
          .add(article.toMap());
      var articleSnapshot = await addedBeyondCaloriesArticle.get();

      return BeyondCaloriesArticle.fromJson(
          articleSnapshot.data()!, addedBeyondCaloriesArticle.id);
    } catch (ex) {
      rethrow;
    }
  }

  Future<BeyondCaloriesArticle> updateArticle(BeyondCaloriesArticle article) async {
    try {
      await _firebaseFireStore
          .collection('beyond_calories_articles')
          .doc(article.documentId)
          .set(
            article.toMap(),
            SetOptions(merge: false),
          );
      var docRef = _firebaseFireStore
          .collection('beyond_calories_articles')
          .doc(article.documentId);
      var docSnapshot = await docRef.get();

      BeyondCaloriesArticle updatedBeyondCaloriesArticle =
          BeyondCaloriesArticle.fromJson(docSnapshot.data()!, article.documentId);
      return updatedBeyondCaloriesArticle;
    } catch (ex) {
      rethrow;
    }
  }
}
