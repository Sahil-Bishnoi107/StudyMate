import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Contest/Domain/Contest.dart';
import 'package:study_mate/fonts.dart';

class ContestCard extends StatelessWidget {
  final Contest contest;
  final DateTime currentTime;
  final VoidCallback onJoin;

  const ContestCard({
    super.key,
    required this.contest,
    required this.currentTime,
    required this.onJoin,
  });

  DateTime get _endTime => contest.startTime.add(Duration(minutes: contest.duration));

  String _getTimeLabel() {
    if (currentTime.isBefore(contest.startTime)) return "BEGINS IN";
    if (currentTime.isBefore(_endTime)) return "ENDS IN";
    return "STATUS";
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
    double height = MediaQuery.of(context).size.height;

    bool isEnded = currentTime.isAfter(_endTime);
    bool isUpcoming = currentTime.isBefore(contest.startTime);

    // Same card as the contest history / recent tests cards on the profile page
    return Container(
      width: width * 0.9,
      margin: EdgeInsets.only(bottom: 10, left: width * 0.05, right: width * 0.05),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Responsive.icon(context, 5)),
        border: Border.all(color: const Color.fromRGBO(158, 158, 158, 0.1)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(158, 158, 158, 0.02),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
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
                contest.subject.toUpperCase(),
                style: TextStyle(
                  fontFamily: Fonts.nunito,
                  color: Colors.grey[500],
                  fontSize: Responsive.font(context, 10),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                contest.difficulty.toUpperCase(),
                style: TextStyle(
                  fontFamily: Fonts.nunito,
                  fontSize: Responsive.font(context, 10),
                  fontWeight: FontWeight.bold,
                  color: _getDifficultyColor(contest.difficulty),
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
              fontSize: Responsive.font(context, 16),
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoStat(LucideIcons.timer400Dir, "Duration", "${contest.duration} mins", Colors.orange, context),
              _buildInfoStat(
                LucideIcons.users400Dir,
                "Joined",
                contest.participants > 1000 ? '${(contest.participants / 1000).toStringAsFixed(1)}k' : contest.participants.toString(),
                Colors.blue,
                context,
              ),
              _buildInfoStat(LucideIcons.circleCheck400Dir, "Marks", "+${contest.marksPerQuestion} / -${contest.negativeMarking.abs()}", Colors.green, context),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: const Color.fromRGBO(220, 220, 220, 0.7)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTimeLabel(),
                      style: TextStyle(
                        fontFamily: Fonts.nunito,
                        fontSize: Responsive.font(context, 9),
                        color: Colors.grey[500],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getTimeLeftText(),
                      style: TextStyle(
                        fontFamily: Fonts.outfit,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.font(context, 14),
                        color: isEnded ? Colors.grey[600] : (isUpcoming ? Colors.black : Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
              // Square button, same look as the next / previous buttons on the test page
              if (!isEnded)
                GestureDetector(
                  onTap: onJoin,
                  child: Container(
                    height: height * 0.045,
                    width: width * 0.34,
                    decoration: BoxDecoration(
                      color: isUpcoming ? Colors.white : Colors.green,
                      border: Border.all(color: isUpcoming ? Colors.black : Colors.green),
                    ),
                    child: Center(
                      child: Text(
                        isUpcoming ? "View Details >" : "Join Now >",
                        style: TextStyle(
                          fontFamily: Fonts.nunito,
                          fontWeight: FontWeight.bold,
                          color: isUpcoming ? Colors.black : Colors.white,
                          fontSize: Responsive.font(context, 13),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoStat(IconData icon, String label, String value, Color color, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: Responsive.icon(context, 16), color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: Fonts.nunito,
                fontSize: Responsive.font(context, 10),
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontFamily: Fonts.nunito,
                fontSize: Responsive.font(context, 12),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
