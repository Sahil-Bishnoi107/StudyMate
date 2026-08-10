import 'package:flutter/material.dart';
import 'package:study_mate/AboutUs/Domain/Person.dart';
import 'package:study_mate/fonts.dart';

class ExperienceSection extends StatelessWidget {
  final Person person;

  const ExperienceSection({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color.fromRGBO(240, 240, 240, 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.work_outline, color: Colors.green, size: Responsive.icon(context, 20)),
              ),
              const SizedBox(width: 12),
              Text(
                "Professional Experience",
                style: TextStyle(
                  fontFamily: Fonts.outfit,
                  fontSize: Responsive.font(context, 18),
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (person.yearsExperience > 0) ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${person.yearsExperience}+",
                        style: TextStyle(
                          fontFamily: Fonts.outfit,
                          fontSize: Responsive.font(context, 24),
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "YEARS EXPERIENCE",
                        style: TextStyle(
                          fontFamily: Fonts.outfit,
                          fontSize: Responsive.font(context, 10),
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
          ...person.experience.map((exp) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Padding(
                    padding: EdgeInsets.only(top: 4, right: 12),
                    child: Icon(Icons.verified_outlined, color: Colors.green, size: Responsive.icon(context, 16)),
                  ),
                  Expanded(
                    child: Text(
                      exp,
                      style: TextStyle(
                        fontFamily: Fonts.nunito,
                        fontSize: Responsive.font(context, 13),
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
