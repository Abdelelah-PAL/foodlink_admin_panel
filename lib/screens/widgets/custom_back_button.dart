import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../providers/meals_provider.dart';
import '../../providers/storage_provider.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, required this.storageProvider});
  final StorageProvider storageProvider;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        MealsProvider().resetValues(storageProvider);
        Get.back();
      },
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
    );
  }
}
