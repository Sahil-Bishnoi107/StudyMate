import 'package:flutter/material.dart';
import 'package:study_mate/Profile/Domain/Test.dart';
import 'package:study_mate/fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class RecentTestsSection extends StatefulWidget {
  final List<TestGiven> tests;
  final double width;
  
  RecentTestsSection({Key? key, required this.tests, required this.width}) : super(key: key);

  @override 
  State<RecentTestsSection> createState() => _RecentTestsSectionState();
}

 class _RecentTestsSectionState extends State<RecentTestsSection> {
  bool isOpen = false;
  void openList(){
    isOpen = !isOpen;
  }
  

  @override
  Widget build(BuildContext context) {
    final tests = widget.tests;
    if (tests.isEmpty) {
      return const SizedBox.shrink();
    }

    final sortedTests = tests;

    return Padding(
      
      padding:  EdgeInsets.symmetric(horizontal: widget.width*0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.fileCheck, size: 20,),
              const SizedBox(width: 8),
              Text(
                "Recent ",
                style: TextStyle(
                  fontFamily: Fonts.outfit,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green
                ),
              ),
              Text(
                "Tests",
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
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: (sortedTests.length > 5) && !isOpen ? 5 : sortedTests.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final t = sortedTests[index];
              return _buildTestCard(t);
            },
          ),
          
            Center(
              child: TextButton(
                onPressed: () {setState(() {
                  openList();
                });},
                child: Text(
                 isOpen ? "View Less Tests" :  "View All Tests",
                  style: TextStyle(fontFamily: Fonts.nunito, color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTestCard(TestGiven test) {
    double accuracy = test.totalQuestions == 0 ? 0 : (test.correctQuestions / test.totalQuestions) * 100;
    String difficulty = test.questions.isNotEmpty ? test.questions.first.difficulty : 'Medium';
    
    int minutes = test.time ~/ 60;
    int seconds = test.time % 60;
    String timeStr = "${minutes}m ${seconds}s";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
                test.name.isNotEmpty ? '${test.name[0].toUpperCase()}${test.name.substring(1)}' : test.name,
                style: TextStyle(
                  fontFamily: Fonts.outfit,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(difficulty).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  difficulty.toUpperCase(),
                  style: TextStyle(
                    fontFamily: Fonts.nunito,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _getDifficultyColor(difficulty),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoStat(Icons.check_circle_outline, "Correct", "${test.correctQuestions}/${test.totalQuestions}", Colors.green),
              _buildInfoStat(Icons.percent, "Accuracy", "${accuracy.toStringAsFixed(1)}%", Colors.blue),
              _buildInfoStat(Icons.timer_outlined, "Time", timeStr, Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoStat(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: Fonts.nunito,
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontFamily: Fonts.nunito,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getDifficultyColor(String diff) {
    if (diff.toLowerCase() == 'hard') return Colors.red;
    if (diff.toLowerCase() == 'medium') return Colors.orange;
    return Colors.green;
  }
}
