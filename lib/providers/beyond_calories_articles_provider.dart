import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/controllers/beyond_calories_article_controller.dart';
import 'package:foodlink_admin_panel/models/beyond_calories_article.dart';
import 'package:foodlink_admin_panel/services/beyond_calories_articles_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

class BeyondCaloriesArticlesProvider with ChangeNotifier {
  static final BeyondCaloriesArticlesProvider _instance = BeyondCaloriesArticlesProvider._internal();
  factory BeyondCaloriesArticlesProvider() => _instance;

  BeyondCaloriesArticlesProvider._internal();

  List<BeyondCaloriesArticle> articles = [];
  final BeyondCaloriesArticlesServices _as = BeyondCaloriesArticlesServices();
  bool isLoading = false;
  bool imageIsPicked = false;
  XFile? pickedFile;


  void getAllArticles() async {
    try {
      isLoading = true;
      articles.clear();
      List<BeyondCaloriesArticle> fetchedArticles =
      await _as.getAllArticles();
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

  Future<BeyondCaloriesArticle> addArticles(BeyondCaloriesArticle article) async {
    var addedArticles = await _as.addArticle(article);
    return addedArticles;
  }

  Future<BeyondCaloriesArticle> updateArticles(BeyondCaloriesArticle article) async {
    BeyondCaloriesArticle updatedArticles = await _as.updateArticle(article);
    return updatedArticles;
  }

  Future<void> pickImage() async {
    try {
      final file = await ImagePickerWeb.getImageAsBytes();
      if (file != null) {
        pickedFile = XFile.fromData(file);
        imageIsPicked = true;
      }
      notifyListeners();
    } catch (e) {
      print("Error picking image: $e");
      rethrow;
    }
  }

  Future<String> uploadImage(image, source) async {
    String? downloadUrl = await _as.uploadImage(image, source);
    return downloadUrl!;
  }

  void resetValues() {
    imageIsPicked = false;
    pickedFile = null;
    BeyondCaloriesArticlesController().urlController.clear();
    notifyListeners();
  }


  void fillDataForEdition(article) {
    BeyondCaloriesArticlesController().urlController.text = article.url;
    notifyListeners();
  }

}
