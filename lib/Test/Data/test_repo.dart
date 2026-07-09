



import 'package:dio/dio.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/Test/Domain/Entities/test.dart';



class TestRepo {
    final Dio dio;
    TestRepo(this.dio);
  

    Future<ApiResponse> getQuestions(String testId) async{
    
       
       try{

        final res = await dio.get("/Test/test-questions/$testId");
        if(res.statusCode != 200){
          print("could not load testwith ${res.statusCode}");
          return ApiResponse(statusCode: res.statusCode ?? 0);
        }
        final jsonFile = res.data;
        print(jsonFile);
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
        print("Could not load the test with exception $e");
        return ApiResponse(statusCode: 500,error: e.toString());
       }
         
    }

    Future<ApiResponse> uploadTest(Test test) async{
      try{
       
          final res = await dio.post("/Test/submit-test",data: test.toJson());
          if(res.statusCode != 200){
            print("could not submit code ${res.statusCode}");
            return ApiResponse(statusCode: res.statusCode ?? 0);
          }
          return ApiResponse(statusCode: 200);
      }
      catch(e){
        print("Failed to submit test with exception $e");
        return ApiResponse(statusCode: 500);
      }

       
    }
}


