import 'package:flutter_templete/http/core/my_net_adapter.dart';
import 'package:flutter_templete/http/core/my_base_request.dart';

/// 测试适配器，mock数据

class MockAdapter extends MyNetAdapter {
  @override
  Future<MyNetResponse<T>> send<T>(MyBaseRequest request) {
    return Future<MyNetResponse<T>>.delayed(Duration(milliseconds: 1000), () {
      return MyNetResponse(
        data: {'code': 0, 'message': 'success'} as T,
        statusCode: 403,
      );
    });
  }
}
