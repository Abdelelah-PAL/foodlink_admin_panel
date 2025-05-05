import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';
import '../../core/utils/size_config.dart';

class ProfileCircle extends StatelessWidget {
  const ProfileCircle(
      {super.key,
      required this.height,
      required this.width,
      required this.iconSize});

  final double height;
  final double width;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getProportionalWidth(width),
      height: SizeConfig.getProportionalHeight(height),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.widgetsColor,
      ),
      child: Icon(
        Icons.person_outline_outlined,
        size: iconSize,
      ),
    );
  }
}
