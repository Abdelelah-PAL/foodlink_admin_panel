import 'package:flutter/material.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/custom_text.dart';

class HealthyIconText extends StatelessWidget {
  const HealthyIconText({super.key, required this.icon, required this.text, required this.settingsProvider});

  final String icon;
  final String text;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(icon),
        SizeConfig.customSizedBox(null, 10, null),
        CustomText(
            isCenter: true,
            text: text,
            fontSize: 15,
            fontWeight: FontWeight.bold)
      ],
    );
  }
}
