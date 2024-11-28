import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';

class FeatureContainer extends StatelessWidget {
  const FeatureContainer(
      {
        super.key,
        required this.imageUrl,
        required this.text,
        required this.settingsProvider,
        required this.onTap,
        this.left,
        this.right,
        this.top,
        this.bottom,
      });

  final String imageUrl;
  final String text;
  final SettingsProvider settingsProvider;
  final VoidCallback onTap;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: SizeConfig.getProportionalHeight(15)),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center, // Center everything within the Stack
          children: [
            Container(
              width: SizeConfig.getProportionalWidth(332),
              height: SizeConfig.getProportionalHeight(127),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: Image.asset(imageUrl, fit: BoxFit.fill),
            ),
            Positioned(
              left: left,
              right: right,
              top: top,
              bottom: bottom,
              child: Stack(
                children: [
                  // Stroke (Outer layer)
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.primaryFont,
                      fontSize: settingsProvider.language == 'en' ? 23 : 30,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = AppColors.primaryColor, // Stroke color
                    ),
                  ),
                  // Fill (Inner layer)
                  Text(
                    text,
                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontFamily: AppFonts.primaryFont,
                      fontSize: settingsProvider.language == 'en' ? 23 : 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.fontColor, // Fill color
                    ),
                  ),
                ],
              )

            )
          ],
        ),
      ),
    );
  }
}
