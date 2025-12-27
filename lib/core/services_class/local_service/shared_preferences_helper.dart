import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _accessTokenKey = 'token';
  static const String _userIdKey = 'userId';
  static const String _userEmailKey = 'userEmail';
  static const String _isFirstLaunchKey = 'isFirstLaunch';
  static const String _hasCalledSendMessageOnceKey = 'hasCalledSendMessageOnce';

  // New flag key
  static const String _isNewFeatureSeenKey = 'isNewFeatureSeen';

  // Save access token
  static Future<void> saveAccessToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
    await prefs.setBool('isLogin', true);
  }

  // Retrieve access token
  static Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Check if it's the first launch
  static Future<bool> isFirstLaunch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Default to true if the key is not set
    return prefs.getBool(_isFirstLaunchKey) ?? true;
  }

  // Set the first launch flag to false
  static Future<void> setFirstLaunch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstLaunchKey, false);
  }

  // Check if sendMessage has been called once
  static Future<bool> hasCalledSendMessageOnce() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasCalledSendMessageOnceKey) ??
        false; // Default to false
  }

  // Getter for new feature seen flag
  static Future<bool> isNewFeatureSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isNewFeatureSeenKey) ?? false; // Default to false
  }

  // Setter for new feature seen flag
  static Future<void> setNewFeatureSeen(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isNewFeatureSeenKey, value);
  }

  static Future<String?> getPickerLocationUuid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('pickerLocationUuid');
  }

  // Save user ID
  static Future<void> saveUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  // Save user email
  static Future<void> saveUserEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  // Retrieve user ID
  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  // Retrieve user email
  static Future<String?> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // Clear access token
  static Future<void> clearAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove('isLogin');
  }

  static Future<bool?> checkLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLogin") ?? false;
  }

  static Future<void> pickerLocationUuid(String uuid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('pickerLocationUuid', uuid);
  }

  static const String _fcmTokenKey = 'fcmToken';

  // Save FCM token
  static Future<void> saveFcmToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fcmTokenKey, token);
  }

  // Retrieve FCM token
  static Future<String?> getFcmToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fcmTokenKey);
  }


  // Generic Save / Get / Remove for String & Bool

  static Future<void> saveString(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> saveBool(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> remove(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }


}
