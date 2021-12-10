import 'package:flutter_templete/http/core/hi_net_adapter.dart';
import 'package:flutter_templete/http/core/hi_net_error.dart';
import 'package:flutter_templete/http/adapter/dio_adapter.dart';
import 'package:flutter_templete/http/request/base_request.dart';

/// 支持第三方网络库插拔设计（当前架构选用 Dio），且不干扰业务层
/// 简洁易用，基于配置进行请求
/// Adapter 设计，扩展性强
/// 统一异常和返回处理
class HiNet {
  HiNet._();
  // 懒汉模式
  static HiNet? _instance;
  static HiNet getInstance() {
    if (_instance == null) {
      _instance = HiNet._();
    }
    return _instance!;
  }

  Future fire(BaseRequest request) async {
    HiNetResponse? response;
    var error;
    try {
      response = await send(request);
    } on HiNetError catch (e) {
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
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(statusCode ?? -1, result.toString(), data: result);
    }
  }

  Future<dynamic> send<T>(BaseRequest request) async {
    // printLog('url:${request.url()}');

    // 使用 mock 发送请求
    // HiNetAdapter adapter = MockAdapter();

    // 使用 Dio 发送请求
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }

  void printLog(log) {
    print('hi_net:${log.toString()}');
  }
}
