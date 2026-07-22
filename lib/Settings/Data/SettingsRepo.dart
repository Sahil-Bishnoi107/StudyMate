import 'package:dio/dio.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';

class SettingsRepo{
  final Dio dio;
  SettingsRepo(this.dio);

  Future<ApiResponse> LogOut() async{
    try{
       var res = await dio.post("/Auth/log-out");
       if(res.statusCode != 200){return ApiResponse(statusCode : res.statusCode ?? 500);}
       return ApiResponse(statusCode : 200);
    }
    catch(e){
      print("Failed to login with exception $e");
      return ApiResponse(statusCode :  500);
    }
  }

  Future<ApiResponse> DeleteAccount()async{
    try{
       var res = await dio.post("/Auth/delete-account");
       if(res.statusCode != 200){return ApiResponse(statusCode : res.statusCode ?? 500);}
       return ApiResponse(statusCode : 200);
    }
    catch(e){
      print("Failed to login with exception $e");
      return ApiResponse(statusCode : 500);
    }
  }

}