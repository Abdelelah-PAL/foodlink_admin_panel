import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../providers/settings_provider.dart';
import '../../services/translation_services.dart';
import 'custom_text.dart';

class CustomAppTextField extends StatelessWidget {
  const CustomAppTextField(
      {super.key,
      required this.width,
      required this.height,
      required this.headerText,
      required this.icon,
      required this.controller,
      required this.maxLines,
      required this.iconSizeFactor,
      required this.settingsProvider});

  final double width;
  final double height;
  final String headerText;
  final String icon;
  final TextEditingController controller;
  final int maxLines;
  final double iconSizeFactor;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (settingsProvider.language == 'en') Padding(
              padding:
                  EdgeInsets.only(left: SizeConfig.getProportionalWidth(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizeConfig.customSizedBox(
                        iconSizeFactor, iconSizeFactor, Image.asset(icon)),
                  ),
                  CustomText(
                    isCenter: false,
                    text: TranslationService().translate(headerText),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ) else Padding(
              padding:
                  EdgeInsets.only(right: SizeConfig.getProportionalWidth(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomText(
                    isCenter: false,
                    text: TranslationService().translate(headerText),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizeConfig.customSizedBox(
                        iconSizeFactor, iconSizeFactor, Image.asset(icon)),
                  ),
                ],
              ),
            ),
      Container(
        width:SizeConfig.getProportionalWidth(width),
        height: SizeConfig.getProportionalHeight(height),
        margin: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(10)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1.0, color: AppColors.widgetsColor),
        ),
        child: TextField(
          maxLines: maxLines,
          controller: controller,
          textAlign: settingsProvider.language == 'en'
              ? TextAlign.left
              : TextAlign.right,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(
                SizeConfig.getProportionalWidth(10),
                SizeConfig.getProportionalHeight(2),
                SizeConfig.getProportionalWidth(10),
                SizeConfig.getProportionalHeight(2)),
            hintStyle: TextStyle(
                fontSize: 20,
                color: AppColors.hintTextColor,
                fontFamily: AppFonts.primaryFont),
            border: InputBorder.none,
          ),
        ),
      ),
    ]);
  }
}
