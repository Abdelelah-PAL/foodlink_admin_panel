import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../providers/settings_provider.dart';

class CustomErrorTxt extends StatelessWidget {
  const CustomErrorTxt({super.key, required this.text, required this.settingsProvider});

  final String text;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontFamily: AppFonts.primaryFont,
        color: AppColors.errorColor,
      ),
    );
  }
}
