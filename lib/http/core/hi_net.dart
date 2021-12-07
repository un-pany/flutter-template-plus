import 'package:flutter_templete/http/request/base_request.dart';

class HiNet {
  HiNet._();
  // 饿汉模式
  static HiNet _instance = HiNet._();
  static HiNet getInstance() {
    return _instance;
  }

  Future fire(BaseRequest request) async {
    var respose = await send(request);
    var result = respose['data'];
    printLog(result);
    return result;
  }

  Future<dynamic> send<T>(BaseRequest request) async {
    printLog('url:${request.url()}');
    printLog('method:${request.httpMethod()}');
    request.addHeader('token', '123');
    printLog('header:${request.header}');
    return Future.value({
      'statusCode': 200,
      'data': {'code': 0, 'message': 'success'}
    });
  }

  void printLog(log) {
    print('hi_net:${log.toString()}');
  }
}
