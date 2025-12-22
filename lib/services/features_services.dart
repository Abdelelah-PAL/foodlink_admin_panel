import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../models/beyond_calories_article.dart';
import '../models/feature.dart';

class FeaturesServices with ChangeNotifier {
  final _firebaseFireStore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Feature>> getAllFeatures() async {
        try {
          QuerySnapshot<Map<String, dynamic>> featureQuery =
          await _firebaseFireStore.collection('features').get();

          List<Feature> features = featureQuery.docs.map((doc) {
            return Feature.fromJson(doc.data(), doc.id);
          }).toList();
          return features;
        } catch (ex) {
          rethrow;
    }
  }

  Future<Feature> addFeature(feature) async {
    try {
      var addedFeature =
          await _firebaseFireStore.collection('features').add(feature.toMap());
      var featureSnapshot = await addedFeature.get();

      return Feature.fromJson(featureSnapshot.data()!, addedFeature.id);
    } catch (ex) {
      rethrow;
    }
  }

  Future<Feature> updateFeature(Feature feature) async {
    try {
      await _firebaseFireStore
          .collection('features')
          .doc(feature.documentId)
          .set(
            feature.toMap(),
            SetOptions(merge: false),
          );
      var docRef = _firebaseFireStore
          .collection('beyond_calories_articles')
          .doc(feature.documentId);
      var docSnapshot = await docRef.get();

      Feature updatedFeature =
          Feature.fromJson(docSnapshot.data()!, feature.documentId);
      return updatedFeature;
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> deleteFeature(String documentId) async {
    try {
      await _firebaseFireStore
          .collection('features')
          .doc(documentId)
          .delete();
    } catch (ex) {
      rethrow;
    }
  }


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

  Future<BeyondCaloriesArticle> updateArticle(
      BeyondCaloriesArticle article) async {
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
          BeyondCaloriesArticle.fromJson(
              docSnapshot.data()!, article.documentId);
      return updatedBeyondCaloriesArticle;
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> deleteArticle(String documentId) async {
    try {
      await _firebaseFireStore
          .collection('beyond_calories_articles')
          .doc(documentId)
          .delete();
    } catch (ex) {
      rethrow;
    }
  }

}


