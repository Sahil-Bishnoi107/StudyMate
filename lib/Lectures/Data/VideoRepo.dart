import 'package:dio/dio.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Lectures/Domain/VideoModel.dart';

class VideoRepo {
  final Dio dio;
  VideoRepo(this.dio);

  Future<ApiResponse> getVideosList() async {
    try {
      var res = await dio.get("/Videos/all-videos");
      if (res.statusCode != 200) {
        print("failed to fetch videos list from api due to statusCode : ${res.statusCode}");
        return ApiResponse(statusCode: res.statusCode ?? 500, error: "Failed to fetch data from API");
      }
      List<VideoModel> videos = [];
      var data = res.data;

  
      if (data is List) {
        for (var m in data) {
          VideoModel v = VideoModel.fromJson(m);
          videos.add(v);
          print("streamUrl is : ${v.streamUrl}");
        }
      }

      return ApiResponse(statusCode: 200, data: videos);
    } catch (e) {
      print("Exception occured while fetching video list : $e");
      return ApiResponse(statusCode: 100, error: "Exception occured while getting video list : $e");
    }
  }
}
