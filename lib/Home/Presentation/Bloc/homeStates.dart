import 'package:study_mate/Home/Domain/Entities/student.dart';

sealed class Homestates {}

class HomeInitial extends Homestates {}

class HomeDataRecieved extends Homestates {
  Student student;
  HomeDataRecieved({required this.student});
}

class HomeDataFailure extends Homestates {}

