import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/AboutUs/Data/AboutUsRepo.dart';
import 'package:study_mate/AboutUs/Domain/PeopleCard.dart';
import 'package:study_mate/AboutUs/Presentation/Bloc/AboutUsEvents.dart';
import 'package:study_mate/AboutUs/Presentation/Bloc/AboutUsStates.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';

class Aboutusbloc extends Bloc<Aboutusevents,Aboutusstates> {
  final AboutUsRepo repo;
  Aboutusbloc(this.repo) : super(AboutusInitialState()){
    on<AboutusLoadData>(_aboutusLoadData);
  }


  Future<void> _aboutusLoadData(AboutusLoadData event, Emitter<Aboutusstates> emit) async{
   emit(AboutUsLoading());
   ApiResponse res = await repo.fetchPeopleList();
   if(res.statusCode != 200){emit(AboutUsError());return ;}
   List<PersonCard> ps = res.data;
   print("The Id of the firs person is : ${ps[0].id}");
   emit(AboutUsLoaded(people: res.data));
  }
}