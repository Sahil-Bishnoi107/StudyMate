

enum PeopleRole {
  teacher,
  developer,
  management,
  unknown,
}

class PersonCard {
  final String id;
  final String name;
  final String roleTitle;
  final PeopleRole peopleRole;
  final String photoUrl;

  const PersonCard({
    required this.id,
    required this.name,
    required this.roleTitle,
    required this.peopleRole,
    required this.photoUrl,
  });

  factory PersonCard.fromJson(Map<String, dynamic> json) {
    return PersonCard(
      id: json['person_id'] ?? '',
      name: json['name'] ?? '',
      roleTitle: json['roleTitle'] ?? '',
      peopleRole: _parsePeopleRole(json['role']),
      photoUrl: json['picUrl'] ?? '',
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
        case 'student':
          return PeopleRole.developer;
        case 'admin':
          return PeopleRole.management;
        default:
          return PeopleRole.unknown;
      }
    }

    return PeopleRole.unknown;
  }
}