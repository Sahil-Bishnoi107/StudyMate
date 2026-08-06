

import 'package:study_mate/Lectures/Data/ExtraData.dart';

class VideoModel {
  final String videoId;
  final String title;
  final String subject;
  final String description;
  final String originalName;
  final int fileSize;
  final double duration;
  final String? thumbnail;
  final String? streamUrl;
  final DateTime createdAt;

  VideoModel({
    required this.videoId,
    required this.title,
    required this.subject,
    required this.description,
    required this.originalName,
    required this.fileSize,
    required this.duration,
    this.thumbnail,
    this.streamUrl,
    required this.createdAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> mp) {
  String? streamUrl = mp["streamUrl"];
  String? thumbnail = mp["thumbnailUrl"] ?? mp["thumbnail"];

  if (isDev) {
    streamUrl = streamUrl?.replaceAll("localhost:9000", ngrokVideoUrl);
    thumbnail = thumbnail?.replaceAll("localhost:9000", ngrokVideoUrl);
  }

  return VideoModel(
    videoId: mp["id"] ?? mp["videoId"],
    title: mp["title"],
    subject: mp["subject"],
    description: mp["description"],
    originalName: mp["originalFileName"] ?? mp["originalName"],
    fileSize: mp["fileSize"],
    duration: ((mp["durationSeconds"] ?? mp["duration"]) as num).toDouble(),
    thumbnail: thumbnail,
    streamUrl: streamUrl,
    createdAt: DateTime.parse(mp["createdAt"]),
  );
}

  Map<String, dynamic> toJson() {
    return {
      "videoId": videoId,
      "title": title,
      "subject": subject,
      "description": description,
      "originalName": originalName,
      "fileSize": fileSize,
      "duration": duration,
      "thumbnail": thumbnail,
      "streamUrl": streamUrl,
      "createdAt": createdAt.toIso8601String(),
    };
  }
}