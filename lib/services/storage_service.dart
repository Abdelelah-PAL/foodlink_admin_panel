import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

class StorageServices with ChangeNotifier {
  final FirebaseStorage _storage = FirebaseStorage.instance;

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

  Future<void> saveImageMetadata(
      {required String imageUrl,
      required double dx,
      required double dy,
      required double width,
      required double height}) async {
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
}
