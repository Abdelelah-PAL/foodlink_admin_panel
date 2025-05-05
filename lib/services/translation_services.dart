import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/settings_provider.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();

  factory TranslationService() => _instance;

  TranslationService._internal();

  Map<String, String>? _localizedStrings;

  Future<void> loadTranslations(BuildContext context) async {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();

    late String? language = prefs.getString('app_language');
    if (language == null) {
      await prefs.setString('app_language', 'ar');
      language = prefs.getString('app_language');
    }

    settingsProvider.language = language!;

    String jsonString =
        await rootBundle.loadString('lib/core/utils/intl_$language.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) {
    if (_localizedStrings == null) {
      if (kDebugMode) {
        print('Error: Translations not loaded');
      }
      return key;
    }
    return _localizedStrings![key] ?? key;
  }
}
