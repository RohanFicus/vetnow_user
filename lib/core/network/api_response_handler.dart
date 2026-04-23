import 'package:dio/dio.dart';
import 'package:vetnow_user/core/network/api_exception.dart';
import 'package:vetnow_user/features/auth/data/models/api_response.dart';

class ApiResponseHandler {
  static ApiResponse<T, M> handleResponse<T, M>(
    Response response,
    T Function(dynamic json)? fromJsonT,
    M Function(dynamic json)? fromJsonM,
  ) {
    final statusCode = response.statusCode ?? 0;

    // HTTP success
    if (statusCode >= 200 && statusCode < 300) {
      final apiResponse = ApiResponse<T, M>.fromJson(
        response.data,
        fromJsonT,
        fromJsonM,
      );

      if (!apiResponse.status) {
        throw ApiException(apiResponse.message, statusCode);
      }

      return apiResponse;
    }

    // HTTP client error (400–499)
    final message = response.data is Map<String, dynamic>
        ? response.data['message'] ?? 'Bad Request'
        : 'Bad Request';

    throw ApiException(message, statusCode);
  }
}
