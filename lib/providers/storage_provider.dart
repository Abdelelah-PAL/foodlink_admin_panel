import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../models/slider_image.dart';
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
  List<SliderImage> dowImageURLs = [];

  List<bool> suggestionsImagesArePicked = [false];
  List<dynamic> suggestionsPickedImages = [null];

  bool isLoading = false;
  StreamSubscription? _dowSubscription;

  bool mealImageIsDeleted = false;

  Future<void> pickFile(String source) async {
    try {
      FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (file != null) {
        switch (source) {
          case "meal":
            pickedMealImage = file;
            mealImageIsPicked = true;
            mealImageIsDeleted = false;
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

  void deleteMealImage() {
    mealImageIsDeleted = true;
    mealImageIsPicked = false;
    pickedMealImage = null;
    notifyListeners();
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

  Future<void> saveImageMetadata(String imageUrl, bool active) async {
    _ss.saveImageMetadata(imageUrl: imageUrl);
    dOWIsPicked = false;
    pickedDOW = null;
    notifyListeners();
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

  void listenToDowImages() {
    isLoading = true;
    notifyListeners();

    _dowSubscription = _ss.getDishOfTheWeek().listen(
      (dishes) {
        dowImageURLs = dishes;
        isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('Error fetching DOW images: $e');
        isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> deleteDOW(SliderImage sliderImage) async {
    await deleteImage(sliderImage.imageUrl);
    await _ss.deleteDOWRecord(sliderImage.imageUrl);
    dowImageURLs.removeWhere(
      (item) => item.imageUrl == sliderImage.imageUrl,
    );
    notifyListeners();
  }

  Future<void> updateActiveDOW(SliderImage sliderImage) async {
    await _ss.updateDOWActiveByImageUrl(
        sliderImage.imageUrl, sliderImage.active!);
    notifyListeners();
  }
}
