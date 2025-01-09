import 'package:flutter/material.dart';
import 'package:foodlink_admin_panel/screens/widgets/profile_circle.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/size_config.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/admins_provider.dart';
import '../../services/translation_services.dart';

class AppHeader extends StatefulWidget {
  const AppHeader({super.key, required this.adminId});

  final String adminId;

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    AdminsProvider adminsProvider =
        Provider.of<AdminsProvider>(context, listen: true);
    String greeting = TranslationService().translate("greeting");
    greeting = greeting.replaceFirst(
        '{name}', adminsProvider.selectedAdmin!.name!);
    return Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.getProportionalHeight(50),
          left: SizeConfig.getProportionalWidth(24),
          right: SizeConfig.getProportionalWidth(24),
        ),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Material(
                    type: MaterialType.transparency,
                    child: IconButton(
                      onPressed: () async {},
                      icon: const Icon(
                          color: Colors.black,
                          Icons.notifications_none_outlined),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: DashboardProvider().toggleExpanded,
                      child: Container(
                        width: SizeConfig.getProportionalWidth(94),
                        height: SizeConfig.getProportionalHeight(22),
                        margin: EdgeInsets.only(
                          left: SizeConfig.getProportionalWidth(11),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: AppColors.widgetsColor,
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  bottom: SizeConfig.getProportionalHeight(20),
                                  right: SizeConfig.getProportionalWidth(11)),
                              width: SizeConfig.getProportionalWidth(8),
                              height: SizeConfig.getProportionalHeight(6),
                              child: const Icon(Icons.arrow_drop_down),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  TranslationService().translate("admin"),
                                  style: TextStyle(
                                    fontFamily: AppFonts.primaryFont,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const ProfileCircle(
                height: 38,
                width: 38,
                iconSize: 25,
              ),
              Align(
                alignment: settingsProvider.language == 'en'
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Text(
                  greeting,
                  textDirection: settingsProvider.language == 'en'
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: AppFonts.primaryFont,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ]));
  }
}
