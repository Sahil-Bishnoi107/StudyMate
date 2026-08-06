import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/Lectures/Domain/VideoModel.dart';
import 'package:study_mate/fonts.dart';

class LectureCard extends StatelessWidget {
  final VideoModel video;
  final VoidCallback onTap;

  const LectureCard({
    super.key,
    required this.video,
    required this.onTap,
  });

  String _formatDuration(double seconds) {
    int totalSeconds = seconds.toInt();
    int m = totalSeconds ~/ 60;
    int s = totalSeconds % 60;
    return "${m}m ${s}s";
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width * 0.9,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: width * 0.05),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (video.thumbnail != null && video.thumbnail!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  video.thumbnail!,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 180,
                      color: Colors.grey[200],
                      child: Icon(Bootstrap.camera_video, size: 50, color: Colors.grey),
                    );
                  },
                ),
              )
            else
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Bootstrap.camera_video, size: 50, color: Colors.grey),
              ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    video.subject.toUpperCase(),
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: Fonts.nunito,
                    ),
                  ),
                ),
                Text(
                  _formatDate(video.createdAt),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: Fonts.nunito,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              video.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: Fonts.inter,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              video.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontFamily: Fonts.nunito,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.5), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Bootstrap.clock, size: 14, color: Colors.black),
                      SizedBox(width: 5),
                      Text(
                        _formatDuration(video.duration),
                        style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: Fonts.nunito),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 15, color: Colors.black),
                  Row(
                    children: [
                      Icon(Bootstrap.file_earmark, size: 14, color: Colors.black),
                      SizedBox(width: 5),
                      Text(
                        "${(video.fileSize / (1024 * 1024)).toStringAsFixed(1)} MB",
                        style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: Fonts.nunito),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
