

import 'package:dio/dio.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Contest/Domain/Contest.dart';
import 'package:study_mate/Contest/Domain/ContestQuestion.dart';
import 'package:study_mate/Contest/Domain/ContestResult.dart';
import 'package:study_mate/Contest/Domain/ContestResultQuestion.dart';
import 'package:study_mate/Contest/Domain/MyContest.dart';
import 'package:study_mate/Contest/Domain/Rating.dart';
import 'package:study_mate/Contest/Domain/SubmitContestQuestion.dart';

class ContestRepo{
  final Dio dio;
  ContestRepo(this.dio);

  Future<ApiResponse> getContestList() async{
    try {
      var res = await dio.get("/Contest/contest-list");
      if(res.statusCode != 200){
        print("failed to fethh list from api due to statusCode : ${res.statusCode}");
        return ApiResponse(statusCode: res.statusCode ?? 500, error: "Failed to fetch data from API");
      }
      List<Contest> contests = [];
      Map<String,dynamic> json = res.data;

      if(json.containsKey("contests")){
        for(var m in json["contests"]){
          contests.add(Contest.fromJson(m));
        }
      }

      return ApiResponse(statusCode: 200,data: contests);
    }
    catch(e){
      print("Exception occured while fetching contest list : $e");
      return ApiResponse(statusCode: 100, error: "Exception occured while getting contest list : $e");}
  }


  Future<ApiResponse> getMyRating() async{
    try{
      var res = await dio.get("/Contest/my-rating");
      if(res.statusCode != 200){
        print("Could not fetch Rating from API");
        return ApiResponse(statusCode: res.statusCode ?? 500);}

      return ApiResponse(statusCode: 200,data: Rating.fromJson(res.data));
    }
    catch(e){
      print("Exception occued while loading User Rating: $e");
      return ApiResponse(statusCode: 100, error: "Exception occured");}
  }
  
  Future<ApiResponse> FetchContestQuestions(String contestId) async{
     try{
      var res = await dio.get("/Contest/contest-questions", queryParameters: {'contestId' : contestId});
      if(res.statusCode != 200){
        print("Failed to fetch the contest Questions from the API with code : ${res.statusCode}");
        return ApiResponse(statusCode: res.statusCode ?? 500);
      }
      List<ContestQuestion> questions = [];
      Map<String,dynamic> json = res.data;
      if(json.containsKey("contest_questions")){
         for(var m in json["contest_questions"]){
          questions.add(ContestQuestion.fromJson(m));
         }
      }
      return ApiResponse(statusCode: 200, data: questions);
     }
     catch(e){
      print("Exception occured while loading contest questions : $e");
      return ApiResponse(statusCode: 100);
     }
  }

  // List<ContestResultQuestion>
  Future<ApiResponse> GetContestResultQuestions(String contestId)async {
    try{
      var res = await dio.get("/Contest/contest-result-questions", queryParameters: {'contestId' : contestId});
      if(res.statusCode != 200){
        print("Failed to fethc the questions with code : ${res.statusCode}");
        return ApiResponse(statusCode: res.statusCode ?? 500);
      }
      List<ContestResultQuestion> questions = [];
      var json = res.data;
      for(var m in json){
       questions.add(ContestResultQuestion.fromJson(m));
      }
      return ApiResponse(statusCode: 200,data: questions);
    }
    catch(e){
      print("Exception occured during fetching ContestResultQuestions : $e");
      return ApiResponse(statusCode: 100);
    }
  }


  Future<void> submitContest(List<ContestQuestion> questions,String contestId) async{
   try{
    List<Submitcontestquestion> ques = [];
    for(var q in questions){
      int? ans = q.ans;
      if(ans != null){
      ques.add(Submitcontestquestion(questionId: q.questionId, Answer: ans ));}
    }
    var res = await dio.post("/Contest/submit-contest", 
    data: {
      'contest_id' : contestId,
      'answers' : ques.map((e) => e.toJson()).toList()
    }
    );

    if(res.statusCode != 200){
      print("Could not submit the questions");
    }
    else{
      print("Contest Questions Submitted Successfully");
    }
   }
   catch(e){
    print("Exception Ocuured while submitting quesitons : $e");
   }
  }

  //ContestResult
  Future<ApiResponse> GetContestResult(String contestId) async{
    try{
      var res = await dio.get("/Contest/contest-result", queryParameters: {"contestId" : contestId});
      if(res.statusCode != 200){
        print("Failed to fetch reuslt with coide : ${res.statusCode}");
        return ApiResponse(statusCode: res.statusCode ?? 500);
      }
      Map<String,dynamic> json = res.data;
      return ApiResponse(statusCode: 200, data: ContestResult.fromJson(json));
    }
    catch(e){
      print("Exception Occured while fetching result : $e");
      return ApiResponse(statusCode: 500);
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

}