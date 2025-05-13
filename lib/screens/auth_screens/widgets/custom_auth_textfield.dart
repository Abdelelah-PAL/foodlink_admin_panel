import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/settings_provider.dart';

class CustomAuthenticationTextField extends StatefulWidget {
  const CustomAuthenticationTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.textEditingController,
    required this.borderColor, required this.settingsProvider,
  });

  final String hintText;
  final bool obscureText;
  final TextEditingController textEditingController;
  final Color borderColor;
  final SettingsProvider settingsProvider;

  @override
  State<CustomAuthenticationTextField> createState() =>
      _CustomAuthenticationTextFieldState();
}

class _CustomAuthenticationTextFieldState
    extends State<CustomAuthenticationTextField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: SizeConfig.getProportionalHeight(12)),
      child: Container(
        width: SizeConfig.getProperHorizontalSpace(2),
        height: SizeConfig.getProperVerticalSpace(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.0, color: widget.borderColor),
          color: Colors.white,
        ),
        child: Padding(
          padding: widget.settingsProvider.language == 'en'
              ? EdgeInsets.only(left: SizeConfig.getProportionalWidth(10))
              : EdgeInsets.only(right: SizeConfig.getProportionalWidth(10)),
          child: TextField(
              textAlign:TextAlign.left,
              controller: widget.textEditingController,
              obscureText: widget.obscureText && !showPassword,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.getProportionalWidth(10),
                  vertical: SizeConfig.getProportionalWidth(5),
                ),
                suffixIcon:  widget.obscureText
                        ? IconButton(
                            icon: !showPassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          )
                    : null,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                    color: AppColors.hintTextColor,
                    fontFamily: AppFonts.primaryFont),
                border: InputBorder.none,
              )),
        ),
      ),
    );
  }
}
