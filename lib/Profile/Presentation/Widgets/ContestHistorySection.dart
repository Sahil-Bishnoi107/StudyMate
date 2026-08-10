import 'package:flutter/material.dart';
import 'package:study_mate/Contest/Domain/MyContest.dart';
import 'package:study_mate/fonts.dart';

class ContestHistorySection extends StatelessWidget {
  final List<MyContest> contests;
  final double width;

  const ContestHistorySection({super.key, required this.contests,required this.width});

  @override
  Widget build(BuildContext context) {
    if (contests.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedContests = List<MyContest>.from(contests)..sort((a, b) => b.startTime.compareTo(a.startTime));

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: width*0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                "Contest",
                style: TextStyle(
                  fontFamily: Fonts.outfit,
                  fontWeight: FontWeight.w700,
                  fontSize: Responsive.font(context, 18),
                  color: Colors.black
                ),
              ),
              Text(
                " History",
                style: TextStyle(
                  fontFamily: Fonts.outfit,
                  fontWeight: FontWeight.w700,
                  fontSize: Responsive.font(context, 18),
                  color: Colors.green
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          ListView.separated(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedContests.length,
            separatorBuilder: (context, index) => const SizedBox(height: 5),
            itemBuilder: (context, index) {
              final contest = sortedContests[index];
             if(contest.rank > 0) {return  _buildContestCard(contest,context);}
             else{return SizedBox.shrink();}
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContestCard(MyContest contest,BuildContext context) {
    bool isPositive = contest.ratingChnage >= 0;
    
    // Format date e.g. "22 OCT"
    final monthNames = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
    String dateStr = "${contest.startTime.day} ${monthNames[contest.startTime.month - 1]}";

    // Score / total questions assuming duration or marks gives context, but let's just show correctQuestions
    // We don't have total questions explicitly in MyContest, maybe use total marks / marksPerQuestion?
    // Let's just use correctQuestions and rank for now, along with accuracy.

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.02),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateStr,
                style: TextStyle(
                  fontFamily: Fonts.nunito,
                  color: Colors.grey[500],
                  fontSize: Responsive.font(context, 10),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "${isPositive ? '+' : '-'}${contest.ratingChnage}",
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: Responsive.font(context, 10),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            contest.contestName,
            style: TextStyle(
              fontFamily: Fonts.outfit,
              fontWeight: FontWeight.w600,
              fontSize: Responsive.font(context, 14),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric("RANK", "${contest.rank}/${contest.participants}",context),
              _buildMetric("CORRECT", "${contest.correctQuestions}",context, icon: Icons.check_circle_outline, iconColor: Colors.green),
              _buildMetric("DIFFICULTY", contest.difficulty,context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value,BuildContext context, {IconData? icon, Color? iconColor}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: Fonts.nunito,
            fontSize: Responsive.font(context, 9),
            color: Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: Responsive.icon(context, 12), color: iconColor),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: TextStyle(
                fontFamily: Fonts.outfit,
                fontWeight: FontWeight.bold,
                fontSize: Responsive.font(context, 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
