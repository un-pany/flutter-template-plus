import 'package:flutter_templete/http/core/my_net_adapter.dart';
import 'package:flutter_templete/http/core/my_net_error.dart';
import 'package:flutter_templete/http/adapter/dio_adapter.dart';
import 'package:flutter_templete/http/core/my_base_request.dart';

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
      printLog(e.message);
    } catch (e) {
      // 其他异常
      error = e;
      printLog(e);
    }

    if (response == null) {
      printLog(error);
    }

    var result = response?.data;
    printLog('请求结果:$result');

    // 解析 http 状态码
    var statusCode = response?.statusCode;
    switch (statusCode) {
      case 200:
        // 当 'http状态码' == 200 时，根据具体的业务，还可以在这里统一解析'业务状态码'，即 response?.data['code']，而不是直接 return result;
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw MyNetError(statusCode ?? -1, result.toString(), data: result);
    }
  }

  Future<dynamic> send<T>(MyBaseRequest request) async {
    // printLog('url:${request.url()}');

    // 使用 mock 发送请求
    // MyNetAdapter adapter = MockAdapter();

    // 使用 Dio 发送请求
    MyNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }

  void printLog(log) {
    print('hi_net:${log.toString()}');
  }
}
