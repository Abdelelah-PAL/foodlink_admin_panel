import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/core/constants/colors.dart';
import 'package:foodlink_admin_panel/screens/settings_screen/widgets/custom_settings_container.dart';
import 'package:foodlink_admin_panel/services/auth_services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/assets.dart';
import '../../core/utils/size_config.dart';
import '../../providers/settings_provider.dart';
import '../widgets/custom_text.dart';
import '../widgets/profile_circle.dart';
import 'widgets/custom_setting_tile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizeConfig.customSizedBox(null, 50, null),
        const CustomText(
            isCenter: true,
            text: "settings",
            fontSize: 30,
            fontWeight: FontWeight.bold),
        SizeConfig.customSizedBox(null, 25, null),
        const ProfileCircle(
          height: 200,
          width: 200,
          iconSize: 50,
        ),
        SizeConfig.customSizedBox(null, 50, null),
        CustomSettingsContainer(
            height: 500,
            settingsProvider: settingsProvider,
            children: [
              CustomSettingTile(
                icon: Assets.editInfo,
                text: "edit_data",
                trailing: GestureDetector(
                  onTap: () => AuthService().logout(),
                  child: Container(
                    alignment: Alignment.center,
                    height: SizeConfig.getProportionalHeight(70),
                    width: SizeConfig.getProportionalWidth(65),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.languageContainerColor,
                        border: Border.all(
                            width: 1, color: AppColors.widgetsColor)),
                    child: const CustomText(
                      isCenter: false,
                      text: 'logout',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              CustomSettingTile(icon: Assets.privacy, text: "privacy"),
            ]),
      ],
    );
  }
}
