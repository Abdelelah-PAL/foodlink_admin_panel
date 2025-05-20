import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () {
        Get.back();
      },
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
    );
  }
}
