import 'package:flutter/material.dart';
import 'package:study_mate/Contest/Domain/MyContest.dart';
import 'package:study_mate/Profile/Domain/student.dart';
import 'package:study_mate/fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class RatingSection extends StatelessWidget {
  final Student student;
  final List<MyContest> contests;

  const RatingSection({Key? key, required this.student, required this.contests}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort contests by start time ascending to calculate rating progression
    final sortedContests = List<MyContest>.from(contests)..sort((a, b) => a.startTime.compareTo(b.startTime));
    
    int currentRating = 1500;
    for (var c in sortedContests) {
      currentRating += c.ratingChnage;
    }

    int previousRating = 1500;
    int contestsCount = sortedContests.length;
    
    if (contestsCount > 0) {
      int prevIndex = contestsCount > 5 ? contestsCount - 5 : 0;
      previousRating = 1500;
      for (int i = 0; i < prevIndex; i++) {
        previousRating += sortedContests[i].ratingChnage;
      }
    }

    int ratingGain = currentRating - previousRating;
    bool isPositive = ratingGain >= 0;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CURRENT RATING",
                        style: TextStyle(
                          fontFamily: Fonts.nunito,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500],
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            currentRating.toString(),
                            style: TextStyle(
                              fontFamily: Fonts.outfit,
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: isPositive ? Colors.green[700] : Colors.red[700],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isPositive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isPositive ? Bootstrap.graph_up_arrow : Bootstrap.graph_down_arrow,
                                  color: isPositive ? Colors.green : Colors.red,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${isPositive ? '+' : ''}$ratingGain",
                                  style: TextStyle(
                                    fontFamily: Fonts.nunito,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isPositive ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Previous rating (5 contests ago): $previousRating",
                        style: TextStyle(
                          fontFamily: Fonts.nunito,
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isPositive ? Colors.green.withOpacity(0.05) : Colors.red.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPositive ? Bootstrap.trophy_fill : Bootstrap.award_fill,
                      color: isPositive ? Colors.green : Colors.red,
                      size: 32,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Divider(color: Colors.grey.withOpacity(0.2)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem("GLOBAL RANK", "#${student.rank}", Bootstrap.globe),
                  Container(height: 40, width: 1, color: Colors.grey.withOpacity(0.2)),
                  _buildStatItem("TESTS GIVEN", "${student.testsGiven.length}", Bootstrap.journal_check),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: Fonts.nunito,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
                letterSpacing: 1.1,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontFamily: Fonts.outfit,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
