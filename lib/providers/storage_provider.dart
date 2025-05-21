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
  FilePickerResult? pickedArticleImage;
  bool articleImageIsPicked = false;
  List<Map<String, bool>> featuresImagesArePicked = [
    {'ar_image_picked': false, 'en_image_picked': false},
  ];
  List<Map<String, dynamic>> featuresPickedImages = [
    {'ar_image': null, 'en_image': null},
  ];

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
        }
      }
      notifyListeners();
    } catch (e) {
      print("Error picking image: $e");
      rethrow;
    }
  }

  Future<void> pickFeatureImage(String source, int index) async {
    try {
      FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (file != null) {
        if (source == "ar_feature") {
          featuresPickedImages[index]['ar_image'] = file;
          featuresImagesArePicked[index]['ar_image_picked'] = true;
        } else if (source == "en_feature") {
          featuresPickedImages[index]['en_image'] = file;
          featuresImagesArePicked[index]['en_image_picked'] = true;
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

  void addToImages(index, arImage, enImage) {
    featuresImagesArePicked
        .insert(index, {'ar_image_picked': false, 'en_image_picked': false});
    featuresPickedImages
        .insert(index, {'ar_image': arImage, 'en_image': enImage});
    notifyListeners();
  }
}
