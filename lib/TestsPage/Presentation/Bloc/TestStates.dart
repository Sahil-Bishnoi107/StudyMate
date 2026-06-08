import 'package:study_mate/TestsPage/Domain/entities/Test.dart';

final class Teststates {}

final class LoadingTestPageState extends Teststates{}

final class LoadedTestPageState extends Teststates{
  List<TestInfo> tests;
  List<TestInfo> filteredTests;
  List<String> filters = ["All", "Physics", "Chemistry", "Maths", "Biology", "Others"];
  int slectedFilter;
  LoadedTestPageState({required this.tests,required this.filteredTests,required this.slectedFilter});
}

final class FailureTestPageState extends Teststates{
  String error;

  FailureTestPageState({required this.error});
}