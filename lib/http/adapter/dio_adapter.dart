import 'package:dio/dio.dart';
import 'package:flutter_templete/http/core/my_net_adapter.dart';
import 'package:flutter_templete/http/core/my_net_error.dart';
import 'package:flutter_templete/http/core/my_base_request.dart';

/// Dio 适配器
class DioAdapter extends MyNetAdapter {
  @override
  Future<MyNetResponse<T>> send<T>(MyBaseRequest request) async {
    var response;
    var error;
    var options = Options(headers: request.header);
    try {
      switch (request.httpMethod()) {
        case HttpMethod.GET:
          response = await Dio().get(
            request.url(),
            options: options,
          );
          break;
        case HttpMethod.POST:
          response = await Dio().post(
            request.url(),
            data: request.params,
            options: options,
          );
          break;
        case HttpMethod.PUT:
          response = await Dio().put(
            request.url(),
            data: request.params,
            options: options,
          );
          break;
        case HttpMethod.DELETE:
          response = await Dio().delete(
            request.url(),
            data: request.params,
            options: options,
          );
          break;
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }
    if (error != null) {
      // 抛出 MyNetError
      throw MyNetError(
        response?.statusCode ?? -1,
        error.toString(),
        data: buildRes(response, request),
      );
    }
    return buildRes<T>(response, request);
  }

  // 构建 MyNetResponse
  MyNetResponse<T> buildRes<T>(Response? response, MyBaseRequest request) {
    return MyNetResponse<T>(
      data: response?.data,
      request: request,
      statusCode: response?.statusCode,
      statusMessage: response?.statusMessage,
      extra: response,
    );
  }
}
