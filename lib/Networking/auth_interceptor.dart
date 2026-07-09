import 'package:dio/dio.dart';
import 'package:study_mate/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    
    String? accessToken = await SecureTokens().getAccessToken();
    if(accessToken != null){
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    else{
      print("Access Token is missing");
    }
    handler.next(options);
  }
}