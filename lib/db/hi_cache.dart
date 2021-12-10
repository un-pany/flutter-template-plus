import 'package:shared_preferences/shared_preferences.dart';

/// 缓存管理类（基于 shared_preferences）
class HiCache {
  static HiCache? _instance;
  SharedPreferences? prefs;

  HiCache._() {
    init();
  }

  HiCache._pre(SharedPreferences prefs) {
    this.prefs = prefs;
  }

  // 预初始化，防止在使用时，prefs 还未完成初始化
  // 可以在全局（如 main.dart）先执行 preInit 方法
  static Future<HiCache> preInit() async {
    if (_instance == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _instance = HiCache._pre(prefs);
    }
    return _instance!;
  }

  static HiCache getInstance() {
    if (_instance == null) {
      _instance = HiCache._();
    }
    return _instance!;
  }

  void init() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
  }

  // 常用 set 方法
  setString(String key, String value) {
    prefs?.setString(key, value);
  }

  setDouble(String key, double value) {
    prefs?.setDouble(key, value);
  }

  setInt(String key, int value) {
    prefs?.setInt(key, value);
  }

  setBool(String key, bool value) {
    prefs?.setBool(key, value);
  }

  setStringList(String key, List<String> value) {
    prefs?.setStringList(key, value);
  }

  remove(String key) {
    prefs?.remove(key);
  }

  // get 方法
  T? get<T>(String key) {
    var result = prefs?.get(key);
    if (result != null) {
      return result as T;
    }
    return null;
  }
}
