import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/controllers/meal_controller.dart';
import 'package:foodlink_admin_panel/core/constants/colors.dart';
import 'package:foodlink_admin_panel/core/utils/size_config.dart';
import 'package:foodlink_admin_panel/providers/meals_provider.dart';
import 'package:foodlink_admin_panel/providers/settings_provider.dart';
import 'package:foodlink_admin_panel/screens/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class AddDishOfTheWeekScreen extends StatefulWidget {
  const AddDishOfTheWeekScreen({super.key});

  @override
  State<AddDishOfTheWeekScreen> createState() => _AddDishOfTheWeekScreenState();
}

class _AddDishOfTheWeekScreenState extends State<AddDishOfTheWeekScreen> {
  @override
  Widget build(BuildContext context) {
    MealsProvider mealsProvider =
        Provider.of<MealsProvider>(context, listen: true);
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: DottedBorder(
              borderType: BorderType.RRect,
              child: ClipRect(
                child: Container(
                  width: SizeConfig.getProperVerticalSpace(3),
                  height: SizeConfig.getProperVerticalSpace(3),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  child: Center(
                      child: mealsProvider.dOWIsPicked == false
                          ? IconButton(
                              onPressed: () => MealsProvider().pickImage("DOW"),
                              icon: const Icon(Icons.add_a_photo))
                          : SizedBox(
                              width: SizeConfig.getProperVerticalSpace(3),
                              height: SizeConfig.getProperVerticalSpace(3),
                              child: Image.memory(
                                mealsProvider.pickedDOW!.files.first.bytes!,
                                fit: BoxFit.fill,
                              ))),
                ),
              ),
            ),
          ),
          SizeConfig.customSizedBox(null, 50, null),
          CustomButton(
              onTap: () async {
                await MealsProvider()
                    .uploadImage(mealsProvider.pickedDOW!, "dish_of_the_week");
                MealController().showSuccessDialog(context, settingsProvider);
                MealsProvider().resetValues();
              },
              text: "upload",
              width: 200,
              height: 100)
        ],
      ),
    );
  }
}
