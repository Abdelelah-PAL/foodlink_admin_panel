import 'package:flutter/material.dart';
import '../../../core/constants/assets.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';

class CustomGoogleAuthBtn extends StatelessWidget {
  CustomGoogleAuthBtn({super.key, required this.onTap, required this.text, required this.settingsProvider});

  String text;
  VoidCallback? onTap;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.getProportionalHeight(48),
        width: SizeConfig.getProportionalWidth(300),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textFieldBorderColor, width: 1),
          borderRadius: BorderRadius.circular(5),
          color: AppColors.backgroundColor,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: SizeConfig.getProportionalWidth(10)),
          child: Row(
            children: [
              Image.asset(
                Assets.googleIcon,
                height: SizeConfig.getProportionalHeight(26),
                width: SizeConfig.getProportionalWidth(26),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: SizeConfig.getProportionalWidth(40)),
                child: Directionality(
                  textDirection: settingsProvider.language == "en"
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  child: Text.rich(
                      TextSpan(children: [
                    TextSpan(
                      text: text,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.primaryFont,
                          color: AppColors.hintTextColor),
                    ),
                    TextSpan(
                      text: ' Google',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.primaryFont,
                          color: AppColors.hintTextColor),
                    ),
                  ])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
