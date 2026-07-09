import 'package:dio/dio.dart';
import 'package:study_mate/Networking/auth_interceptor.dart';
import 'package:study_mate/Networking/logging_interceptors.dart';
import 'package:study_mate/Networking/retry_interceptor.dart';
import 'package:study_mate/ngrok.dart';

class DioClient {
  late final Dio dio;

  DioClient(){
    dio = Dio(
      BaseOptions(
        baseUrl: "https://$ngrok",
        connectTimeout: const Duration(seconds: 10),
        contentType: "application/json",
        responseType: ResponseType.json,
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10)
        )
      );
    dio.interceptors.add(LoggingInterceptors());
    dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(RetryInterceptor());
    
  }
}