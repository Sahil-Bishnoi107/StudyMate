class GenQuestion {
  final String id;
  final String description;
  final List<String> options;
  final String correctOption;
  final String? selectedOption;
  final String subject;
  final String difficulty;

  GenQuestion({
    required this.id,
    required this.description,
    required this.options,
    required this.correctOption,
    this.selectedOption,
    required this.subject,
    required this.difficulty,
  });

  factory GenQuestion.fromJson(Map<String, dynamic> mp) {
    final List<String> options = [];
    if (mp.containsKey('options')) {
      for (final x in mp['options']) {
        options.add(x.toString());
      }
    }
    return GenQuestion(
      id: mp['id']?.toString() ?? 'id_not_found',
      description: mp['description']?.toString() ?? 'Question not found',
      options: options,
      correctOption: mp['correct_option']?.toString() ?? '',
      selectedOption: mp['selected_option']?.toString(),
      subject: mp['subject']?.toString() ?? 'Unknown',
      difficulty: mp['difficulty']?.toString() ?? 'unknown',
    );
  }
}
