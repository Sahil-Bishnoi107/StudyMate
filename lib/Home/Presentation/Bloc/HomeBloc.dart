import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:study_mate/Home/Data/HomeData.dart';
import 'package:study_mate/Home/Presentation/Bloc/homeEvents.dart';
import 'package:study_mate/Home/Presentation/Bloc/homeStates.dart';

class Homebloc extends Bloc<Homeevents,Homestates> {
   final Homedata homeData;

   Homebloc(this.homeData) : super(HomeInitial());
}