import 'package:flutter/material.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/custom_text.dart';

class MealPropertiesHeader extends StatelessWidget {
  const MealPropertiesHeader({super.key,
    required this.settingsProvider,
    required this.icon,
    required this.text});

  final SettingsProvider settingsProvider;
  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          textDirection: settingsProvider.language == 'en'
              ? TextDirection.ltr
              : TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(scale: 1.3, icon),
            SizeConfig.customSizedBox(10, null, null),
            CustomText(
                isCenter: false,
                text: text,
                fontSize: 20,
                fontWeight: FontWeight.w700)
          ],
        ),
        const Divider(thickness: 1),
      ],
    );
  }
}
