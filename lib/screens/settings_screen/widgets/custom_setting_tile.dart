import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';
import '../../widgets/custom_text.dart';

class CustomSettingTile extends StatelessWidget {
  const CustomSettingTile(
      {super.key, required this.icon, required this.text, this.trailing});

  final String icon;
  final String text;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
    Provider.of<SettingsProvider>(context, listen: true);
    return Container(
      height: SizeConfig.getProportionalHeight(100),
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.getProportionalHeight(2),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.getProportionalWidth(10),
      ),
      child: Row(
        textDirection: settingsProvider.language == "en"
            ? TextDirection.ltr
            : TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizeConfig.customSizedBox(34, 50, Image.asset(icon)),
          Expanded(
            child: CustomText(
              text: text,
              isCenter: false,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          if (trailing != null) trailing!
        ],
      )
         );
  }
}
