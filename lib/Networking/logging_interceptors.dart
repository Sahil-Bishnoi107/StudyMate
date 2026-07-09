import 'package:dio/dio.dart';

class LoggingInterceptors extends Interceptor {

  @override
  void onRequest(RequestOptions options,RequestInterceptorHandler handler){
    print("REQUEST");
    print("METHOD : ${options.method}");
    print("URL : ${options.uri}");
    print("HEADERS : ${options.headers}");
    print("BODY : ${options.data}");

    handler.next(options);
  }

  @override 
  void onResponse(Response response, ResponseInterceptorHandler handler){
    print("RESPONSE");
    print("URL : ${response.realUri}");
    print("BODY : ${response.data}");
    handler.next(response);
  }

  @override  
  void onError(DioException err, ErrorInterceptorHandler handler ){
    print("ERROR");
    print("ERROR TYPE : ${err.type}");
    print("MESSAGE : ${err.message}");

    handler.next(err);
  }
}