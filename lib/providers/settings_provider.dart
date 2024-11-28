import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_settings.dart';
import 'package:flutter/cupertino.dart';

import '../services/settings_services.dart';
import '../services/translation_services.dart';

class SettingsProvider with ChangeNotifier {
  static final SettingsProvider _instance = SettingsProvider._internal();

  factory SettingsProvider() => _instance;

  SettingsProvider._internal();

  final SettingsServices _ss = SettingsServices();
  late UserSettings settings;
  late String language = 'ar';
  late bool isLoading = false;

  Future<void> addSettings(userId) async {
    await _ss.addSettings(userId);
  }

  Future<void> getSettingsByUserId(String userId) async {
    try {
      settings = await _ss.getSettingsByUserId(userId);
      notifyListeners();
    } catch (ex) {
      rethrow;
    }
  }

  void toggleNotifications(userId) async {
    settings.activeNotifications = !settings.activeNotifications;
    notifyListeners();
    await _ss.toggleNotifications(userId, settings.activeNotifications);
  }

  void toggleUpdates(userId) async {
    settings.activeUpdates = !settings.activeUpdates;
    notifyListeners();
    await _ss.toggleUpdates(userId, settings.activeUpdates);
  }

  void changeLanguage(chosenLanguage, userId, context) async {
    language = chosenLanguage;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', language);
    await _ss.changeLanguage(userId, language);
    await TranslationService().loadTranslations(context);
  }
}
