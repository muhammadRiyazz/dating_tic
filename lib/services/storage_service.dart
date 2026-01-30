import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;
  
  Future<SharedPreferences> get _instance async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }
  
  Future<void> write(String key, String value) async {
    final prefs = await _instance;
    await prefs.setString(key, value);
  }
  
  Future<String?> read(String key) async {
    final prefs = await _instance;
    return prefs.getString(key);
  }
  
  Future<void> delete(String key) async {
    final prefs = await _instance;
    await prefs.remove(key);
  }
  
  Future<bool> contains(String key) async {
    final prefs = await _instance;
    return prefs.containsKey(key);
  }
  
  Future<void> clearAll() async {
    final prefs = await _instance;
    await prefs.clear();
  }
}