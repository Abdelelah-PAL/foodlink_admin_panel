import 'package:flutter/material.dart';
import '../../../controllers/general_controller.dart';
import '../../../core/constants/assets.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/custom_text.dart';
import 'meal_properties_header.dart';

class SourceMealView extends StatelessWidget {
  const SourceMealView({
    super.key,
    required this.meal,
    required this.settingsProvider,
  });

  final Meal meal;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.getProportionalWidth(10)),
      child: Column(
        children: [
          MealPropertiesHeader(
              settingsProvider: settingsProvider,
              icon: Assets.mealSource,
              text: 'source'),
          SizeConfig.customSizedBox(null, 20, null),
          GestureDetector(
            onTap: () =>
                GeneralController().launchURL(context, Uri.parse(meal.source!)),
            child: meal.source != "" && meal.source != null
                ? CustomText(
                    isCenter: true,
                    text: meal.source!,
                    fontSize: 18,
                    color: Colors.blue,
                    fontWeight: FontWeight.w400,
                    underlined: true)
                : const CustomText(
                    isCenter: true,
                    text: "no_source",
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
          )
        ],
      ),
    );
  }
}
