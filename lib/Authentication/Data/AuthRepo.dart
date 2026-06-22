import 'dart:convert';

import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Authentication/Domain/Interfaces/AuthData.dart';
import 'package:http/http.dart' as http;
import 'package:study_mate/secure_storage.dart';

class AuthRepo extends AuthData{

  String baseUrl = "https://host/StudyMate/";

  @override
  Future<ApiResponse> autoLogin(String refreshToken) async {
   await Future.delayed(Duration(seconds: 2),(){
   });
   return ApiResponse(statusCode: 404,error: "Not Implemented");
  }
  
  
  @override
  Future<ApiResponse> loginWithEmail(String email, String password) async {
   final url = Uri.parse("${baseUrl}url");
   
   try{
   final res = await http.post(
    url,
    headers: {
      'Content-Type' : 'Application/Json'
    },
    body: {
      jsonEncode({
        "email" : email,
        "password" : password
      })
    }
   );
   if(res.statusCode != 200){print("failed to login with code ${res.statusCode}");return ApiResponse(statusCode: res.statusCode);}
   final jsonFile = jsonDecode(res.body);
   String access_token = jsonFile['access_token'];
   String refresh_token = jsonFile['refresh_token'];
   await SecureTokens().saveTokens(access_token, refresh_token);
   return ApiResponse(statusCode: 200);  
   
   }
   catch(e){
    print("Failed to login with the given exception : $e");
    return ApiResponse(statusCode: 500, error: e.toString());
   }
  }
}