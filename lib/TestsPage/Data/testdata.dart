import 'dart:convert';

import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';

import 'package:study_mate/TestsPage/Domain/entities/Test.dart';
import 'package:http/http.dart' as http;
import 'package:study_mate/ngrok.dart';
import 'package:study_mate/secure_storage.dart';

class TestPageData{
  String baseUrl = "https://$ngrok/StudyMate/";

  Future<ApiResponse> testPageData() async{
   final url = Uri.parse("${baseUrl}Test/all-tests");
   String accessToken = await SecureTokens().getAccessToken() ?? "";
   try{
    final res = await http.get(
      url,
      headers: {
      'Content-Type' : 'application/json',
      'Authorization' : 'Bearer $accessToken'
      }
      );
      if(res.statusCode != 200){
      print("could not load profile with status code ${res.statusCode}");
      return ApiResponse(statusCode: res.statusCode);
     }
     final mp = jsonDecode(res.body);
     List<TestInfo> tests = [];
   

     for(var m in mp["tests"]){
      TestInfo test = TestInfo.fromJson(m);
      tests.add(test);
     }
   
     return ApiResponse(statusCode: 200, data: tests);

     }

   catch(e){
    print("Failed to load tests with exception $e");
    return ApiResponse(statusCode: 500, error: e.toString());
   } 
  }


}