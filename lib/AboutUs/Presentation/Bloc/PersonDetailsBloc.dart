import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/AboutUs/Data/AboutUsRepo.dart';
import 'package:study_mate/AboutUs/Domain/Person.dart';
import 'package:study_mate/AboutUs/Presentation/Bloc/PersonDetailsEvents.dart';
import 'package:study_mate/AboutUs/Presentation/Bloc/PersonDetailsStates.dart';

class PersonDetailsBloc extends Bloc<PersonDetailsEvents, PersonDetailsStates> {
  final AboutUsRepo repo;

  PersonDetailsBloc({required this.repo}) : super(PersonDetailsInitialState()) {
    on<LoadPersonDetailsEvent>(_onLoadPersonDetails);
  }

  Future<void> _onLoadPersonDetails(LoadPersonDetailsEvent event, Emitter<PersonDetailsStates> emit) async {
    emit(PersonDetailsLoadingState());
    final response = await repo.fetchPersonDetails(event.personId);
    
    if (response.statusCode == 200 && response.data is Person) {
      emit(PersonDetailsLoadedState(person: response.data));
    } else {
      emit(PersonDetailsErrorState(message: "Failed to load person details."));
    }
  }
}
