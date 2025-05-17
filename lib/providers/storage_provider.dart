import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class StorageProvider with ChangeNotifier {
  static final StorageProvider _instance = StorageProvider._internal();

  factory StorageProvider() => _instance;

  StorageProvider._internal();

  final StorageServices _ss = StorageServices();
  bool mealImageIsPicked = false;
  bool dOWIsPicked = false;
  FilePickerResult? pickedMealImage;
  FilePickerResult? pickedDOW;
  bool articleImageIsPicked = false;
  FilePickerResult? pickedArticleImage;
  bool arFeatureImageIsPicked = false;
  bool enFeatureImageIsPicked = false;
  FilePickerResult? arPickedFeatureImage;
  FilePickerResult? enPickedFeatureImage;

  Future<void> pickImage(String source) async {
    try {
      FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (file != null) {
        if (source == "meal") {
          pickedMealImage = file;
          mealImageIsPicked = true;
        } else if (source == "DOW") {
          pickedDOW = file;
          dOWIsPicked = true;
        } else if (source == "articles") {
          pickedArticleImage = file;
          articleImageIsPicked = true;
        } else if (source == "ar_feature") {
          arPickedFeatureImage = file;
          arFeatureImageIsPicked = true;
        } else if (source == "en_feature") {
          enPickedFeatureImage = file;
          enFeatureImageIsPicked = true;
        }
      }
      notifyListeners();
    } catch (e) {
      print("Error picking image: $e");
      rethrow;
    }
  }

  Future<String?> uploadImage(FilePickerResult path, String tag) async {
    return _ss.uploadImage(path, tag);
  }

  Future<void> saveImageMetadata(String imageUrl, double dx, double dy,
      double width, double height) async {
    _ss.saveImageMetadata(
        imageUrl: imageUrl, dx: dx, dy: dy, width: width, height: height);
  }

  Future<void> deleteImage(imageUrl) async {
    await _ss.deleteImage(imageUrl);
  }
}
