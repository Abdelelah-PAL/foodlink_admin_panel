import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';

class CustomSettingsContainer extends StatelessWidget {
  const CustomSettingsContainer(
      {super.key, required this.height, required this.children, required this.settingsProvider});

  final double height;
  final List<Widget> children;
  final SettingsProvider settingsProvider;


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: SizeConfig.getProportionalWidth(346),
        height: SizeConfig.getProportionalHeight(height),
        margin: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(10),
            horizontal: SizeConfig.getProportionalWidth(20)),
        decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(blurRadius: 2),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: settingsProvider.language == "en"
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: children,
        ),
      ),
    );
  }
}
