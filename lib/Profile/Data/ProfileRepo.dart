import 'package:dio/dio.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Contest/Domain/MyContest.dart';
import 'package:study_mate/Profile/Domain/practiceQuestion.dart';
import 'package:study_mate/Profile/Domain/student.dart';

class ProfileRepo{
  final Dio dio;
  ProfileRepo(this.dio);

   Future<ApiResponse> getStudentInfo() async{ 
   try{
    final res = await dio.get("/Test/user_profile");

     if(res.statusCode != 200){
      print("could not load profile with status code ${res.statusCode}");
      return ApiResponse(statusCode: res.statusCode ?? 0);
     }
     
     final jsonFile = res.data;
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


  Future<ApiResponse> getMyContests() async{
    try{
    var res = await dio.get("/Contest/my-contests");
    if(res.statusCode != 200){print("couyld not fetch my contests with code : ${res.statusCode}");
    return ApiResponse(statusCode: res.statusCode ?? 500);
    }
    List<MyContest> myContests = [];
    for(var m in res.data){
      myContests.add(MyContest.fromJson(m));
    }
    return ApiResponse(statusCode: 200, data: myContests);
    }
    catch(e){
      print("Failed to load contests with exception : $e");
      return ApiResponse(statusCode: 500);
    }
   }


   Future<ApiResponse> getMyQuestions()async{
    try{
      var res = await dio.get("/Questions/my-practice-questions");
      if(res.statusCode != 200){return ApiResponse(statusCode: res.statusCode ?? 500);}
      List<PracticeUserQuestion> questions = [];
      List<dynamic> json = res.data;
      for(var v in json){
        questions.add(PracticeUserQuestion.fromJson(v));
      }
      return ApiResponse(statusCode: 200,data: questions);
    }
    catch(e){
      print("Exception occured while getting questions : $e");
      return ApiResponse(statusCode: 500);
    }
   }
}