import 'package:flutter/material.dart';
import 'package:study_mate/Contest/Domain/MyContest.dart';
import 'package:study_mate/fonts.dart';

class ContestHistorySection extends StatelessWidget {
  final List<MyContest> contests;

  const ContestHistorySection({Key? key, required this.contests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (contests.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedContests = List<MyContest>.from(contests)..sort((a, b) => b.startTime.compareTo(a.startTime));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              "Contest History",
              style: TextStyle(
                fontFamily: Fonts.outfit,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedContests.length,
          separatorBuilder: (context, index) => const SizedBox(height: 15),
          itemBuilder: (context, index) {
            final contest = sortedContests[index];
            return _buildContestCard(contest);
          },
        ),
      ],
    );
  }

  Widget _buildContestCard(MyContest contest) {
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
                  fontSize: 10,
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
                  "${isPositive ? '+' : ''}${contest.ratingChnage}",
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 10,
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
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric("RANK", "${contest.rank}/${contest.participants}"),
              _buildMetric("CORRECT", "${contest.correctQuestions}", icon: Icons.check_circle_outline, iconColor: Colors.green),
              _buildMetric("DIFFICULTY", contest.difficulty),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, {IconData? icon, Color? iconColor}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: Fonts.nunito,
            fontSize: 9,
            color: Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: iconColor),
              const SizedBox(width: 4),
            ],
            Text(
              value,
              style: TextStyle(
                fontFamily: Fonts.outfit,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
