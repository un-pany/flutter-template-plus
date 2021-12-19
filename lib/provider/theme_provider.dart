import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_template_plus/common/my_color.dart';
import 'package:flutter_template_plus/common/my_constants.dart';
import 'package:flutter_template_plus/db/my_cache.dart';

/// 扩展 ThemeMode
extension ThemeModeExtension on ThemeMode {
  // 这样就是可以通过 value 属性，获取对应的 String
  String get value => <String>['System', 'Light', 'Dark'][index];
}

/// 主题状态管理
class ThemeProvider extends ChangeNotifier {
  ThemeMode? _themeMode;

  // 判断是否是 Dark Mode（该方法用于页面上判断是否为 Dark Mode，然后切换样式）
  bool isDark() {
    if (_themeMode == ThemeMode.system) {
      // 获取系统的 Dark Mode
      return SchedulerBinding.instance?.window.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  // 获取主题模式
  ThemeMode getThemeMode() {
    String? themeMode = MyCache.getInstance().get(Constants.themeMode);
    switch (themeMode) {
      case 'System':
        _themeMode = ThemeMode.system;
        break;
      case 'Dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.light;
        break;
    }
    return _themeMode!;
  }

  // 设置主题模式
  void setThemeMode(ThemeMode themeMode) {
    MyCache.getInstance().setString(Constants.themeMode, themeMode.value);
    // 主题模式改变后，需要通知所有订阅者
    notifyListeners();
  }

  // 获取主题
  ThemeData getTheme({bool isDarkMode = false}) {
    var themeData = ThemeData(
      // 主题色
      primarySwatch: MyColor.primary,
      // 主色调（决定导航栏等颜色）
      // primaryColor: isDarkMode ? MyColor.dark_bg : MyColor.primary,
      // 亮度（深色还是浅色）
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      // 错误状态颜色（如输入框错误提示文字）
      errorColor: isDarkMode ? MyColor.dark_red : MyColor.light_red,
      // 文字强调色（前景色，也决定 ListView 的默认阴影颜色）
      accentColor: isDarkMode ? MyColor.white : MyColor.primary,
      // Tab 指示器的颜色
      // indicatorColor: isDarkMode ? MyColor.primary[50] : MyColor.white,
      // 页面背景色
      scaffoldBackgroundColor: isDarkMode ? MyColor.dark_bg : MyColor.white,
      // 用于突出显示切换 Widget（如 Switch，Radio 和 Checkbox）
      toggleableActiveColor: MyColor.primary,
    );
    return themeData;
  }
}
