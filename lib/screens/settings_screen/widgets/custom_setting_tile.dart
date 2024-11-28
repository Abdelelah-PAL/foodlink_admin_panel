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
        height: SizeConfig.getProportionalHeight(27),
        margin: EdgeInsets.symmetric(
          vertical: SizeConfig.getProportionalHeight(7),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.getProportionalWidth(10),
        ),
        child: settingsProvider.language == "en"
            ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizeConfig.customSizedBox(34, 24, Image.asset(icon)),
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
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (trailing != null) trailing!,
                  Expanded(
                    child: CustomText(
                      text: text,
                      isCenter: false,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizeConfig.customSizedBox(24, 24, Image.asset(icon)),
                ],
              )
        );
  }
}
