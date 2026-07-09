import 'package:dio/dio.dart';
import 'package:study_mate/secure_storage.dart';

class RefreshTokenInterceptor extends Interceptor{
  final Dio dio;
    final SecureTokens secureTokens;
    RefreshTokenInterceptor(this.dio,this.secureTokens);
  @override  
  void onError(DioException err, ErrorInterceptorHandler handler) async{
    if(err.response?.statusCode != 401){
     return handler.next(err);
    }
    if(err.requestOptions.extra['isRefresh'] == true){return handler.next(err);}
    String? refreshToken = await secureTokens.getRefreshToken();
    if(refreshToken == null){
      print("No refresh Token to use"); handler.next(err);
      return handler.next(err);
    }

    try {
    final res = await dio.post(
      "/Auth/auto_login", 
     data: {"token" : refreshToken},
     options: Options(
      extra: {"isRefresh" : true}
     ));

    if(res.statusCode != 200){
      print("Could not update the access token with error : ${res.statusCode}");
      return handler.next(err);
    }
    String accessToken = res.data['access_token'];
    await secureTokens.updateAccessToken(accessToken);
    
    err.requestOptions.headers['Authorization'] = 'Bearer $accessToken';
    final response = await  dio.fetch(err.requestOptions);
    return handler.resolve(response);
    }
    catch(e){
     return  handler.next(err);
    }
  }
}