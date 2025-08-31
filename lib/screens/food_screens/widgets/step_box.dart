import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../../providers/meals_provider.dart';
import '../../../providers/settings_provider.dart';

class StepBox extends StatelessWidget {
  const StepBox(
      {super.key, required this.settingsProvider, required this.controller});

  final TextEditingController controller;
  final SettingsProvider settingsProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getProportionalWidth(348),
      height: SizeConfig.getProportionalHeight(66),
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.getProportionalHeight(5),
        horizontal: SizeConfig.getProportionalWidth(3),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 3.0, color: AppColors.widgetsColor),
      ),
      child: TextField(
        controller: controller,
        textDirection: settingsProvider.language == 'en'
            ? TextDirection.ltr
            : TextDirection.rtl,
        // For right-to-left text
        textAlign: settingsProvider.language == 'en'
            ? TextAlign.left
            : TextAlign.right,
        style: const TextStyle(fontSize: 12),
        // Set font size here
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
              SizeConfig.getProportionalWidth(10),
              SizeConfig.getProportionalHeight(0),
              SizeConfig.getProportionalWidth(10),
              SizeConfig.getProportionalHeight(15)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class AddStepBox extends StatelessWidget {
  const AddStepBox({super.key, required this.mealsProvider, this.onTap});

  final MealsProvider mealsProvider;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? mealsProvider.increaseSteps,
      child: Container(
          width: SizeConfig.getProportionalWidth(348),
          height: SizeConfig.getProportionalHeight(66),
          margin: EdgeInsets.symmetric(
            vertical: SizeConfig.getProportionalHeight(5),
            horizontal: SizeConfig.getProportionalWidth(3),
          ),
          decoration: BoxDecoration(
            color: AppColors.widgetsColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(Icons.add)),
    );
  }
}
