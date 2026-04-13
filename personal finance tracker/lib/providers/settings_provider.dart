import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _currency = 'ج.م';

  ThemeMode get themeMode => _themeMode;
  String get currency => _currency;

  String get currencySymbol => _currency;

  Future<void> loadSettings() async {
    final db = DatabaseHelper();
    final tm = await db.getSetting('theme_mode');
    _themeMode = tm == 'dark' ? ThemeMode.dark : (tm == 'light' ? ThemeMode.light : ThemeMode.system);
    final cur = await db.getSetting('currency');
    if (cur != null) _currency = cur;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    DatabaseHelper().setSetting('theme_mode', mode.name);
    notifyListeners();
  }

  void setCurrency(String currency) {
    _currency = currency;
    DatabaseHelper().setSetting('currency', currency);
    notifyListeners();
  }
}
