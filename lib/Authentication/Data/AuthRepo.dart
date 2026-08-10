import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Authentication/Domain/Interfaces/AuthData.dart';
import 'package:http/http.dart' as http;
import 'package:study_mate/ngrok.dart';
import 'package:study_mate/secure_storage.dart';

class AuthRepo extends AuthData{
  final Dio dio;

  AuthRepo(this.dio);

  String baseUrl = "https://$ngrok/StudyMate/";

  @override
  Future<ApiResponse> autoLogin(String refreshToken) async {
   print("${baseUrl}Auth/auto_login");
   final url = Uri.parse("${baseUrl}Auth/auto_login");
   try{
    final res = await http.post(url,headers: {
      'Content-Type' : 'application/json'
    },
    body:   jsonEncode({
        "token" : refreshToken
      }));

      if(res.statusCode != 200){return ApiResponse(statusCode: res.statusCode);}
      final jsonFile = jsonDecode(res.body);
      String accessToken = jsonFile['access_token'] ?? "";
      String refreshToke = jsonFile['refresh_token'] ?? "";
      print("Access Tone : $accessToken");
      print("Refresh Tone : $refreshToke");
      await SecureTokens().saveTokens(accessToken, refreshToke);
      return ApiResponse(statusCode: 200);
   }
   catch(e){
    return ApiResponse(statusCode: 500);
   }
  }
  

  @override
  Future<ApiResponse> loginWithEmail(String email, String password) async {
    print("${baseUrl}Auth/login");
   final url = Uri.parse("${baseUrl}Auth/login");
   
   try{
   final res = await http.post(
    url,
    headers: {
      'Content-Type' : 'application/json'
    },
    body:   jsonEncode({
        "email" : email,
        "password" : password
      })
    
   );
   
   if(res.statusCode != 200){print("failed to login with code ${res.statusCode}");return ApiResponse(statusCode: res.statusCode);}
   final jsonFile = jsonDecode(res.body);
   String accessToken = jsonFile['access_token'] ?? "";
   String refreshToken = jsonFile['refresh_token'] ?? "";
   print("Access Tone : $accessToken");
   print("Refresh Tone : $refreshToken");
   await SecureTokens().saveTokens(accessToken, refreshToken);
   return ApiResponse(statusCode: 200);  
   
   }
   catch(e){
    print("Failed to login with the given exception : $e");
    return ApiResponse(statusCode: 500, error: e.toString());
   }
  }

  
  Future<ApiResponse> registerWithEmail(String name,String email, String password) async {
   final url = Uri.parse("${baseUrl}Auth/register");
   
   try{
   final res = await http.post(
    url,
    headers: {
      'Content-Type' : 'application/json'
    },
    body:   jsonEncode({
        "username" : name,
        "email" : email,
        "password" : password
      })
    
   );
   
   if(res.statusCode != 200){print("failed to register with code ${res.statusCode}");return ApiResponse(statusCode: res.statusCode);}
   final jsonFile = jsonDecode(res.body);
   String accessToken = jsonFile['access_token'] ?? "";
   String refreshToken = jsonFile['refresh_token'] ?? "";
   print("Access Tone : $accessToken");
   print("Refresh Tone : $refreshToken");
   await SecureTokens().saveTokens(accessToken, refreshToken);
   return ApiResponse(statusCode: 200);  
   
   }
   catch(e){
    print("Failed to login with the given exception : $e");
    return ApiResponse(statusCode: 500, error: e.toString());
   }
  }

  Future<ApiResponse> GoogleSignin(GoogleSignInAccount account) async{
    final auth = account.authentication;
    
    final idToken = auth.idToken;
    print("Google idToke is : $idToken");

    final url = Uri.parse("${baseUrl}Auth/google_login");
    final res = await http.post(url, headers: {'Content-Type' : 'application/json' }, body:
    jsonEncode({
      'id_token' : idToken
    }) );
    if(res.statusCode != 200){print("failed to signin from backend with code ${res.statusCode}");return ApiResponse(statusCode: res.statusCode);}
   final jsonFile = jsonDecode(res.body);
   String accessToken = jsonFile['access_token'] ?? "";
   String refreshToken = jsonFile['refresh_token'] ?? "";
   print("Access Tone : $accessToken");
   print("Refresh Tone : $refreshToken");
   await SecureTokens().saveTokens(accessToken, refreshToken);
   return ApiResponse(statusCode: 200); 
  }
}