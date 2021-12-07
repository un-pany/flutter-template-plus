import 'package:dio/dio.dart';
import 'package:flutter_templete/http/core/hi_net_adapter.dart';
import 'package:flutter_templete/http/core/hi_net_error.dart';
import 'package:flutter_templete/http/request/base_request.dart';

/// Dio 适配器
class DioAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    var response, options = Options(headers: request.header);
    var error;
    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await Dio().get(request.url(), options: options);
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await Dio()
            .post(request.url(), data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.PUT) {
        response = await Dio()
            .put(request.url(), data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        response = await Dio()
            .delete(request.url(), data: request.params, options: options);
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }
    if (error != null) {
      // 输出 HiNetError
      throw HiNetError(response?.statusCode ?? -1, error.toString(),
          data: buildRes(response, request));
    }
    return buildRes<T>(response, request);
  }

  // 构建 HiNetResponse
  HiNetResponse<T> buildRes<T>(Response response, BaseRequest request) {
    return HiNetResponse(
      data: response.data as T,
      request: request,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      extra: response,
    );
  }
}
