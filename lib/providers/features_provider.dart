import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import '../controllers/features_controller.dart';
import '../models/beyond_calories_article.dart';
import '../models/feature.dart';
import '../services/features_services.dart';
import 'storage_provider.dart';

class FeaturesProvider with ChangeNotifier {
  static final FeaturesProvider _instance = FeaturesProvider._internal();

  factory FeaturesProvider() => _instance;

  FeaturesProvider._internal();

  List<BeyondCaloriesArticle> articles = [];
  List<Feature> features = [];
  final FeaturesServices _fs = FeaturesServices();
  bool isLoading = false;
  List<Map> statuses = [
    {'active_feature': false, 'premium_feature': false},
  ];
  List<Map> userTypesAppearance = [
    {'user': false, 'cooker': false},
  ];
  List<TextEditingController> featuresControllers = [
    TextEditingController(),
  ];

  Future<void> getAllFeatures(StorageProvider storageProvider) async {
    try {
      isLoading = true;
      features.clear();
      List<Feature> fetchedFeatures = await _fs.getAllFeatures();
      int index = 0;
      for (var doc in fetchedFeatures) {
        Feature feature = Feature(
            documentId: doc.documentId,
            arImageURL: doc.arImageURL,
            enImageURL: doc.enImageURL,
            active: doc.active,
            premium: doc.premium,
            keyword: doc.keyword,
            user: doc.user,
            cooker: doc.cooker);
        featuresControllers.insert(index, TextEditingController());
        statuses.insert(index, {
          'active_feature': doc.active,
          'premium_feature': doc.premium,
        });
        userTypesAppearance.insert(index, {
          'user': doc.user,
          'cooker': doc.cooker,
        });
        storageProvider.addToImages(index);


        featuresControllers[index].text = doc.keyword;
        features.add(feature);
        index++;
      }
      notifyListeners();
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      isLoading = false;
      rethrow;
    }
  }

  Future<Feature> addFeature(Feature feature) async {
    var addedFeature = await _fs.addFeature(feature);
    return addedFeature;
  }

  // Future<Feature?> updateFeature(Feature feature,
  //     StorageProvider storageProvider,
  //     SettingsProvider settingsProvider,
  //     int index,
  //     context) async {
  //   Feature? updatedFeature;
  //   if (storageProvider.featuresPickedImages[index]['ar_image'] &&
  //       storageProvider.enFeatureImageIsPicked) {
  //     await StorageProvider().deleteImage(feature.arImageURL);
  //     await StorageProvider().deleteImage(feature.enImageURL);
  //     String arImageUrl = (await StorageProvider()
  //         .uploadImage(storageProvider.featuresPickedImages[index]['ar_image'], "features"))!;
  //     String enImageUrl = (await StorageProvider()
  //         .uploadImage(storageProvider.featuresPickedImages[index]['en_image'], "features"))!;
  //     feature.arImageURL = arImageUrl;
  //     feature.enImageURL = enImageUrl;
  //     updatedFeature = await _fs.updateFeature(feature);
  //   }
  //   return updatedFeature;
  // }

  Future<void> deleteFeature(id) async {
    await _fs.deleteFeature(id);
  }

  Future<void> getAllArticles() async {
    try {
      isLoading = true;
      articles.clear();
      List<BeyondCaloriesArticle> fetchedArticles = await _fs.getAllArticles();
      for (var doc in fetchedArticles) {
        BeyondCaloriesArticle article = BeyondCaloriesArticle(
          documentId: doc.documentId,
          imageUrl: doc.imageUrl,
          url: doc.url,
        );
        articles.add(article);
      }
      isLoading = false;
      notifyListeners();
    } catch (ex) {
      isLoading = false;
      rethrow;
    }
  }

  Future<BeyondCaloriesArticle> addArticle(
      BeyondCaloriesArticle article) async {
    var addedArticles = await _fs.addArticle(article);
    return addedArticles;
  }

  Future<BeyondCaloriesArticle> updateArticle(
      BeyondCaloriesArticle article) async {
    BeyondCaloriesArticle updatedArticles = await _fs.updateArticle(article);
    return updatedArticles;
  }

  Future<void> deleteArticle(id) async {
    await _fs.deleteArticle(id);
  }

  void resetArticleValues(StorageProvider storageProvider) {
    storageProvider.articleImageIsPicked = false;
    storageProvider.pickedArticleImage = null;
    FeaturesController().urlController.clear();
    notifyListeners();
  }

  void resetFeatureValues(
      StorageProvider storageProvider, FeaturesProvider featuresProvider) {
    storageProvider.featuresImagesArePicked.last['ar_image_picked'] = false;
    storageProvider.featuresPickedImages.last['ar_image'] = null;
    storageProvider.featuresImagesArePicked.last['en_image_picked'] = false;
    storageProvider.featuresPickedImages.last['en_image'] = null;
    featuresProvider.featuresControllers.last.clear();
    featuresProvider.statuses.last['active_feature'] = false;
    featuresProvider.statuses.last['premium_feature'] = false;
    featuresProvider.userTypesAppearance.last['user'] = false;
    featuresProvider.userTypesAppearance.last['cooker'] = false;
    notifyListeners();
  }

  void fillDataForEdition(article) {
    FeaturesController().urlController.text = article.url;
    notifyListeners();
  }

  void toggleActiveFeature(index) {
    statuses[index]['active_feature'] = !statuses[index]['active_feature'];
    notifyListeners();
  }

  void togglePremiumFeature(index) {
    statuses[index]['premium_feature'] = !statuses[index]['premium_feature'];
    notifyListeners();
  }

  void toggleUserAppearance(index) {
    userTypesAppearance[index]['user'] = !userTypesAppearance[index]['user'];
    notifyListeners();
  }

  void toggleCookerAppearance(index) {
    userTypesAppearance[index]['cooker'] =
        !userTypesAppearance[index]['cooker'];
    notifyListeners();
  }
}
