import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:foodlink_admin_panel/models/slider_image.dart';

class StorageServices with ChangeNotifier {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<String?> uploadFile(FilePickerResult path, String tag) async {
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

  Future<void> saveImageMetadata({required String imageUrl}) async {
    try {
      SliderImage sliderImage = SliderImage(imageUrl: imageUrl);
      await FirebaseFirestore.instance
          .collection('slider_images')
          .add(sliderImage.toFirestore());
    } catch (ex) {
      log("Error saving image metadata: ${ex.toString()}");
    }
  }

  Future<void> deleteImage(String fileUrl) async {
    try {
      if (fileUrl.isNotEmpty) {
        Reference ref = _storage.refFromURL(fileUrl);
        await ref.delete();
      }
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        return;
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<SliderImage>> getDishOfTheWeek() {
    return FirebaseFirestore.instance
        .collection('slider_images')
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => SliderImage.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> deleteDOWRecord(String imageUrl) async {
    final querySnapshot = await fireStore
        .collection('slider_images')
        .where('imageUrl', isEqualTo: imageUrl)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> updateDOWActiveByImageUrl(
    String imageUrl,
    bool isActive,
  ) async {
    final querySnapshot = await fireStore
        .collection('slider_images')
        .where('imageUrl', isEqualTo: imageUrl)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.update({
        'active': !isActive,
      });
    }
  }
}
