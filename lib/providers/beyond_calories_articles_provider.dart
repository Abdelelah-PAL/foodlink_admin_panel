import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/controllers/beyond_calories_article_controller.dart';
import 'package:foodlink_admin_panel/models/beyond_calories_article.dart';
import 'package:foodlink_admin_panel/services/beyond_calories_articles_services.dart';

class BeyondCaloriesArticlesProvider with ChangeNotifier {
  static final BeyondCaloriesArticlesProvider _instance = BeyondCaloriesArticlesProvider._internal();
  factory BeyondCaloriesArticlesProvider() => _instance;

  BeyondCaloriesArticlesProvider._internal();

  List<BeyondCaloriesArticle> articles = [];
  final BeyondCaloriesArticlesServices _as = BeyondCaloriesArticlesServices();
  bool isLoading = false;
  bool imageIsPicked = false;
  FilePickerResult? pickedFile;


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
      FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (file != null) {
          pickedFile = file;
          imageIsPicked = true;
        }
      notifyListeners();
    } catch (e) {
      print("Error picking image: $e");
      rethrow;
    }
  }


  Future<String?> uploadImage(FilePickerResult path) async =>
      _as.uploadImage(path);

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
