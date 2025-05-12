import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../providers/settings_provider.dart';
import '../../services/translation_services.dart';
import 'custom_text.dart';

class CustomAppIconicTextField extends StatelessWidget {
  const CustomAppIconicTextField({
    super.key,
    required this.width,
    required this.height,
    required this.headerText,
    required this.icon,
    required this.controller,
    required this.maxLines,
    required this.iconSizeFactor,
    required this.iconPadding,
    required this.settingsProvider,
    required this.enabled,
    this.textAlign,
  });

  final double width;
  final double height;
  final String headerText;
  final String icon;
  final TextEditingController controller;
  final int maxLines;
  final double iconSizeFactor;
  final double iconPadding;
  final SettingsProvider settingsProvider;
  final bool enabled;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: EdgeInsets.only(
            right: SizeConfig.getProportionalWidth(iconPadding)),
        child: Row(
          textDirection: settingsProvider.language == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizeConfig.customSizedBox(
                iconSizeFactor, iconSizeFactor, Image.asset(icon)),
            SizeConfig.customSizedBox(10, null, null),
            CustomText(
              isCenter: false,
              text: TranslationService().translate(headerText),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
      Container(
        width: SizeConfig.getProportionalWidth(width),
        height: SizeConfig.getProportionalHeight(height),
        margin: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(10),
            horizontal: SizeConfig.getProportionalWidth(26)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 3.0, color: AppColors.widgetsColor),
        ),
        child: TextField(
          enabled: enabled,
          maxLines: maxLines,
          controller: controller,
          textAlign: textAlign == null
              ? settingsProvider.language == 'en'
                  ? TextAlign.left
                  : TextAlign.right
              : textAlign!,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(
                SizeConfig.getProportionalWidth(10),
                SizeConfig.getProportionalHeight(0),
                SizeConfig.getProportionalWidth(10),
                SizeConfig.getProportionalHeight(0)),
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
