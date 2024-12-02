import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_compression/image_compression.dart';
import 'package:image_picker/image_picker.dart';
import '../models/beyond_calories_article.dart';

class BeyondCaloriesArticlesServices with ChangeNotifier {
  final _firebaseFireStore = FirebaseFirestore.instance;

  Future<String?> uploadImage(XFile image, String source) async {
    try {
      final bytes = await image.readAsBytes();
      final input = ImageFile(
        rawBytes: bytes,
        filePath: image.path,
      );
      final output = compress(ImageFileConfiguration(input: input));

      final imageRef =
          FirebaseStorage.instance.ref().child("$source/${image.name}");
      print(bytes);
      await imageRef.putData(bytes);

      final downloadURL = await imageRef.getDownloadURL();
      print('Uploaded: $downloadURL');
      return downloadURL;
    } catch (ex) {
      print("Error uploading image: $ex");
      rethrow;
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
