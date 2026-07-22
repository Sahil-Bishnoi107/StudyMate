import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:study_mate/Profile/Domain/practiceQuestion.dart';
import 'package:study_mate/fonts.dart';

class QuestionStatsSection extends StatelessWidget {
  final List<PracticeUserQuestion> questions;

  const QuestionStatsSection({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const SizedBox.shrink();
    }

    final subjects = questions.map((q) => q.subject).toSet().toList();
    final subjectColors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];

    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 5,),
              Icon(LucideIcons.activity,size: 20,),
              const SizedBox(width: 5),
              Text(
                "Accuracy ",
                style: TextStyle(
                  fontFamily: Fonts.outfit,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Colors.green
                ),
              ),
              Text(
            " Progression",
            style: TextStyle(
              fontFamily: Fonts.outfit,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
            ],
          ),
          
          const SizedBox(height: 15),
          _buildAccuracyProgression(subjects, subjectColors),
          const SizedBox(height: 30),
          
          Row(
            children: [
              const SizedBox(width: 5,),
              Icon(LucideIcons.crosshair400Dir,size: 20,),
              const SizedBox(width: 5,),
              Text(
                "Subject",
                style: TextStyle(
                  fontFamily: Fonts.outfit,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                " Accuracy",
                style: TextStyle(
                  fontFamily: Fonts.outfit,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildSubjectList(subjects, subjectColors),
        ],
      ),
    );
  }

  Widget _buildAccuracyProgression(List<String> subjects, List<Color> colors) {
    List<LineChartBarData> lines = [];

    for (int i = 0; i < subjects.length; i++) {
      String subject = subjects[i];
      var subjectQuestions = questions.where((q) => q.subject == subject).toList();
      subjectQuestions.sort((a, b) => a.submittedAt.compareTo(b.submittedAt));

      if (subjectQuestions.isEmpty) continue;

      int totalSections = 20;
      List<FlSpot> spots = [];
      int n = subjectQuestions.length;

      for (int sec = 0; sec < totalSections; sec++) {
        int startIdx = (sec * n / totalSections).floor();
        int endIdx = ((sec + 1) * n / totalSections).floor();
        
        var sectionQs = subjectQuestions.sublist(startIdx, endIdx);
        double accuracy = 0.0;
        if (sectionQs.isNotEmpty) {
          int correctCount = sectionQs.where((q) => q.isCorrect).length;
          accuracy = (correctCount / sectionQs.length) * 100;
        }

        spots.add(FlSpot(sec.toDouble(), accuracy));
      }

      lines.add(
        LineChartBarData(
          spots: spots,
          isCurved: false,
          color: colors[i % colors.length],
          barWidth: 1.5,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
          showingIndicators: [19], // Show indicator at the last point
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                minX: 0,
                maxX: 19,
                lineTouchData: LineTouchData(
                  enabled: true,
                  getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(
                        FlLine(color: Colors.transparent),
                        FlDotData(show: false),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                    fitInsideHorizontally: false,
                    fitInsideVertically: false,
                    getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                      return lineBarsSpot.map((lineBarSpot) {
                        String subject = subjects[lineBarSpot.barIndex];
                        return LineTooltipItem(
                          subject,
                          TextStyle(
                            color: colors[lineBarSpot.barIndex % colors.length],
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: TextStyle(fontFamily: Fonts.nunito, fontSize: 10, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: lines,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 15,
          runSpacing: 10,
          children: subjects.asMap().entries.map((entry) {
            int idx = entry.key;
            String subject = entry.value;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: colors[idx % colors.length],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  subject,
                  style: TextStyle(fontFamily: Fonts.nunito, fontSize: 12),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSubjectList(List<String> subjects, List<Color> colors) {
    return Column(
      children: subjects.asMap().entries.map((entry) {
        int idx = entry.key;
        String subject = entry.value;
        Color color = colors[idx % colors.length];

        var subjectQs = questions.where((q) => q.subject == subject).toList();
        int totalSolved = subjectQs.length;
        int correctCount = subjectQs.where((q) => q.isCorrect).length;
        double accuracy = totalSolved == 0 ? 0 : (correctCount / totalSolved);
        double accuracyPercent = accuracy * 100;

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    subject.isNotEmpty ? '${subject[0].toUpperCase()}${subject.substring(1)}' : subject,
                    style: TextStyle(
                      fontFamily: Fonts.outfit,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${accuracyPercent.toStringAsFixed(1)}%",
                        style: TextStyle(
                          fontFamily: Fonts.nunito,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: color,
                        ),
                      ),
                      Text(
                        "$correctCount/$totalSolved",
                        style: TextStyle(
                          fontFamily: Fonts.nunito,
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "$totalSolved Problems Solved",
                style: TextStyle(
                  fontFamily: Fonts.nunito,
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: accuracy,
                  backgroundColor: color.withOpacity(0.1),
                  color: color,
                  minHeight: 4,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
