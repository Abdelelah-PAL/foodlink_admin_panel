import 'package:flutter/material.dart';

import '../../core/utils/size_config.dart';


class ImageContainer extends StatelessWidget {
  const ImageContainer({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Container(
        width: SizeConfig.getProportionalWidth(332),
        height: SizeConfig.getProportionalHeight(127),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Image.asset(imageUrl, fit: BoxFit.fill),
      ),
    );
  }
}
