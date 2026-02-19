import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesService {
  static const _alertsKey = 'home.alertsEnabled';
  static const _darkKey = 'home.darkAppearance';
  static const _favoritesKey = 'home.favoriteAreas';

  Future<bool> getAlertsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_alertsKey) ?? true;
  }

  Future<bool> getDarkAppearance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkKey) ?? false;
  }

  Future<Set<String>> getFavoriteAreas() async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(_favoritesKey) ?? <String>[];
    return values.toSet();
  }

  Future<void> setAlertsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_alertsKey, value);
  }

  Future<void> setDarkAppearance(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkKey, value);
  }

  Future<void> setFavoriteAreas(Set<String> areas) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, areas.toList()..sort());
  }
}
