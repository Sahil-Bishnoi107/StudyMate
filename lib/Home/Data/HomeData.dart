import 'dart:convert';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Home/Domain/Entities/student.dart';
import 'package:http/http.dart' as http;
import 'package:study_mate/ngrok.dart';
import 'package:study_mate/secure_storage.dart';


class Homedata {
  String baseUrl = "https://$ngrok/StudyMate/";


  Future<ApiResponse> getStudentInfo() async{
    print("User Profile being Loaded");
   final url = Uri.parse("${baseUrl}Test/user_profile");
   try{
    String accessToken = await SecureTokens().getAccessToken() ?? "";
    print("Access tone is : $accessToken");
   final res = await http.get(
    url,
    headers: {
      'Content-Type' : 'application/json',
      'Authorization' : 'Bearer $accessToken'
    });

     if(res.statusCode != 200){
      print("could not load profile with status code ${res.statusCode}");
      return ApiResponse(statusCode: res.statusCode);
     }
     
     final jsonFile = jsonDecode(res.body);
     print("Loaded jsonFile of student data successfully : $jsonFile");
     Student student = Student.fromJson(jsonFile);
     ApiResponse response = ApiResponse(statusCode: 200,data: student);
     return response;
   }
   catch(e){
    print("Could not load the homepage with exception $e");
    return ApiResponse(statusCode: 500,error: e.toString());
  }
  }
  
}