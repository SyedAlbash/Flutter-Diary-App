import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static late SharedPreferences _prefs;
  static bool _initialized = false;
  static final Map<String, dynamic> _fallbackStorage = {};

  /// Whether SharedPreferences has been successfully initialized.
  static bool get isInitialized => _initialized;

  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
      for (var entry in _fallbackStorage.entries) {
        if (entry.value is String) {
          await _prefs.setString(entry.key, entry.value);
        } else if (entry.value is bool) {
          await _prefs.setBool(entry.key, entry.value);
        }
      }
      _fallbackStorage.clear();
    } catch (e) {
      debugPrint("SharedPreferences Init Error: $e");
    }
  }

  static Future<void> setString(String key, String value) async {
    if (_initialized) {
      await _prefs.setString(key, value);
    } else {
      _fallbackStorage[key] = value;
    }
  }

  static String? getString(String key) {
    if (_initialized) return _prefs.getString(key);
    return _fallbackStorage[key] as String?;
  }

  static Future<void> setBool(String key, bool value) async {
    if (_initialized) {
      await _prefs.setBool(key, value);
    } else {
      _fallbackStorage[key] = value;
    }
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    if (_initialized) return _prefs.getBool(key) ?? defaultValue;
    return (_fallbackStorage[key] as bool?) ?? defaultValue;
  }

  static Future<void> remove(String key) async {
    if (_initialized) {
      await _prefs.remove(key);
    } else {
      _fallbackStorage.remove(key);
    }
  }

  // Keys
  static const String keyUserName = 'user_name';
  static const String keyPin = 'user_pin';
  static const String keyPattern = 'user_pattern';
  static const String keyLockType = 'lock_type'; // 'pin' or 'pattern'
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyReminderEnabled = 'reminder_enabled';
  static const String keyReminderTime = 'reminder_time'; // "HH:mm"
}
