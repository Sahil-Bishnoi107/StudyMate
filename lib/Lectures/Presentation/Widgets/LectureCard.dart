import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
    String month = DateFormat('MMM').format(date);
    return "$month ${date.day}, ${date.year}";
  }

  String _formatSize(int size){
    double x = video.fileSize/(1024*1024);
    if(x < 10) return "${(x).toStringAsFixed(1)} MB";
    if(x < 1024)  return "${(x.toInt())} MB";
    if(x >= 1024  && x < 1024*10) return  "${(x/1024).toStringAsFixed(1)} GB";
    return "${((x/1024).toInt())} GB";
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double rad = width*0.04;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width * 0.85,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: width * 0.075),
        padding: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(rad),
          border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.4))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (video.thumbnail != null && video.thumbnail!.isNotEmpty)
              Stack(
                children: [
                  
                  ClipRRect(
                   borderRadius: BorderRadiusGeometry.only(
                    topLeft: Radius.circular(rad),
                    topRight: Radius.circular(rad)
                   ),
                    child: Image.network(
                      video.thumbnail!,
                      width: double.infinity,
                      height: height*0.19,
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
                  ),
                  Positioned(
                    top: height*0.07,left: width*0.35,
                    child: Container(
                      height: height*0.05,width: height*0.05,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 0.9),
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Center(
                      child: Icon(LucideIcons.play,size: 23,color: Colors.green,),
                    ),
                  )),
                  
                ],
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
          //  SizedBox(height: height*0.01),
            
            SizedBox(height: height*0.01),
            
            
            _videoIntro(height, width, video, _formatDate(video.createdAt), _formatDuration(video.duration),_formatSize(video.fileSize) , video.title)
            
          ],
        ),
      ),
    );
  }
}





Widget _videoIntro(double height, double width,VideoModel video, String foramteeddate,String duration,String videoSize,String title){
  Color lightColor = const Color.fromRGBO(140, 140, 140, 1);
  return Container(
    padding: EdgeInsets.symmetric(horizontal: width*0.03),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
              title ,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontFamily: Fonts.outfit,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
        SizedBox(height: height*0.005,),
        Row(
      
          children: [
           SizedBox(
            width: width*0.6,
            child: Row(
              children: [
               Icon(LucideIcons.graduationCap,size: 18,color: lightColor,),
               SizedBox(width: width*0.01,),
               Text("StudyMate Team", style: TextStyle(fontFamily: Fonts.outfit,color: lightColor,fontSize: 12),)
              ],
            )  
           ),

           Icon(FontAwesome.clock,size: 13,color: lightColor,),
           SizedBox(width: width*0.01,),
           Text(duration, style: TextStyle(fontFamily: Fonts.outfit,color: lightColor,fontSize: 12,fontWeight: FontWeight.w500),)
          ],
        )    ,
        SizedBox(height: height*0.01,),
        Text("\"${video.description}\"", style: TextStyle(fontFamily: Fonts.outfit,color: lightColor,fontSize: 12,fontStyle: FontStyle.italic),maxLines: 2,),
        SizedBox(height: height*0.015,),
        Row(
          children: [
            SizedBox(
              width: width*0.5,
              child: Row(
                children: [
                 _decoratedLabel(height, width, video.subject),
                         SizedBox(width: width*0.02,),
                         _decoratedLabel(height, width, "Random"),
                ],
              ),
            ),
           
           SizedBox(width: width*0.05,),
        //   _decoratedLabel2(height, width, videoSize,LucideIcons.database300Dir,lightColor),
           SizedBox(width: width*0.02,),
           _decoratedLabel2(height, width, foramteeddate,LucideIcons.calendar300Dir,lightColor),
           

          ],
        )
      ],
    ),
  );
}


Widget _decoratedLabel(double height, double width,String text){
  return  Container(
              padding: EdgeInsets.symmetric(horizontal: width*0.025),
              height: height*0.022,
              decoration: BoxDecoration(color: const Color.fromRGBO(158, 158, 158, 0.2),borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: Text(text,style:TextStyle(fontFamily: Fonts.outfit,fontSize: 10),),
              ),
            );
}

Widget _decoratedLabel2(double height, double width,String text, IconData icon,Color lightColor){
  return Row(
    children: [
      Icon(icon,size: 13,),
      SizedBox(width: width*0.01,),
      Text(text,style: TextStyle(fontFamily: Fonts.outfit,fontSize: 11,color:lightColor),)
    ],
  );
}