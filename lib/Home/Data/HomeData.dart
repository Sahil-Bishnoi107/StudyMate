
import 'package:dio/dio.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Home/Domain/Entities/student.dart';

import 'package:study_mate/ngrok.dart';



class Homedata {
  final Dio dio;
  Homedata(this.dio);

  String baseUrl = "https://$ngrok/StudyMate/";


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
  
}