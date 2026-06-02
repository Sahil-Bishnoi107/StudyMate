import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Home/Data/fakeStudent.dart';
import 'package:study_mate/Home/Domain/Entities/student.dart';

class Homedata {
  
  Future<ApiResponse> getStudentInfo(String uid) async{
   await Future.delayed(Duration(seconds: 2),(){});
   Student student = Student.fromJson(Fakestudent().student);
   ApiResponse response = ApiResponse(statusCode: 200,data: student);
   return response;
  }
}