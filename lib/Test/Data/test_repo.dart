

import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/Test/Data/fake_ques.dart';
import 'package:study_mate/Test/Domain/Entities/test.dart';

class TestRepo {
    

    Future<ApiResponse> getQuestions(String testId) async{
         await Future.delayed(Duration(seconds: 1), (){});
         final quesData = fakeQuestions;
         List<Question> questions = [];
         if(quesData.containsKey('questions')){
          for(var que in quesData['questions']){
            questions.add(Question.fromJson(que));
          }
         }

         return ApiResponse(statusCode: 200, data: questions);
    }

    Future<ApiResponse> uploadTest(Test test) async{
     //  final submit_test = jsonEncode(test);

       await Future.delayed(Duration(seconds: 3),(){});
       // make api call to send it over
       return ApiResponse(statusCode: 200);
    }
}