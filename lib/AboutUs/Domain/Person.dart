import 'package:study_mate/AboutUs/Domain/PeopleCard.dart';

class Person {
  final String id;
  final String name;
  final String description;
  final PeopleRole role;
  final List<String> education;
  final List<String> institute;
  final List<String> experience;
  final int yearsExperience;
  final String email;
  final String mobileNumber;
  final String roleTitle;
  final String photoUrl;

  const Person({
    required this.id,
    required this.name,
    required this.description,
    required this.role,
    required this.education,
    required this.institute,
    required this.experience,
    required this.yearsExperience,
    required this.email,
    required this.mobileNumber,
    required this.roleTitle,
    required this.photoUrl,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      role: _parsePeopleRole(json['role']),
      education: List<String>.from(json['education'] ?? const []),
      institute: List<String>.from(json['institute'] ?? const []),
      experience: List<String>.from(json['experience'] ?? const []),
      yearsExperience: json['yearsExperience'] ?? 0,
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      roleTitle: json['roleTitle'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
    );
  }

  static PeopleRole _parsePeopleRole(dynamic value) {
    if (value is int) {
      switch (value) {
        case 0:
          return PeopleRole.teacher;
        case 1:
          return PeopleRole.developer;
        case 2:
          return PeopleRole.management;
        default:
          return PeopleRole.unknown;
      }
    }

    if (value is String) {
      switch (value.toLowerCase()) {
        case 'teacher':
          return PeopleRole.teacher;
        case 'developer':
          return PeopleRole.developer;
        case 'management':
          return PeopleRole.management;
        default:
          return PeopleRole.unknown;
      }
    }

    return PeopleRole.unknown;
  }
}