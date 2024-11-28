import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/assets.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/meal_categories_provider.dart';
import '../../../providers/settings_provider.dart';
import '../../../services/translation_services.dart';
import '../../food_screens/healthy_food.dart';
import '../../food_screens/meal_planning.dart';
import '../../widgets/custom_text.dart';
import 'feature_container.dart';
import 'meal_tile.dart';

class UserBody extends StatelessWidget {
  const UserBody({super.key, required this.settingsProvider});

  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: settingsProvider.language == "en"
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: CustomText(
              text: TranslationService().translate("wht_want_eat"),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              isCenter: false),
        ),
        Container(
          padding: EdgeInsets.only(
              top: SizeConfig.getProportionalHeight(5),
              bottom: SizeConfig.getProportionalHeight(25),
              left: SizeConfig.getProportionalWidth(15)),
          width: SizeConfig.getProportionalWidth(500),
          height: SizeConfig.getProportionalHeight(270),
          child: Consumer<MealCategoriesProvider>(
            builder: (context, mealCategoriesProvider, child) {
              return GridView.builder(
                padding: EdgeInsets.zero,
                itemCount: mealCategoriesProvider.mealCategories.length,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (ctx, index) {
                  final category = mealCategoriesProvider.mealCategories[index];
                  return MealTile(
                    name: category.name,
                    imageUrl: category.imageUrl,
                    width: 85,
                    height: 85,
                    index: index,
                    categoryId: category.id!,
                  );
                },
              );
            },
          ),
        ),
        FeatureContainer(
          imageUrl: Assets.healthyFood,
          text: TranslationService().translate("healthy_life"),
          settingsProvider: settingsProvider,
          onTap: () => Get.to(const HealthyFood()),
        ),
        FeatureContainer(
          left: SizeConfig.getProportionalWidth(30),
          imageUrl: Assets.mealPlanning,
          text: TranslationService().translate("meal_planning"),
          settingsProvider: settingsProvider,
          onTap: () => Get.to(const MealPlanning()),
        ),
      ],
    );
  }
}
