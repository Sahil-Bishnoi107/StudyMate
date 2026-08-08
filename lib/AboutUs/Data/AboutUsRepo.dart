import 'package:dio/dio.dart';
import 'package:study_mate/AboutUs/Domain/PeopleCard.dart';
import 'package:study_mate/AboutUs/Domain/Person.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';

class AboutUsRepo {
  final Dio dio;

  AboutUsRepo(this.dio);

  Future<ApiResponse> fetchPeopleList()async{
    try{
      var res = await dio.get("/People/get-people-list");
      if(res.statusCode != 200){ print("Api cvalled for people list failed with code : ${res.statusCode}");  return ApiResponse(statusCode: res.statusCode ?? 500);}
      List<PersonCard> ps = [];
      var data = res.data;
      for(var d in data){
        ps.add(PersonCard.fromJson(d));
      }

      return ApiResponse(statusCode: 200,data: ps);

    }

    catch(e){
      print("Exception encountered while loading people list : $e");
      return ApiResponse(statusCode: 500);
    }
  }


  Future<ApiResponse> fetchPersonDetails(String id) async{
    try{
      var res = await dio.get("/People/get-people-by-id", queryParameters: {"id" : id});
      if(res.statusCode != 200){print("Api cvalled for person details failed with code : ${res.statusCode}");  return ApiResponse(statusCode: res.statusCode ?? 500);}
      Person person = Person.fromJson(res.data);
      return ApiResponse(statusCode: 200,data: person);
    }
    catch(e){
      print("Exception encountered while loading person details : $e");
      return ApiResponse(statusCode: 500);
    }
  }

}