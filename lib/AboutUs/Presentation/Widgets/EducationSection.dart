import 'package:flutter/material.dart';
import 'package:study_mate/AboutUs/Domain/Person.dart';
import 'package:study_mate/fonts.dart';
import 'dart:math';

class EducationSection extends StatelessWidget {
  final Person person;

  const EducationSection({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int count = max(person.education.length, person.institute.length);
    
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
                child: const Icon(Icons.school, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                "Academic Qualifications",
                style: TextStyle(
                  fontFamily: Fonts.outfit,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(count, (index) {
            String edu = index < person.education.length ? person.education[index] : "";
            String inst = index < person.institute.length ? person.institute[index] : "";
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Center(
                      child: Text(
                        _getAcronym(edu),
                        style: TextStyle(
                          fontFamily: Fonts.outfit,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (edu.isNotEmpty)
                          Text(
                            edu,
                            style: TextStyle(
                              fontFamily: Fonts.outfit,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        if (inst.isNotEmpty)
                          Text(
                            inst,
                            style: TextStyle(
                              fontFamily: Fonts.nunito,
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _getAcronym(String text) {
    if (text.isEmpty) return "";
    List<String> parts = text.split(RegExp(r'[\s.]+'));
    String result = "";
    for (String part in parts) {
      if (part.isNotEmpty && part[0] == part[0].toUpperCase()) {
        result += part[0];
        if (result.length >= 3) break;
      }
    }
    return result.isEmpty ? text.substring(0, min(3, text.length)).toUpperCase() : result;
  }
}
