import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

class DioLoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('➡️ REQUEST');
    log('URL: ${options.uri}');
    log('METHOD: ${options.method}');
    log('HEADERS: ${options.headers}');
    log('BODY: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('✅ RESPONSE');
    log('STATUS: ${response.statusCode}');

    final prettyJson = const JsonEncoder.withIndent(
      '  ',
    ).convert(response.data);

    log('DATA:\n$prettyJson');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('❌ ERROR [${err.message}]');
    log('MESSAGE: ${err.message}');
    log('DATA: ${err.response?.data}');
    super.onError(err, handler);
  }
}
