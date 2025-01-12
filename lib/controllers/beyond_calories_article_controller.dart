import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/models/beyond_calories_article.dart';
import '../core/utils/size_config.dart';
import '../providers/beyond_calories_articles_provider.dart';
import '../screens/widgets/custom_text.dart';
import '../services/beyond_calories_articles_services.dart';

class BeyondCaloriesArticlesController {
  static final BeyondCaloriesArticlesController _instance =
      BeyondCaloriesArticlesController._internal();

  factory BeyondCaloriesArticlesController() => _instance;

  BeyondCaloriesArticlesController._internal();

  TextEditingController urlController = TextEditingController();

  BeyondCaloriesArticlesServices ms = BeyondCaloriesArticlesServices();

  Future<void> addArticle(beyondCaloriesArticlesProvider) async {
    String imageUrl = '';
    if (beyondCaloriesArticlesProvider.imageIsPicked) {
      imageUrl = (await BeyondCaloriesArticlesProvider()
          .uploadImage(beyondCaloriesArticlesProvider.pickedFile))!;
    }
    var addedArticle = await BeyondCaloriesArticlesProvider()
        .addArticles(BeyondCaloriesArticle(
      imageUrl: imageUrl,
      url: urlController.text,
    ));

  }

  Future<void> updateArticle(beyondCaloriesArticlesProvider, article) async {
    String imageUrl = '';
    if (beyondCaloriesArticlesProvider.imageIsPicked) {
      imageUrl = (await BeyondCaloriesArticlesProvider().uploadImage(
          beyondCaloriesArticlesProvider.pickedFile))!;
    }
    var updatedArticle = await BeyondCaloriesArticlesProvider()
        .updateArticles(BeyondCaloriesArticle(
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
                textDirection: settingsProvider.language == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.check_circle, size: 30, color: Colors.green),
                  CustomText(
                      isCenter: true,
                      text: 'article_added',
                      fontSize: 20,
                      fontWeight: FontWeight.normal)
                ]),
          ),
        );
      },
    );
  }

  void showFailedAddDialog(BuildContext context, settingsProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SizeConfig.customSizedBox(
            350,
            56,
            Row(
                textDirection: settingsProvider.language == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.error, size: 30, color: Colors.green),
                  CustomText(
                      isCenter: true,
                      text: 'fill_info',
                      fontSize: 20,
                      fontWeight: FontWeight.normal)
                ]),
          ),
        );
      },
    );
  }

}
