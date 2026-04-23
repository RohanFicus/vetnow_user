import 'package:dio/dio.dart';

import '../storage/secure_storage_service.dart';
import 'auth_interceptor.dart';
import 'dio_logger_interceptor.dart';

class ApiClient {
  late final Dio dio;

  ApiClient() {
    final storage = SecureStorageService();
    dio = Dio(
      BaseOptions(
        baseUrl: "https://gwen-postmycotic-overtrustfully.ngrok-free.dev/",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {"Content-Type": "application/json"},
        // 🔥 IMPORTANT
        validateStatus: (status) {
          return true;
        },
      ),
    );

    // 🔥 ADD LOGGER
    dio.interceptors.addAll([
      AuthInterceptor(storage),
      if (!bool.fromEnvironment('dart.vm.product')) DioLoggerInterceptor(),
    ]);
  }
}
