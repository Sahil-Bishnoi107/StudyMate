import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/TestsPage/Data/fakeTestData.dart';
import 'package:study_mate/TestsPage/Domain/entities/Test.dart';

class TestPageData{


  Future<ApiResponse> testPageData() async{
   await Future.delayed(Duration(seconds: 1),(){});
   List<TestInfo> tests = [];
   Map<String,dynamic> mp = fakeTests;

   for(var m in mp["tests"]){
    TestInfo test = TestInfo.fromJson(m);
    tests.add(test);
   }
   
   return ApiResponse(statusCode: 200, data: tests);
  }
}