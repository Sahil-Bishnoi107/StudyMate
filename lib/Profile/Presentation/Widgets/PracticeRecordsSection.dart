import 'package:flutter/material.dart';
import 'package:study_mate/Profile/Domain/practiceQuestion.dart';
import 'package:study_mate/fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class PracticeRecordsSection extends StatelessWidget {
  final List<PracticeUserQuestion> questions;

  const PracticeRecordsSection({Key? key, required this.questions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedQuestions = List<PracticeUserQuestion>.from(questions)..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Bootstrap.journal_bookmark_fill, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              "Recent Practice",
              style: TextStyle(
                fontFamily: Fonts.outfit,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.5,
          ),
          itemCount: sortedQuestions.length > 6 ? 6 : sortedQuestions.length, // Show only recent 6
          itemBuilder: (context, index) {
            final q = sortedQuestions[index];
            return _buildQuestionCard(q);
          },
        ),
        if (sortedQuestions.length > 6)
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                "View All Records",
                style: TextStyle(fontFamily: Fonts.nunito, color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuestionCard(PracticeUserQuestion q) {
    final monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    String dateStr = "${q.submittedAt.day} ${monthNames[q.submittedAt.month - 1]}";

    return Container(
      padding: const EdgeInsets.all(12),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                q.isCorrect ? Icons.check_circle : Icons.cancel,
                color: q.isCorrect ? Colors.green : Colors.red,
                size: 16,
              ),
              Text(
                q.difficulty.toUpperCase(),
                style: TextStyle(
                  fontFamily: Fonts.nunito,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: _getDifficultyColor(q.difficulty),
                ),
              ),
            ],
          ),
          Text(
            q.subject.toUpperCase(),
            style: TextStyle(
              fontFamily: Fonts.outfit,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 10, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                dateStr,
                style: TextStyle(
                  fontFamily: Fonts.nunito,
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String diff) {
    if (diff.toLowerCase() == 'hard') return Colors.red;
    if (diff.toLowerCase() == 'medium') return Colors.orange;
    return Colors.green;
  }
}
