import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';
import '../constants/app_constants.dart';

@singleton
class StorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final SharedPreferences _preferences;

  Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Secure Storage Methods (for sensitive data like tokens)
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: AppConstants.tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: AppConstants.tokenKey);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _secureStorage.write(
      key: AppConstants.refreshTokenKey,
      value: refreshToken,
    );
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: AppConstants.refreshTokenKey);
  }

  Future<void> saveUserData(String userData) async {
    await _secureStorage.write(key: AppConstants.userKey, value: userData);
  }

  Future<String?> getUserData() async {
    return await _secureStorage.read(key: AppConstants.userKey);
  }

  Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }

  // SharedPreferences Methods (for non-sensitive data)
  Future<void> saveLanguage(String language) async {
    await _preferences.setString(AppConstants.languageKey, language);
  }

  String? getLanguage() {
    return _preferences.getString(AppConstants.languageKey);
  }

  Future<void> saveThemeMode(String themeMode) async {
    await _preferences.setString(AppConstants.themeKey, themeMode);
  }

  String? getThemeMode() {
    return _preferences.getString(AppConstants.themeKey);
  }

  Future<void> saveBool(String key, bool value) async {
    await _preferences.setBool(key, value);
  }

  bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  Future<void> saveString(String key, String value) async {
    await _preferences.setString(key, value);
  }

  String? getString(String key) {
    return _preferences.getString(key);
  }

  Future<void> saveInt(String key, int value) async {
    await _preferences.setInt(key, value);
  }

  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  Future<void> clearPreferences() async {
    await _preferences.clear();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Clear all data (logout)
  Future<void> logout() async {
    await clearSecureStorage();
    await clearPreferences();
  }
}
