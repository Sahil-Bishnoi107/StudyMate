import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  @override  
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("Add retry logic or something");
    super.onError(err, handler);
  }
}