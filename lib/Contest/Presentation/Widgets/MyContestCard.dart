import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Contest/Domain/MyContest.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:study_mate/fonts.dart';

class MyContestCard extends StatelessWidget {
  final MyContest contest;
  final VoidCallback? onViewResult;

  const MyContestCard({
    super.key,
    required this.contest,
    this.onViewResult,
  });

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
    bool isCompleted = contest.status == 2;

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
          // Header: Name and difficulty
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            contest.contestName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: Fonts.outfit,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 5),
                        Icon(Bootstrap.check_circle, color: Colors.green, size: 14),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(LucideIcons.calendar, size: 15, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(
                          "${contest.startTime.day} ${_getMonth(contest.startTime.month)}, ${contest.startTime.year}",
                          style: TextStyle(color: Colors.grey[600], fontSize: 11, fontFamily: Fonts.nunito),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(contest.difficulty).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: _getDifficultyColor(contest.difficulty).withOpacity(0.3),)
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
          SizedBox(height: 15),

          // Pills: Subject, Questions, Participants
          Row(
            children: [
              Expanded(child: _buildPill(LucideIcons.book, contest.subject, Colors.green)),
              SizedBox(width: 10),
              Expanded(child: _buildPill(Bootstrap.stopwatch, "${contest.duration} mins", Colors.green)), // UI says Qs but duration might be mapped or questions
              SizedBox(width: 10),
              Expanded(child: _buildPill(Bootstrap.people, "${contest.participants}", Colors.green)),
            ],
          ),
          SizedBox(height: 15),

          // Stats box: Rank, Rating
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.03),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.withOpacity(0.3))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("MY RANK", style: TextStyle(color: Colors.grey[600], fontSize: 9, fontWeight: FontWeight.bold, fontFamily: Fonts.nunito)),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Bootstrap.trophy, color: Colors.orange, size: 14),
                        SizedBox(width: 5),
                        Text(
                       contest.rank > 0 ?   "#${contest.rank}" : " -",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: Fonts.inter),
                        )
                      ],
                    )
                  ],
                ),
                Container(width: 1, height: 30, color: Colors.grey.withOpacity(0.3)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("RATING", style: TextStyle(color: Colors.grey[600], fontSize: 9, fontWeight: FontWeight.bold, fontFamily: Fonts.nunito)),
                    SizedBox(height: 5),
                    contest.rank > 0 ? 
                     Row(
                      children: [
                        Icon(
                          contest.ratingChnage >= 0 ? LucideIcons.trendingUp: LucideIcons.trendingDown, 
                          color: contest.ratingChnage >= 0 ? Colors.green : Colors.red, 
                          size: 14
                        ),
                        SizedBox(width: 5),
                        Text(
                          "${contest.ratingChnage >= 0 ? '+' : '-'}${contest.ratingChnage}",
                          style: TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.w600, 
                            color: contest.ratingChnage >= 0 ? Colors.green : Colors.red,
                            fontFamily: Fonts.outfit
                          ),
                        )
                      ],
                    ) :  Text("    -",style: TextStyle(fontFamily: Fonts.outfit, fontWeight: FontWeight.w600),)
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 15),

          // Correct / Accuracy / Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Correct", style: TextStyle(color: Colors.grey[600], fontSize: 10, fontFamily: Fonts.nunito)),
                      Text(contest.rank > 0 ? "${contest.correctQuestions}/${contest.totalQuestions}" : "     -", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: Fonts.inter)), // placeholder for total qs
                    ],
                  ),
                  SizedBox(width: width*0.25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Accuracy", style: TextStyle(color: Colors.grey[600], fontSize: 10, fontFamily: Fonts.nunito)),
                      Text(
                        contest.rank > 0 ?
                        (contest.totalQuestions != 0 ? "${(contest.correctQuestions*100/contest.totalQuestions).toInt().toString()}%" : "0%")
                        : "      -"
                        ,  
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: Fonts.inter)), 
                    ],
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: isCompleted ? Colors.green.withOpacity(0.5) : Colors.orange.withOpacity(0.5))
                ),
                child: Text(
                  isCompleted ? "COMPLETED" : "EVALUATING",
                  style: TextStyle(
                    color: isCompleted ? Colors.green : Colors.orange,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    fontFamily: Fonts.inter,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),

          // Action Button
          GestureDetector(
            onTap: isCompleted ? onViewResult : null,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.grey[300],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isCompleted ? "View Detailed Result" : "Result Evaluation In Progress",
                    style: TextStyle(
                      color: isCompleted ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      fontFamily: Fonts.nunito,
                    ),
                  ),
                  if (isCompleted) ...[
                    SizedBox(width: 5),
                    Icon(Bootstrap.arrow_right, color: Colors.white, size: 16),
                  ]
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPill(IconData icon, String text,  Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
       
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 11, fontFamily: Fonts.outfit),
          )
        ],
      ),
    );
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}
