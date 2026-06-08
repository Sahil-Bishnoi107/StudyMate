import 'package:study_mate/TestsPage/Domain/entities/Test.dart';

final class TestPagestates {}

final class LoadingTestPageState extends TestPagestates{}

final class LoadedTestPageState extends TestPagestates{
  List<TestInfo> tests;
  List<TestInfo> filteredTests;
  List<String> filters = ["All", "Physics", "Chemistry", "Maths", "Biology", "Others"];
  int slectedFilter;
  LoadedTestPageState({required this.tests,required this.filteredTests,required this.slectedFilter});
}

final class FailureTestPageState extends TestPagestates{
  String error;

  FailureTestPageState({required this.error});
}