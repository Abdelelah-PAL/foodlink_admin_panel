import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/models/beyond_calories_article.dart';
import '../core/utils/size_config.dart';
import '../providers/beyond_calories_articles_provider.dart';
import '../screens/widgets/custom_text.dart';
import '../services/beyond_calories_articles_services.dart';

class BeyondCaloriesArticlesController {
  static final BeyondCaloriesArticlesController _instance = BeyondCaloriesArticlesController
      ._internal();

  factory BeyondCaloriesArticlesController() => _instance;

  BeyondCaloriesArticlesController._internal();

  TextEditingController urlController = TextEditingController();

  BeyondCaloriesArticlesServices ms = BeyondCaloriesArticlesServices();



  Future<void> addArticle(beyondCaloriesArticlesProvider) async {
    String imageUrl = '';
    if (beyondCaloriesArticlesProvider.imageIsPicked) {
      imageUrl = await BeyondCaloriesArticlesProvider().uploadImage(
          beyondCaloriesArticlesProvider.pickedFile, "articles");
    }
    var addedArticle = await BeyondCaloriesArticlesProvider().addArticles(
        BeyondCaloriesArticle(
          imageUrl: imageUrl,
          url: urlController.text,
        ));
  }

  Future<void> updateArticle(beyondCaloriesArticlesProvider, article) async {
    String imageUrl = '';
    if (beyondCaloriesArticlesProvider.imageIsPicked) {
      imageUrl = await BeyondCaloriesArticlesProvider().uploadImage(
          beyondCaloriesArticlesProvider.pickedFile, "planned_meals_images");
    }
    var updatedArticle = await BeyondCaloriesArticlesProvider().updateArticles(
        BeyondCaloriesArticle(
          documentId: article.documentId,
          imageUrl: imageUrl,
          url: urlController.text,
        ));

  }

  void showSuccessDialog(BuildContext context, settingsProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SizeConfig.customSizedBox(
            205,
            56,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: settingsProvider.language == 'en'
                  ? [
                const Icon(Icons.check_circle,
                    size: 30, color: Colors.green),
                const CustomText(
                    isCenter: true,
                    text: 'success',
                    fontSize: 20,
                    fontWeight: FontWeight.normal)
              ]
                  : [
                const CustomText(
                    isCenter: true,
                    text: 'notification_sent',
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
                SizeConfig.customSizedBox(10, null, null),
                const Icon(Icons.check_circle,
                    size: 30, color: Colors.green),
              ],
            ),
          ),
        );
      },
    );
  }
}
