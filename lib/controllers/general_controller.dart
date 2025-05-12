import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/utils/size_config.dart';
import '../providers/settings_provider.dart';
import '../screens/widgets/custom_text.dart';

class GeneralController {
  static final GeneralController _instance = GeneralController._internal();

  factory GeneralController() => _instance;

  GeneralController._internal();

  String detectLanguage(String string) {
    String languageCode = 'en';

    final RegExp english = RegExp(r'^[a-zA-Z]+');
    final RegExp arabic = RegExp(r'^[\u0621-\u064A]+');

    if (english.hasMatch(string)) {
      languageCode = 'en';
    } else if (arabic.hasMatch(string)) {
      languageCode = 'ar';
    }
    return languageCode;
  }
  void launchURL(BuildContext context, Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open URL')),
      );
    }
  }

  void showCustomDialog(BuildContext context, SettingsProvider settingsProvider,
      String text, IconData icon, Color color, double? width) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SizeConfig.customSizedBox(
            width ?? 205,
            56,
            Row(
                textDirection: settingsProvider.language == 'en'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 30, color: color),
                  SizeConfig.customSizedBox(10, null, null),
                  CustomText(
                      isCenter: true,
                      text: text,
                      fontSize: settingsProvider.language == 'en' ? 12 : 20,
                      fontWeight: FontWeight.normal),
                ]),
          ),
        );
      },
    );
  }
}
