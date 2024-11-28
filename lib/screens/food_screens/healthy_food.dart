import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../providers/settings_provider.dart';
import '../../providers/admins_provider.dart';
import '../../services/translation_services.dart';
import '../dashboard/widgets/custom_bottom_navigation_bar.dart';
import '../widgets/app_header.dart';
import '../widgets/custom_text.dart';
import '../widgets/image_container.dart';
import 'widgets/healthy_icon_text.dart';

class HealthyFood extends StatelessWidget {
  const HealthyFood({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);
    AdminsProvider adminsProvider =
        Provider.of<AdminsProvider>(context, listen: true);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(SizeConfig.getProportionalHeight(100)),
        child: AppHeader(
          adminId: adminsProvider.selectedAdmin!.adminId,
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar:
          const CustomBottomNavigationBar(fromDashboard: false),
      body: Column(children: [
        Stack(
          children: [
            ImageContainer(imageUrl: Assets.healthyFoodHeaderImage),
            Positioned(
                left: SizeConfig.getProportionalWidth(39),
                child: SizeConfig.customSizedBox(
                    137, 134, Image.asset(Assets.healthyDish))),
            Positioned(
              left: SizeConfig.getProportionalWidth(230),
              child: Column(
                children: [
                  Text(
                    TranslationService().translate("healthy_dish"),
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: AppFonts.primaryFont,
                        fontWeight: FontWeight.bold,
                        color: AppColors.backgroundColor,
                        shadows: const [
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 8.0,
                            color: AppColors.errorColor,
                          ),
                        ]),
                  ),
                  SizeConfig.customSizedBox(null, 10, null),
                  Text(
                    TranslationService().translate("vegetables_percent"),
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: AppFonts.primaryFont,
                        fontWeight: FontWeight.bold,
                        color: AppColors.backgroundColor,
                        shadows: const [
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 8.0,
                            color: AppColors.errorColor,
                          ),
                        ]),
                  ),
                  Text(
                    TranslationService().translate("fruits_percent"),
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: AppFonts.primaryFont,
                        fontWeight: FontWeight.bold,
                        color: AppColors.backgroundColor,
                        shadows: const [
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 8.0,
                            color: AppColors.errorColor,
                          ),
                        ]),
                  ),
                  Text(
                    TranslationService().translate("grains_percent"),
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: AppFonts.primaryFont,
                        fontWeight: FontWeight.bold,
                        color: AppColors.backgroundColor,
                        shadows: const [
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 8.0,
                            color: AppColors.errorColor,
                          ),
                        ]),
                  ),
                  Text(
                    TranslationService().translate("protiens_percent"),
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: AppFonts.primaryFont,
                        fontWeight: FontWeight.bold,
                        color: AppColors.backgroundColor,
                        shadows: const [
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            blurRadius: 8.0,
                            color: AppColors.errorColor,
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.getProportionalHeight(20)),
          child: settingsProvider.language == "en"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    HealthyIconText(
                      icon: Assets.measurement,
                      text: "measurements",
                      settingsProvider: settingsProvider,
                    ),
                    SizeConfig.customSizedBox(20, null, null),
                    HealthyIconText(
                        icon: Assets.calories,
                        text: "calories",
                        settingsProvider: settingsProvider),
                    SizeConfig.customSizedBox(20, null, null),
                    HealthyIconText(
                        icon: Assets.nutritionSystem,
                        text: "nutrition_system",
                        settingsProvider: settingsProvider),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    HealthyIconText(
                        icon: Assets.nutritionSystem,
                        text: "nutrition_system",
                        settingsProvider: settingsProvider),
                    SizeConfig.customSizedBox(20, null, null),
                    HealthyIconText(
                        icon: Assets.calories,
                        text: "calories",
                        settingsProvider: settingsProvider),
                    SizeConfig.customSizedBox(20, null, null),
                    HealthyIconText(
                        icon: Assets.measurement,
                        text: "measurements",
                        settingsProvider: settingsProvider),
                  ],
                ),
        ),
        Align(
          alignment: settingsProvider.language == 'en'
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.getProportionalWidth(20)),
            child: const CustomText(
                isCenter: false,
                text: "chosen_healthy_meals",
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        )
      ]),
    );
  }
}
