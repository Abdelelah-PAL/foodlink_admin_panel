import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class StorageProvider with ChangeNotifier {
  static final StorageProvider _instance = StorageProvider._internal();

  factory StorageProvider() => _instance;

  StorageProvider._internal();

  final StorageServices _ss = StorageServices();
  bool mealImageIsPicked = false;
  bool dOWIsPicked = false;
  bool articleImageIsPicked = false;
  bool suggestionsFileIsPicked = false;
  FilePickerResult? pickedMealImage;
  FilePickerResult? pickedDOW;
  FilePickerResult? pickedArticleImage;
  FilePickerResult? pickedSuggestionsImage;
  List<Map<String, bool>> featuresImagesArePicked = [];
  List<Map<String, dynamic>> featuresPickedImages = [];
  Map<String, bool> featureImageIsPicked = {
    'ar_image_picked': false,
    'en_image_picked': false
  };
  Map<String, dynamic> featurePickedImage = {
    'ar_image': null,
    'en_image': null
  };

  List<bool> suggestionsImagesArePicked = [
    false
  ];
  List<dynamic> suggestionsPickedImages = [
    null
  ];

  Future<void> pickFile(String source) async {
    try {
      FilePickerResult? file  = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

        if (file != null) {
          switch (source) {
            case "meal":
              pickedMealImage = file;
              mealImageIsPicked = true;
              break;
            case "DOW":
              pickedDOW = file;
              dOWIsPicked = true;
              break;
            case "articles":
              pickedArticleImage = file;
              articleImageIsPicked = true;
              break;
        }
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error picking image: $e");
      }
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
      if (kDebugMode) {
        print("Error picking image: $e");
      }
      rethrow;
    }
  }

  Future<void> pickEmptyFeatureImage(String source) async {
    try {
      FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (file != null) {
        if (source == "ar_feature") {
          featurePickedImage['ar_image'] = file;
          featureImageIsPicked['ar_image_picked'] = true;
        } else if (source == "en_feature") {
          featurePickedImage['en_image'] = file;
          featureImageIsPicked['en_image_picked'] = true;
        }
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error picking image: $e");
      }
      rethrow;
    }
  }

  Future<void> pickSuggestionImage(int index) async {
    try {
      FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (file != null) {
        suggestionsPickedImages[index] = file;
        suggestionsImagesArePicked[index] = true;
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print("Error picking image: $e");
      }
      rethrow;
    }
  }


  Future<String?> uploadFile(FilePickerResult path, String tag) async {
    return _ss.uploadFile(path, tag);
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
