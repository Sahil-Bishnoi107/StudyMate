import 'package:study_mate/AboutUs/Domain/PeopleCard.dart';

class Aboutusstates {}

class AboutusInitialState extends Aboutusstates{}

class AboutUsLoading extends Aboutusstates{}

class AboutUsLoaded extends Aboutusstates{

  final List<PersonCard> people;

  AboutUsLoaded({required this.people});
}

class AboutUsError extends Aboutusstates{}