import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../providers/meals_provider.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        MealsProvider().resetValues();
        Get.back();
      },
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
    );
  }
}
