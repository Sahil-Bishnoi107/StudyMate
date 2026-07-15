import 'package:study_mate/Contest/Domain/Contest.dart';
import 'package:study_mate/Contest/Domain/Rating.dart';

class ContestPagestates {}

class InitialContestPageState extends ContestPagestates{}

class LoadingContestListState extends ContestPagestates{}

class SuccessContestPageState extends ContestPagestates{
  final List<Contest> contests;
  final Rating rating;
  DateTime time;
  final List<Contest> filteredList;
  int selectedFilter;
  String searchQuery;

  SuccessContestPageState({required this.contests,required this.rating,required this.selectedFilter,required this.filteredList,required this.time, this.searchQuery = ""});
}