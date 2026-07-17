import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Contest/Domain/MyContest.dart';
import 'package:study_mate/Profile/Domain/student.dart';
import 'package:study_mate/fonts.dart';

class RatingSection extends StatelessWidget {
  final Student student;
  final List<MyContest> contests;
  final double height;
  final double width;
  const RatingSection({Key? key, required this.student, required this.contests, required this.height,required this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    final sortedContests = List<MyContest>.from(contests)..sort((a, b) => a.startTime.compareTo(b.startTime));
    
    int currentRating = 1500;
    for (var c in sortedContests) {
      currentRating += c.ratingChnage;
    }

    int previousRating = 1500;
    int contestsCount = sortedContests.length;
    
    if (contestsCount > 0) {
      int prevIndex = contestsCount > 5 ? contestsCount - 5 : 0;
      previousRating = 1500;
      for (int i = 0; i < prevIndex; i++) {
        previousRating += sortedContests[i].ratingChnage;
      }
    }

    int ratingGain = currentRating - previousRating;
    bool isPositive = ratingGain >= 0;

    return Container(
      height: height*0.15, width: width*0.55,
      margin: EdgeInsets.only(top: height*0.04,left: width*0.05),
     // color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Current",
                    style: TextStyle(fontFamily: Fonts.outfit,fontSize: 24,fontWeight: FontWeight.w600,color: Colors.green, ),
                  ),
                  Text(
                    " Rating",
                    style: TextStyle(fontFamily: Fonts.outfit,fontSize: 24,fontWeight: FontWeight.w600,color: Colors.black, ),
                  ),
                  SizedBox(width: 5,),
                  if(ratingGain > 0) Icon(LucideIcons.trendingUp400Dir,color: Colors.green,),
                  if(ratingGain < 0) Icon(LucideIcons.trendingUp400Dir,color: Colors.red,)
                ],
              ),

              

              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    currentRating.toString(),
                    style: TextStyle(
                      fontFamily: Fonts.outfit,
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color:  Colors.black
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${isPositive ? '+' : ''}$ratingGain",
                    style: TextStyle(
                      fontFamily: Fonts.nunito,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
             
              Text(
                "Progression Over Last 5 Contests",
                style: TextStyle(
                  fontFamily: Fonts.outfit,
                  fontSize: 10,
                  color: const Color.fromRGBO(110, 110, 110, 1),
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }


}
