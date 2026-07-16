import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:study_mate/Profile/Domain/practiceQuestion.dart';
import 'package:study_mate/fonts.dart';

class QuestionStatsSection extends StatelessWidget {
  final List<PracticeUserQuestion> questions;

  const QuestionStatsSection({Key? key, required this.questions}) : super(key: key);

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.pie_chart, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              "Subject Mastery",
              style: TextStyle(
                fontFamily: Fonts.outfit,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildSubjectDistribution(subjects, subjectColors),
        const SizedBox(height: 30),
        
        Text(
          "Accuracy Progression",
          style: TextStyle(
            fontFamily: Fonts.outfit,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 15),
        _buildAccuracyProgression(subjects, subjectColors),
        const SizedBox(height: 30),
        
        Text(
          "Overall Accuracy",
          style: TextStyle(
            fontFamily: Fonts.outfit,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 15),
        _buildOverallAccuracy(subjects, subjectColors),
      ],
    );
  }

  Widget _buildSubjectDistribution(List<String> subjects, List<Color> colors) {
    Map<String, int> counts = {};
    for (var q in questions) {
      counts[q.subject] = (counts[q.subject] ?? 0) + 1;
    }

    List<PieChartSectionData> sections = [];
    for (int i = 0; i < subjects.length; i++) {
      final subject = subjects[i];
      final count = counts[subject] ?? 0;
      final percentage = (count / questions.length) * 100;
      sections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: count.toDouble(),
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: sections,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 15,
            runSpacing: 10,
            alignment: WrapAlignment.center,
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
          )
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
      if (subjectQuestions.length < 20) {
        totalSections = subjectQuestions.length;
      }

      int questionsPerSection = (subjectQuestions.length / totalSections).ceil();
      List<FlSpot> spots = [];

      for (int sec = 0; sec < totalSections; sec++) {
        int startIdx = sec * questionsPerSection;
        int endIdx = (startIdx + questionsPerSection > subjectQuestions.length) 
                     ? subjectQuestions.length 
                     : startIdx + questionsPerSection;
        
        if (startIdx >= subjectQuestions.length) break;

        var sectionQs = subjectQuestions.sublist(startIdx, endIdx);
        int correctCount = sectionQs.where((q) => q.isCorrect).length;
        double accuracy = (correctCount / sectionQs.length) * 100;

        spots.add(FlSpot(sec.toDouble(), accuracy));
      }

      lines.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: colors[i % colors.length],
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
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
    );
  }

  Widget _buildOverallAccuracy(List<String> subjects, List<Color> colors) {
    List<BarChartGroupData> barGroups = [];
    
    for (int i = 0; i < subjects.length; i++) {
      String subject = subjects[i];
      var subjectQs = questions.where((q) => q.subject == subject).toList();
      if (subjectQs.isEmpty) continue;
      
      int correct = subjectQs.where((q) => q.isCorrect).length;
      double accuracy = (correct / subjectQs.length) * 100;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: accuracy,
              color: colors[i % colors.length],
              width: 20,
              borderRadius: BorderRadius.circular(4),
            )
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            maxY: 100,
            barGroups: barGroups,
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() >= 0 && value.toInt() < subjects.length) {
                      String text = subjects[value.toInt()];
                      if (text.length > 4) text = text.substring(0, 4);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(text, style: TextStyle(fontFamily: Fonts.nunito, fontSize: 10)),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    return Text('${value.toInt()}', style: TextStyle(fontFamily: Fonts.nunito, fontSize: 10, color: Colors.grey));
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 25),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}
