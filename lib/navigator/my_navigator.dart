import 'package:flutter/material.dart';
import 'package:flutter_template/pages/detail_page.dart';
import 'package:flutter_template/pages/navigator_page.dart';
import 'package:flutter_template/pages/login_page.dart';

/// 自定义路由封装，也就是路由状态，unknown 代表未知的页面
enum RouteStatus { login, navigator, home, detail, unknown }

/// 创建页面
pageWrap(Widget child) {
  return MaterialPage(
    // key 保持唯一就行
    key: ValueKey(child.hashCode),
    child: child,
  );
}

/// 获取 routeStatus 在页面栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

/// 获取 page 对应的 RouteStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is NavigatorPage) {
    return RouteStatus.navigator;
  } else if (page.child is DetailPage) {
    return RouteStatus.detail;
  } else {
    return RouteStatus.unknown;
  }
}

/// 路由信息
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

/// ***********************************************************************

// current 当前页面
// pre 上次的页面
typedef RouteChangeListener(RouteStatusInfo current, RouteStatusInfo? pre);

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

/// 抽象类供 MyNavigator 实现
abstract class _RouteJumpListener {
  // routeStatus 代表要跳转的页面
  // args 代表要传递的值
  void onJumpTo(RouteStatus routeStatus, {Map args});
}

/// 定义路由跳转逻辑要实现的功能
class RouteJumpListener {
  final OnJumpTo onJumpTo;
  RouteJumpListener({required this.onJumpTo});
}

/// 监听路由页面跳转
/// 感知当前页面是否压后台
class MyNavigator extends _RouteJumpListener {
  static MyNavigator? _instance;

  RouteJumpListener? _routeJump;
  List<RouteChangeListener> _listeners = [];
  RouteStatusInfo? _current;

  /// 首页底部tab
  // RouteStatusInfo? _bottomTab;

  MyNavigator._();

  static MyNavigator getInstance() {
    if (_instance == null) {
      _instance = MyNavigator._();
    }
    return _instance!;
  }

  // RouteStatusInfo? getCurrent() {
  //   return _current;
  // }

  /// 打开 h5
  // Future<bool> openH5(String url) async {
  //   var result = await canLaunch(url);
  //   if (result) {
  //     return await launch(url);
  //   } else {
  //     return Future.value(false);
  //   }
  // }

  /// 首页底部tab切换监听
  // void onBottomTabChange(int index, Widget page) {
  //   _bottomTab = RouteStatusInfo(RouteStatus.home, page);
  //   _notify(_bottomTab!);
  // }

  /// 注册路由跳转逻辑
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    this._routeJump = routeJumpListener;
  }

  /// 监听路由页面跳转
  void addListener(RouteChangeListener listener) {
    // 如果没有添加过则添加进去
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  /// 移除监听
  void removeListener(RouteChangeListener listener) {
    _listeners.remove(listener);
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJump?.onJumpTo(routeStatus, args: args);
  }

  /// 通知路由页面变化
  /// currentPages 当前页面堆栈
  /// prePages 变化前的页面堆栈
  void notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    // 如果没有变化，则不做处理，直接 return
    if (currentPages == prePages) return;
    var current =
        RouteStatusInfo(getStatus(currentPages.last), currentPages.last.child);
    _notify(current);
  }

  void _notify(RouteStatusInfo current) {
    // if (current.page is BottomNavigator && _bottomTab != null) {
    //   // 如果打开的是首页，则明确到首页具体的 tab
    //   current = _bottomTab!;
    // }
    print('hi_navigator:current:${current.page}');
    print('hi_navigator:pre:${_current?.page}');
    _listeners.forEach((listener) {
      listener(current, _current);
    });
    _current = current;
  }
}
