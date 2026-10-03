import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Contest/Domain/Contest.dart';
import 'package:study_mate/fonts.dart';

class ContestCard extends StatelessWidget {
  final Contest contest;
  final DateTime currentTime;
  final VoidCallback onJoin;

  const ContestCard({super.key,required this.contest,required this.currentTime,required this.onJoin});

  DateTime get _endTime => contest.startTime.add(Duration(minutes: contest.duration));

  String _getTimeLabel() {
    if (currentTime.isBefore(contest.startTime)) return "Begins In";
    if (currentTime.isBefore(_endTime)) return "Ends In";
    return "Status";
  }

  String _getTimeLeftText() {
    if (currentTime.isBefore(contest.startTime)) {
      Duration diff = contest.startTime.difference(currentTime);
      if (diff.inDays > 0) return "${diff.inDays}d : ${diff.inHours % 24}h";
      return "${diff.inHours}h : ${diff.inMinutes % 60}m";
    } else if (currentTime.isBefore(_endTime)) {
      Duration diff = _endTime.difference(currentTime);
      return "${diff.inHours}h : ${diff.inMinutes % 60}m";
    } else {
      return "Ended";
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    bool isEnded = currentTime.isAfter(_endTime);
    bool isUpcoming = currentTime.isBefore(contest.startTime);

    Map<String,Color> difficultyIndex = {
      "hard" : Colors.red,
      "medium" : Colors.orange,
      "easy" : Colors.green
    };
    String participants = contest.participants > 1000 ? "${(contest.participants / 1000).toStringAsFixed(1)}k" : contest.participants.toString();

    return Container(
      width: width*0.9,
      margin: EdgeInsets.only(bottom: height*0.015,left: width*0.05,right: width*0.05),
      padding: EdgeInsets.symmetric(horizontal: width*0.04,vertical: height*0.016),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromRGBO(220, 220, 220, 0.8)),
        borderRadius: BorderRadius.circular(Responsive.font(context, 5))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              Container(height: height*0.05,width: height*0.05,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Responsive.icon(context, 10)),color: const Color.fromRGBO(30, 30, 30, 1)),
              child: Icon(LucideIcons.zap,color: Colors.white,size: Responsive.icon(context, 22),)
              ),
              SizedBox(width: width*0.03,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contest.contestName.toUpperCase(),style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w500,fontSize: Responsive.font(context, 14)),),
                    Text(contest.subject.toUpperCase(),style: TextStyle(color: Colors.blueGrey,fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 12)),)
                  ],
                ),
              ),
              SizedBox(width: width*0.02,),
              Text(contest.difficulty.toUpperCase(),style: TextStyle(color: difficultyIndex[contest.difficulty.toLowerCase()] ?? Colors.black,fontFamily: Fonts.nunito,fontSize: Responsive.font(context, 9),fontWeight: FontWeight.bold),)
            ],
          ),
          SizedBox(height: height*0.018,),
          Row(
            children: [
              Expanded(child: _stat(width, LucideIcons.timer400Dir, "Duration", "${contest.duration} mins", Colors.orange, context)),
              Expanded(child: _stat(width, LucideIcons.users400Dir, "Joined", participants, Colors.blue, context)),
              Expanded(child: _stat(width, LucideIcons.circleCheck400Dir, "Marks", "+${contest.marksPerQuestion} / -${contest.negativeMarking.abs()}", Colors.green, context)),
            ],
          ),
          SizedBox(height: height*0.015,),
          Container(height: 1.5,color: const Color.fromRGBO(220, 220, 220, 0.5),),
          SizedBox(height: height*0.012,),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_getTimeLabel(),style: TextStyle(fontFamily: Fonts.nunito,color: Colors.blueGrey,fontSize: Responsive.font(context, 10)),),
                    Text(_getTimeLeftText(),style: TextStyle(fontFamily: Fonts.outfit,fontWeight: FontWeight.w500,fontSize: Responsive.font(context, 14),color: isEnded ? Colors.blueGrey : (isUpcoming ? Colors.black : Colors.green)),),
                  ],
                ),
              ),
              if(!isEnded)
              InkWell(
                onTap: onJoin,
                child: Container(height: height*0.04,width: width*0.3,
                decoration: BoxDecoration(color: isUpcoming ? Colors.white : Colors.green,border: Border.all(color:  Colors.green)),
                child: Center(child: Text(isUpcoming ? "View Details" : "Join Now",style: TextStyle(color: isUpcoming ? Colors.green : Colors.white,fontFamily: Fonts.outfit,fontSize: Responsive.font(context, 12),fontWeight: FontWeight.w600),)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(double width,IconData icon,String label,String value,Color color,BuildContext context){
    return Row(
      children: [
        Icon(icon,size: Responsive.icon(context, 18),color: color,),
        SizedBox(width: width*0.02,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,style: TextStyle(fontFamily: Fonts.nunito,color: Colors.blueGrey,fontSize: Responsive.font(context, 10)),),
              Text(value,style: TextStyle(fontFamily: Fonts.nunito,color: Colors.black,fontSize: Responsive.font(context, 10)),),
            ],
          ),
        ),
      ],
    );
  }
}
