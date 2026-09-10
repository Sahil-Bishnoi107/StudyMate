import 'package:dio/dio.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/GeneratedQuestions/Domain/Entities/gen_question.dart';

class GenQuestionsRepo {
  final Dio dio;
  GenQuestionsRepo(this.dio);

  Future<ApiResponse> getGeneratedQuestions(
    String subject,
    int page,
    int size,
  ) async {
    try {
      final res = await dio.get(
        '/GenQuestions/generated-questions',
        queryParameters: {
          'subject': subject,
          'page': page,
          'size': size,
        },
      );
      if (res.statusCode != 200) {
        print('Could not load generated questions: ${res.statusCode}');
        return ApiResponse(statusCode: res.statusCode ?? 0);
      }
      final dynamic jsonData = res.data;
      final List<GenQuestion> questions = [];
      if (jsonData is List) {
        for (final item in jsonData) {
          questions.add(GenQuestion.fromJson(item as Map<String, dynamic>));
        }
      }
      return ApiResponse(statusCode: 200, data: questions);
    } catch (e) {
      print('Failed to load generated questions: $e');
      return ApiResponse(statusCode: 500, error: e.toString());
    }
  }

  Future<ApiResponse> removeQuestions(List<String> ids) async {
    try {
      final res = await dio.post(
        '/GenQuestions/remove-questions',
        data: ids,
      );
      if (res.statusCode != 200) {
        print('Could not remove questions: ${res.statusCode}');
        return ApiResponse(statusCode: res.statusCode ?? 0);
      }
      return ApiResponse(statusCode: 200);
    } catch (e) {
      print('Failed to remove questions: $e');
      return ApiResponse(statusCode: 500, error: e.toString());
    }
  }
}
