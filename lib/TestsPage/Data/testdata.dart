

import 'package:dio/dio.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';

import 'package:study_mate/TestsPage/Domain/entities/Test.dart';




class TestPageData{
  final Dio dio;
  TestPageData(this.dio);

  Future<ApiResponse> testPageData() async{

   
   try{

      final res = await dio.get("/Test/all-tests");
      if(res.statusCode != 200){
      print("could not load profile with status code ${res.statusCode}");
      return ApiResponse(statusCode: res.statusCode ?? 0);
     }
     final mp = res.data;
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