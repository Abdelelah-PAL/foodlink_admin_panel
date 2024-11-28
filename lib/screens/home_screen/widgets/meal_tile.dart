import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/fonts.dart';
import '../../../core/utils/size_config.dart';
import '../../../services/translation_services.dart';
import '../../food_screens/meals_list_screen.dart';

class MealTile extends StatelessWidget {
  const MealTile(
      {super.key,
      required this.name,
      required this.imageUrl,
      required this.width,
      required this.height,
      required this.index,
      required this.categoryId});

  final String name;
  final String imageUrl;
  final double width;
  final double height;
  final int index;
  final int categoryId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(MealsListScreen(
              index: index,
            ));
          },
          child: Column(
            children: [
              SizeConfig.customSizedBox(
                width,
                height,
                Image.asset(imageUrl),
              ),
              Text(
                TranslationService().translate(name),
                style: TextStyle(
                    fontFamily: AppFonts.primaryFont,
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
        SizeConfig.customSizedBox(5, null, null),
      ],
    );
  }
}
