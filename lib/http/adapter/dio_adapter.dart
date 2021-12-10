import 'package:dio/dio.dart';
import 'package:flutter_templete/http/core/hi_net_adapter.dart';
import 'package:flutter_templete/http/core/hi_net_error.dart';
import 'package:flutter_templete/http/request/base_request.dart';

/// Dio 适配器
class DioAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
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
      // 抛出 HiNetError
      throw HiNetError(
        response?.statusCode ?? -1,
        error.toString(),
        data: buildRes(response, request),
      );
    }
    return buildRes<T>(response, request);
  }

  // 构建 HiNetResponse
  HiNetResponse<T> buildRes<T>(Response? response, BaseRequest request) {
    return HiNetResponse<T>(
      data: response?.data,
      request: request,
      statusCode: response?.statusCode,
      statusMessage: response?.statusMessage,
      extra: response,
    );
  }
}
