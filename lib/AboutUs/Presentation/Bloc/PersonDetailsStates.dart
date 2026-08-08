import 'package:study_mate/AboutUs/Domain/Person.dart';

abstract class PersonDetailsStates {}

class PersonDetailsInitialState extends PersonDetailsStates {}

class PersonDetailsLoadingState extends PersonDetailsStates {}

class PersonDetailsLoadedState extends PersonDetailsStates {
  final Person person;
  PersonDetailsLoadedState({required this.person});
}

class PersonDetailsErrorState extends PersonDetailsStates {
  final String message;
  PersonDetailsErrorState({this.message = ""});
}
