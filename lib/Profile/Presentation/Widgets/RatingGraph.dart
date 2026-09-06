import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:study_mate/Contest/Domain/MyContest.dart';
import 'package:study_mate/fonts.dart';

class RatingGraph extends StatelessWidget {
  final List<MyContest> contests;

  const RatingGraph({super.key, required this.contests});

  @override
  Widget build(BuildContext context) {
    final sortedContests = List<MyContest>.from(contests)..sort((a, b) => a.startTime.compareTo(b.startTime));

    List<FlSpot> spots = [];
    int currentRating = 1500;

    if (sortedContests.isEmpty) {
      // No contest data yet — show a flat line at 1500,
      // anchored with a point on the far left and far right.
      spots.add(const FlSpot(0, 1500));
      spots.add(const FlSpot(1, 1500));
    } else {
      // Initial spot before any contest (if we want to show a starting point)
      spots.add(FlSpot(0, currentRating.toDouble()));

      for (int i = 0; i < sortedContests.length; i++) {
        currentRating += sortedContests[i].ratingChnage;
        spots.add(FlSpot((i + 1).toDouble(), currentRating.toDouble()));
      }
    }

    // Determine min and max Y for the graph
    double minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

    // Add some padding to Y axis
    minY = (minY - 50).floorToDouble();
    maxY = (maxY + 50).ceilToDouble();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: const [
                        TextSpan(
                          text: "Rating ",
                          style: TextStyle(color: Colors.green),
                        ),
                        TextSpan(
                          text: "Progression",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                      style: TextStyle(
                        fontFamily: Fonts.outfit,
                        fontSize: Responsive.font(context, 18),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    "Performance trend over contests",
                    style: TextStyle(
                      fontFamily: Fonts.outfit,
                      fontSize: Responsive.font(context, 10),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Icon(Icons.trending_up, color: Colors.green, size: Responsive.icon(context, 24)),
            ],
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: spots.length.toDouble() - 1,
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.green.withOpacity(0.1),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false,
                    color: Colors.green,
                    barWidth: 1.5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Colors.green,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.green.withOpacity(0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        return LineTooltipItem(
                          '${touchedSpot.y.toInt()}',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}