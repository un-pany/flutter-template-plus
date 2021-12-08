import 'package:flutter_templete/http/core/hi_net_adapter.dart';
import 'package:flutter_templete/http/core/hi_net_error.dart';
import 'package:flutter_templete/http/adapter/dio_adapter.dart';
import 'package:flutter_templete/http/request/base_request.dart';

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
    printLog(result);

    // 解析状态码
    var statusCode = response?.statusCode;
    switch (statusCode) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(statusCode, result.toString(), data: result);
    }
  }

  Future<dynamic> send<T>(BaseRequest request) async {
    printLog('url:${request.url()}');
    // printLog('method:${request.httpMethod()}');
    // request.addHeader('token', '123');
    // printLog('header:${request.header}');
    // return Future.value({
    //   'statusCode': 200,
    //   'data': {'code': 0, 'message': 'success'}
    // });

    // 使用 mock 发送请求
    // HiNetAdapter adapter = MockAdapter();
    // return adapter.send(request);

    // 使用 Dio 发送请求
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }

  void printLog(log) {
    print('hi_net:${log.toString()}');
  }
}
