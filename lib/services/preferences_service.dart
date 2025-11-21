import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  static SharedPreferences? _preferences;

  factory PreferencesService() {
    return _instance;
  }

  PreferencesService._internal();

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // User Name Operations
  Future<void> saveUserName(String userName) async {
    await _preferences?.setString('user_name', userName);
  }

  String? loadUserName() {
    return _preferences?.getString('user_name');
  }

  // Theme Mode Operations
  Future<void> saveThemeMode(bool isDarkMode) async {
    await _preferences?.setBool('is_dark_mode', isDarkMode);
  }

  bool loadThemeMode() {
    return _preferences?.getBool('is_dark_mode') ?? false;
  }
}
