import 'package:dio/dio.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/QuestionsSection/Domain/Collection.dart';
import 'package:study_mate/QuestionsSection/Domain/SubmitPracticeQuestion.dart';

class QuestionsRepo {
  final Dio dio;
  QuestionsRepo(this.dio);

  Future<ApiResponse> GetQuestions(List<String> subjects,List<String> difficulty, List<String> exams) async{
    List<Question> questions = [];
    try {
    final res = await dio.get("/Questions/questions",
     queryParameters: {
      'subject' : subjects, 'difficulty' : difficulty, 'examType' : exams
     }
    );
    if(res.statusCode != 200){
      return ApiResponse(statusCode: res.statusCode ?? 500);
    }

    final jsonFile = res.data;
    if(jsonFile.containsKey('questions')){
      for(var que in jsonFile['questions']){
        questions.add(Question.fromJson(que));
      }
    }
    return ApiResponse(statusCode: 200, data: questions);
    }
    catch(e){
      return ApiResponse(statusCode: 500, error: "Frontend Exception : $e");
    }
  }

  Future<ApiResponse> CreateCollection(String collectionName, int iconIndex) async{
     try{
      var res = await dio.post("/Questions/create-collection", data: {'collection_name' : collectionName, 'icon_index' : iconIndex});
      if(res.statusCode != 200){return ApiResponse(statusCode: res.statusCode ?? 500 , error: "Api call failed");}
      return ApiResponse(statusCode: 200);
     }
     catch(e){
      return ApiResponse(statusCode: 500, error: "Frontend Error: $e");
     }
  }

  Future<ApiResponse> AddCollection(String collectionId, String questionId) async{
    try{
      var res = await dio.post("/Questions/add-question-to-collection", data: {'collection_id' : collectionId, 'question_id' : questionId});
       if(res.statusCode != 200){return ApiResponse(statusCode: res.statusCode ?? 500 , error: "Api call failed");}
      return ApiResponse(statusCode: 200);
     }
     catch(e){
      return ApiResponse(statusCode: 500, error: "Frontend Error: $e");
     }  
  }

  Future<ApiResponse> LoadMyCollections() async {
    List<Collection> collections = [];

    try{
      var res = await dio.get("/Questions/my-collections");
      if(res.statusCode != 200){return ApiResponse(statusCode: res.statusCode ?? 500);}

      if(res.data.containsKey('collections')){
        for(var col in res.data['collections']){
          collections.add(Collection.fromJson(col));
        }
      }
      return ApiResponse(statusCode: 200,data: collections);
    }

    catch(e){
      return ApiResponse(statusCode: 500, error: "Failed to load collections with exception : $e");
    }   
  }


  Future<ApiResponse> LoadCollectionQuestions(String collectionId)async {
   List<Question> questions = [];
   try{
    var res = await dio.get("/Questions/collection-questions", queryParameters: {'collectionId' : collectionId});
    if(res.statusCode != 200){return ApiResponse(statusCode: res.statusCode ?? 500);}

    final jsonFile = res.data;
    if(jsonFile.containsKey('collection_questions')){
        for(var que in jsonFile['collection_questions']){
          questions.add(Question.fromJson(que));
        }
    }
    return ApiResponse(statusCode: 200, data: questions);
   }
   catch(e){
    return ApiResponse(statusCode: 500, error: "Collection Questions not fetched due to exception : $e");
   }
  }

  Future<ApiResponse> SumbitQuestion(Question que) async{
    try{
    Map<String,dynamic> q = que.toJson();

    final res = await dio.post("/Questions/submit-question", data: q);
    if(res.statusCode != 200){return ApiResponse(statusCode: res.statusCode ?? 500);}
    return ApiResponse(statusCode: 200);
    }
    catch(e){
      throw Exception("could not submit question");
    }
  }

  Future<void> SaveQuestion(Submitpracticequestion que)async {
    try{
     var res =  await dio.post("/Questions/save-question", data: que.toJson());
     if(res.statusCode != 200){print("Question Could not be saved");}
     else{
      print("Question Saved");
     }
    }
    catch(e){
      print("Question could not be saved due to exception $e");
    }
  }


}