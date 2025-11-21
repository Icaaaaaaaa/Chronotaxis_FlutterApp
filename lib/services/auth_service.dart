import 'package:shared_preferences/shared_preferences.dart';
import 'database_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  late SharedPreferences _prefs;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Register new user
  Future<bool> register(String email, String password) async {
    try {
      final dbService = DatabaseService();
      
      // Check if email already exists
      if (await dbService.emailExists(email)) {
        print('Email sudah terdaftar: $email');
        return false;
      }

      // Insert new user
      await dbService.insertUser(email, password);
      print('User berhasil didaftarkan: $email');
      
      // Jangan auto-login, user harus login manual
      
      return true;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  // Login user
  Future<bool> login(String email, String password) async {
    try {
      final dbService = DatabaseService();
      final user = await dbService.getUserByEmail(email);

      if (user == null) {
        return false;
      }

      // Check password
      if (user['password'] != password) {
        return false;
      }

      // Save logged in user email to SharedPreferences
      await _prefs.setString('logged_in_email', email);
      
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Logout user
  Future<void> logout() async {
    await _prefs.remove('logged_in_email');
  }

  // Get current logged in user email
  String? getLoggedInUser() {
    return _prefs.getString('logged_in_email');
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _prefs.getString('logged_in_email') != null;
  }
}
