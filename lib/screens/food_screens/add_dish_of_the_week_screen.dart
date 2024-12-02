import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/core/constants/colors.dart';
import 'package:foodlink_admin_panel/core/utils/size_config.dart';
import 'package:foodlink_admin_panel/providers/meals_provider.dart';
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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: SizeConfig.getProperVerticalSpace(3),
              height: SizeConfig.getProperVerticalSpace(3),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    style: BorderStyle.solid,
                  )),
              child: Center(
                  child: mealsProvider.imageIsPicked == false
                      ? IconButton(
                          onPressed: MealsProvider().pickImage,
                          icon: const Icon(Icons.add_a_photo))
                      : SizedBox(
                          width: SizeConfig.getProperVerticalSpace(3),
                          height: SizeConfig.getProperVerticalSpace(3),
                          child: Image.network(
                            mealsProvider.pickedFile!.path,
                            fit: BoxFit.fill,
                          ),
                        )),
            ),
          ),
          SizeConfig.customSizedBox(null, 50, null),
          CustomButton(
              onTap: () => MealsProvider().uploadImage(
                  mealsProvider.pickedFile!.path, "dish_of_the_week"),
              text: "upload",
              width: 200,
              height: 100)
        ],
      ),
    );
  }
}
