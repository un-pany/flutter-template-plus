import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences
class SP {
  static SharedPreferences? prefs;

  // 初始化
  static Future<bool> init() async {
    prefs = await SharedPreferences.getInstance();
    return true;
  }

  static String? getToken() {
    return prefs?.getString('token');
  }

  static Future<bool?> setToken(string) async {
    return await prefs?.setString('token', string);
  }
}
