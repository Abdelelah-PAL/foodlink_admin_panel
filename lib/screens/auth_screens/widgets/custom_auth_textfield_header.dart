import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';

class CustomAuthTextFieldHeader extends StatelessWidget {
  const CustomAuthTextFieldHeader({super.key, required this.text, required this.settingsProvider});

  final String text;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: settingsProvider.language == "en"
          ? Alignment.topLeft
          : Alignment.topRight,
      child: Padding(
        padding: settingsProvider.language == 'en'
            ? EdgeInsets.only(left: SizeConfig.getProportionalWidth(35))
            : EdgeInsets.only(right: SizeConfig.getProportionalWidth(35)),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontFamily: AppFonts.primaryFont,
            color: AppColors.hintTextColor,
          ),
        ),
      ),
    );
  }
}
