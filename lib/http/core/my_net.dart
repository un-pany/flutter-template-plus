import 'package:flutter_template/http/core/my_net_adapter.dart';
import 'package:flutter_template/http/core/my_net_error.dart';
import 'package:flutter_template/http/adapter/dio_adapter.dart';
import 'package:flutter_template/http/core/my_base_request.dart';
import 'package:flutter_template/http/dao/login_dao.dart';
import 'package:flutter_template/navigator/my_navigator.dart';
import 'package:flutter_template/navigator/my_navigator_util.dart';

/// 支持第三方网络库插拔设计（当前架构选用 Dio），且不干扰业务层
/// 简洁易用，基于配置进行请求
/// Adapter 设计，扩展性强
/// 统一异常和返回处理
class MyNet {
  MyNet._();
  // 懒汉模式
  static MyNet? _instance;
  static MyNet getInstance() {
    if (_instance == null) {
      _instance = MyNet._();
    }
    return _instance!;
  }

  Future fire(MyBaseRequest request) async {
    MyNetResponse? response;
    var error;
    try {
      response = await send(request);
    } on MyNetError catch (e) {
      error = e;
      response = e.data;
      printLog('异常信息:${e.message}');
    } catch (e) {
      // 其他异常
      error = e;
      printLog('其他异常:$e');
    }

    if (response == null) {
      printLog(error);
    }

    var result = response?.data;
    printLog('请求结果:$result');

    // http 状态码
    int? statusCode = response?.statusCode;
    // 业务状态码（这要求后端接口严格按着统一的格式返回，这里要求必须返回业务 code）
    int? code = result != null ? result['code'] : null;
    // http 状态码拦截器
    return statusCodeInterceptor(statusCode, code, result);
  }

  Future<dynamic> send<T>(MyBaseRequest request) async {
    // 使用 mock 发送请求
    // MyNetAdapter adapter = MockAdapter();

    // 使用 Dio 发送请求
    MyNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }

  // http 状态码拦截器
  statusCodeInterceptor(int? statusCode, code, result) {
    switch (statusCode) {
      case 200:
        // 当 'http 状态码' == 200 时，根据具体的业务，在这里统一解析'业务状态码'
        return codeInterceptor(code, result);
      case 401:
        // 删除失效的 Token
        LoginDao.removeToken();
        // 调起登录页
        MyNavigator.getInstance().onJumpTo(RouteStatus.login);
        throw NeedLogin();
      case 403:
        // 删除失效的 Token
        LoginDao.removeToken();
        // 调起登录页
        MyNavigator.getInstance().onJumpTo(RouteStatus.login);
        throw NeedAuth(result.toString(), data: result);
      case null:
        throw MyNetError(-1, '网络异常', data: result);
      default:
        throw MyNetError(statusCode ?? -1, result.toString(), data: result);
    }
  }

  // 业务状态码拦截器
  codeInterceptor(code, result) {
    switch (code) {
      // 业务状态码 20000，代表成功
      case 20000:
        return result;
      default:
        throw MyNetError(code ?? -1, result.toString(), data: result);
    }
  }

  void printLog(log) {
    print('my_net:${log.toString()}');
  }
}
