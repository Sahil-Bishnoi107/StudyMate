import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Authentication/Domain/Interfaces/AuthData.dart';

class AuthRepo extends AuthData{

  @override
  Future<ApiResponse> autoLogin(String refreshToken) async {
   await Future.delayed(Duration(seconds: 2),(){
   });
   return ApiResponse(statusCode: 404,error: "Not Implemented");
  }
  
  @override
  Future<ApiResponse> loginWithEmail(String email, String password) async {
    Future.delayed(Duration(seconds: 1),(){ });
  
    if(email == "sahilbishnoi@gmail.com" && password == "12345678"){
      return ApiResponse(statusCode: 200,data: email + password);
    }
    return ApiResponse(statusCode: 400);
  }
}