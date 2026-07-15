import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/Contest/Domain/Contest.dart';
import 'package:study_mate/fonts.dart';

class ContestCard extends StatelessWidget {
  final Contest contest;
  final DateTime currentTime;
  final VoidCallback onJoin;

  const ContestCard({
    Key? key,
    required this.contest,
    required this.currentTime,
    required this.onJoin,
  }) : super(key: key);

  String _getTimeLeftText() {
    // 0: Current, 1: Upcoming, 2: Ended
    if (currentTime.isBefore(contest.startTime)) {
      Duration diff = contest.startTime.difference(currentTime);
      if (diff.inDays > 0) return "BEGINS IN\n${diff.inDays}d : ${diff.inHours % 24}h";
      return "BEGINS IN\n${diff.inHours}h : ${diff.inMinutes % 60}m";
    } else if (currentTime.isBefore(contest.startTime.add(Duration(minutes: contest.duration)))) {
      Duration diff = contest.startTime.add(Duration(minutes: contest.duration)).difference(currentTime);
      return "ENDS IN\n${diff.inHours}h : ${diff.inMinutes % 60}m";
    } else {
      return "ENDED";
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    bool isEnded = currentTime.isAfter(contest.startTime.add(Duration(minutes: contest.duration)));
    bool isUpcoming = currentTime.isBefore(contest.startTime);

    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      contest.subject,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: Fonts.nunito,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(contest.difficulty).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      contest.difficulty.toUpperCase(),
                      style: TextStyle(
                        color: _getDifficultyColor(contest.difficulty),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: Fonts.nunito,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                _getTimeLeftText(),
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: isEnded ? Colors.grey : Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: Fonts.nunito,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            contest.contestName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: Fonts.inter,
            ),
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Bootstrap.question_circle, size: 14, color: Colors.grey),
                    SizedBox(width: 5),
                    Text(
                      "${contest.marksPerQuestion * 10} Questions", // placeholder if we don't know total questions
                      style: TextStyle(color: Colors.grey[700], fontSize: 12, fontFamily: Fonts.nunito),
                    ),
                  ],
                ),
                Container(width: 1, height: 15, color: Colors.grey.withOpacity(0.3)),
                Row(
                  children: [
                    Icon(Bootstrap.people, size: 14, color: Colors.grey),
                    SizedBox(width: 5),
                    Text(
                      "${contest.participants > 1000 ? '${(contest.participants/1000).toStringAsFixed(1)}k' : contest.participants} Joined",
                      style: TextStyle(color: Colors.grey[700], fontSize: 12, fontFamily: Fonts.nunito),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Bootstrap.stopwatch, size: 14, color: Colors.grey),
                  SizedBox(width: 5),
                  Text(
                    "Duration: ${contest.duration} mins",
                    style: TextStyle(color: Colors.grey[700], fontSize: 12, fontFamily: Fonts.nunito),
                  ),
                ],
              ),
              if (!isEnded)
                GestureDetector(
                  onTap: onJoin,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isUpcoming ? Colors.orange : Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          isUpcoming ? "View Details" : "Join Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            fontFamily: Fonts.nunito,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(Bootstrap.chevron_right, size: 12, color: Colors.white),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
