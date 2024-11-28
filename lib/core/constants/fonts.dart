import '../../providers/settings_provider.dart';

class AppFonts {
  static String titleFont = 'salsa';
  static String primaryFont =
      SettingsProvider().language == "en" ? 'salsa' : 'MyriadArabic';
}
