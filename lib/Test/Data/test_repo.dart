

import 'dart:convert';

import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/Test/Domain/Entities/test.dart';
import 'package:study_mate/ngrok.dart';
import 'package:study_mate/secure_storage.dart';
import 'package:http/http.dart' as http;

class TestRepo {
    String baseUrl = "https://$ngrok/StudyMate/";

    Future<ApiResponse> getQuestions(String testId) async{
       final url = Uri.parse("${baseUrl}Test/test_questions/$testId");
       String accessToken = await SecureTokens().getAccessToken() ?? "";
       try{
       final res = await http.get(
        url,
        headers: {
        'Content-Type' : 'application/json',
        'access_token' : 'bearer $accessToken'
        });
        if(res.statusCode != 200){
          print("could not load profile with status code ${res.statusCode}");
          return ApiResponse(statusCode: res.statusCode);
        }
        final jsonFile = jsonDecode(res.body);
        final quesData = jsonFile;
         List<Question> questions = [];
         if(quesData.containsKey('questions')){
          for(var que in quesData['questions']){
            questions.add(Question.fromJson(que));
          }
         }

         return ApiResponse(statusCode: 200, data: questions);
       }
       catch(e){
        print("Could not load the homepage with exception $e");
        return ApiResponse(statusCode: 500,error: e.toString());
       }
         
    }

    Future<ApiResponse> uploadTest(Test test) async{
      final url = Uri.parse("${baseUrl}Test/submit-test");
      String accessToken = await SecureTokens().getAccessToken() ?? "";
      final submit_test = jsonEncode(test);

      try{
        final res = await http.post(
          url,
          headers: {
            'Content-Type' : 'application/json',
            'access_token' : 'bearer $accessToken'
          },
          body: submit_test
          );
          if(res.statusCode != 200){
            print("could not submit code ${res.statusCode}");
            return ApiResponse(statusCode: res.statusCode);
          }
          return ApiResponse(statusCode: 200);
      }
      catch(e){
        print("Failed to submit test with exception $e");
        return ApiResponse(statusCode: 500);
      }

       
    }
}


