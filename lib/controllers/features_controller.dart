import 'package:flutter/material.dart';
import '../core/utils/size_config.dart';
import '../models/beyond_calories_article.dart';
import '../models/feature.dart';
import '../providers/features_provider.dart';
import '../providers/storage_provider.dart';
import '../screens/widgets/custom_text.dart';
import '../services/features_services.dart';

class FeaturesController {
  static final FeaturesController _instance = FeaturesController._internal();

  factory FeaturesController() => _instance;

  FeaturesController._internal();

  TextEditingController urlController = TextEditingController();
  List<String> features = FeaturesProvider()
      .featuresControllers
      .map((controller) => controller.text)
      .where((text) => text.isNotEmpty)
      .toList();

  FeaturesServices ms = FeaturesServices();

  Future<void> addFeature(FeaturesProvider featuresProvider, StorageProvider storageProvider, Feature? feature, index) async {
    String arImageUrl = '';
    String enImageUrl = '';
    if (storageProvider.featuresImagesArePicked[index]['ar_image_picked']) {
      arImageUrl = (await StorageProvider().uploadImage(
          storageProvider.featuresPickedImages[index]['ar_image']!,
          "features"))!;
    } else {
      arImageUrl = feature != null ? feature.arImageURL : "";
    }
    if (storageProvider.featuresImagesArePicked[index]['ar_image_picked'] &&
        storageProvider.featuresImagesArePicked[index]['en_image_picked']) {
      enImageUrl = (await StorageProvider().uploadImage(
          storageProvider.featuresPickedImages[index]['en_image']!,
          "features"))!;
    } else {
      enImageUrl = feature != null ? feature.enImageURL : "";
    }
    await FeaturesProvider().addFeature(Feature(
        arImageURL: arImageUrl,
        enImageURL: enImageUrl,
        active: featuresProvider.statuses[index]['active_feature'],
        premium: featuresProvider.statuses[index]['premium_feature'],
        keyword: FeaturesProvider().featuresControllers[index].text,
        user: featuresProvider.userTypesAppearance[index]['user'],
        cooker: featuresProvider.userTypesAppearance[index]['cooker']));
    featuresProvider.resetFeatureValues(storageProvider, featuresProvider);
  }

  Future<void> deleteFeature(StorageProvider storageProvider, FeaturesProvider featuresProvider, Feature feature, index) async {
    if (storageProvider.featuresImagesArePicked[index]['ar_image_picked'] &&
        storageProvider.featuresPickedImages[index]['ar_image']) {
      await storageProvider.deleteImage(feature.arImageURL);
      await storageProvider.deleteImage(feature.arImageURL);
    }
    await featuresProvider.deleteFeature(feature.documentId!);
  }

  Future<void> addArticle(StorageProvider storageProvider) async {
    String imageUrl = '';
    if (storageProvider.articleImageIsPicked) {
      imageUrl = (await StorageProvider()
          .uploadImage(storageProvider.pickedArticleImage!, "articles"))!;
    }

    await FeaturesProvider().addArticle(BeyondCaloriesArticle(
      imageUrl: imageUrl,
      url: urlController.text,
    ));
  }

  Future<void> updateArticle(StorageProvider storageProvider, BeyondCaloriesArticle article) async {
    String imageUrl = '';
    if (storageProvider.articleImageIsPicked) {
      imageUrl = (await StorageProvider()
          .uploadImage(storageProvider.pickedArticleImage!, "articles"))!;
    }

    await FeaturesProvider().updateArticle(BeyondCaloriesArticle(
      documentId: article.documentId,
      imageUrl: imageUrl,
      url: urlController.text,
    ));
  }

  Future<void> deleteArticle(StorageProvider storageProvider,FeaturesProvider featuresProvider, BeyondCaloriesArticle article) async {
    await storageProvider.deleteImage(article.imageUrl);
    await featuresProvider.deleteArticle(article.documentId!);
  }

  void showSuccessDialog(BuildContext context, settingsProvider, String text) {
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
                children: [
                  const Icon(Icons.check_circle, size: 30, color: Colors.green),
                  CustomText(
                      isCenter: true,
                      text: text,
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
