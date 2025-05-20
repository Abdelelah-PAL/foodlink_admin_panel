import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/size_config.dart';
import '../../widgets/custom_text.dart';

class ListHeader extends StatelessWidget {
  const ListHeader({
    super.key,
    required this.text,
    required this.onTap,
    required this.space,
  });

  final String text;
  final VoidCallback onTap;
  final double space;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: SizeConfig.getProportionalHeight(10),
        left: SizeConfig.getProportionalWidth(10),
        right: SizeConfig.getProportionalWidth(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomText(
            isCenter: true,
            text: text,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          SizeConfig.customSizedBox(space, null, null),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: SizeConfig.getProportionalWidth(30),
              height: SizeConfig.getProportionalHeight(50),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.widgetsColor),
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
    );
  }
}
