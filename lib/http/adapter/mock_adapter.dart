import 'package:flutter_template/http/core/my_net_adapter.dart';
import 'package:flutter_template/http/core/my_base_request.dart';

/// 测试适配器，mock 数据
/// 在没有后端接口时，可用该适配器模拟测试整个发送 http 流程
/// 实际生产环境中，请使用 dio_adapter

class MockAdapter extends MyNetAdapter {
  @override
  Future<MyNetResponse<T>> send<T>(MyBaseRequest request) {
    return Future<MyNetResponse<T>>.delayed(Duration(milliseconds: 1000), () {
      return MyNetResponse(
        data: {
          'code': 20000,
          'message': 'message',
          'data': {'accessToken': 'Token'}
        } as T,
        statusCode: 200,
      );
    });
  }
}
