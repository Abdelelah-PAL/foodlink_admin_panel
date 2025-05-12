import 'package:flutter/material.dart';
import '../../../controllers/general_controller.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../models/meal.dart';
import '../../../providers/settings_provider.dart';

class RecipeRow extends StatelessWidget {
  const RecipeRow({
    super.key,
    required this.meal,
    required this.fontSize,
    required this.settingsProvider,
    required this.text,
  });

  final Meal meal;
  final double fontSize;
  final SettingsProvider settingsProvider;
  final String text;

  @override
  Widget build(BuildContext context) {
    String writtenLanguage = GeneralController().detectLanguage(text);
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.getProportionalWidth(10)),
      width: 348,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1.0, color: AppColors.widgetsColor),
      ),
      child: Row(
        textDirection: settingsProvider.language == 'en'
            ? TextDirection.ltr
            : TextDirection.rtl,
        mainAxisAlignment: settingsProvider.language == 'en'
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            Assets.mealRecipe,
            scale: 1.3,
          ),
          SizeConfig.customSizedBox(
            270,
            225,
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                maxLines: 100,
                text,
                textDirection: writtenLanguage == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                textAlign: settingsProvider.language == 'en'
                    ? TextAlign.end
                    : TextAlign.start,
                style: TextStyle(
                    fontSize: fontSize,
                    fontFamily:
                        writtenLanguage == 'en' ? 'salsa' : 'MyriadArabic'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
