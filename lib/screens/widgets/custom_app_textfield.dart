import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../providers/settings_provider.dart';
import '../../services/translation_services.dart';
import 'custom_text.dart';

class CustomAppTextField extends StatelessWidget {
  const CustomAppTextField({super.key,
    required this.width,
    required this.height,
    this.headerText,
    this.icon,
    this.hintText,
    required this.controller,
    required this.maxLines,
    required this.iconSizeFactor,
    required this.settingsProvider,
    required this.isCentered,
     this.textAlign,});

  final double width;
  final double height;
  final String? headerText;
  final String? hintText;
  final String? icon;
  final TextEditingController controller;
  final int maxLines;
  final double iconSizeFactor;
  final SettingsProvider settingsProvider;
  final bool isCentered;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Row(
        textDirection: settingsProvider.language == 'en'
            ? TextDirection.ltr
            : TextDirection.rtl,
        mainAxisAlignment: isCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          if(icon != null)Align(
              alignment: Alignment.centerLeft,
              child: icon != null
                  ? SizeConfig.customSizedBox(
                  iconSizeFactor, iconSizeFactor, Image.asset(icon!))
                  : null
          ),
          if (headerText != null) CustomText(
            isCenter: false,
            text: TranslationService().translate(headerText!),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          if (headerText != null && icon != null) SizeConfig.customSizedBox(15, null, null),
          Container(
            width: SizeConfig.getProportionalWidth(width),
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
              textAlign: textAlign ?? (settingsProvider.language == 'en'
                  ? TextAlign.left
                  : TextAlign.right),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(
                      SizeConfig.getProportionalWidth(10),
                      SizeConfig.getProportionalHeight(10),
                      SizeConfig.getProportionalWidth(10),
                      SizeConfig.getProportionalHeight(30)),
                  hintStyle: TextStyle(
                      fontSize: 20,
                      color: AppColors.hintTextColor,
                      fontFamily: AppFonts.primaryFont),
                  border: InputBorder.none,
                  hintText: hintText != null ? TranslationService().translate(hintText!) : null
              ),
            ),
          ),
        ]);
  }
}
