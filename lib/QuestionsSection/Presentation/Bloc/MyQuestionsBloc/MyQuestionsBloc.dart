import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Authentication/Domain/Entities/ApiResponse.dart';
import 'package:study_mate/Home/Domain/Entities/Question.dart';
import 'package:study_mate/QuestionsSection/Data/QuestionsRepo.dart';
import 'package:study_mate/QuestionsSection/Domain/Collection.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/MyQuestionsBloc/MyQuestionsEvents.dart';
import 'package:study_mate/QuestionsSection/Presentation/Bloc/MyQuestionsBloc/MyQuestionsStates.dart';

class MyQuestionsBloc extends Bloc<MyQuestionsEvents, MyQuestionsStates> {
  final QuestionsRepo questionsRepo;

  MyQuestionsBloc(this.questionsRepo) : super(MyQuestionsInitialState()) {
    on<LoadMyCollectionsEvent>(_onLoadMyCollections);
    on<CreateNewCollectionEvent>(_onCreateNewCollection);
    on<LoadCollectionQuestionsEvent>(_onLoadCollectionQuestions);
    on<ClearCollectionQuestionsEvent>(_onClearCollectionQuestions);
  }

  void _onLoadMyCollections(LoadMyCollectionsEvent event, Emitter<MyQuestionsStates> emit) async {
    emit(MyQuestionsLoadingState());

    ApiResponse res = await questionsRepo.LoadMyCollections();
    if (res.statusCode != 200) {
      emit(MyQuestionsErrorState("Failed to load collections."));
      return;
    }

    emit(MyQuestionsLoadedState(
      collections: res.data,
      collectionQuestions: [],
    ));
  }

  void _onCreateNewCollection(CreateNewCollectionEvent event, Emitter<MyQuestionsStates> emit) async {
    if (state is MyQuestionsLoadedState) {
      final currentState = state as MyQuestionsLoadedState;

      ApiResponse res = await questionsRepo.CreateCollection(event.collectionName, event.iconIndex);
      if (res.statusCode != 200) {
        emit(MyQuestionsErrorState("Failed to create collection."));
        emit(MyQuestionsLoadedState(
          collections: currentState.collections,
          collectionQuestions: currentState.collectionQuestions,
        ));
        return;
      }

      emit(MyQuestionsActionSuccessState("Collection Created"));

      // Reload collections to get the updated list
      ApiResponse collectionsRes = await questionsRepo.LoadMyCollections();
      if (collectionsRes.statusCode != 200) {
        emit(MyQuestionsErrorState("Failed to reload collections."));
        return;
      }

      emit(MyQuestionsLoadedState(
        collections: collectionsRes.data,
        collectionQuestions: currentState.collectionQuestions,
      ));
    }
  }

  void _onLoadCollectionQuestions(LoadCollectionQuestionsEvent event, Emitter<MyQuestionsStates> emit) async {
    if (state is MyQuestionsLoadedState) {
      final currentState = state as MyQuestionsLoadedState;
      emit(MyQuestionsLoadingState());

      ApiResponse res = await questionsRepo.LoadCollectionQuestions(event.collectionId);
      if (res.statusCode != 200) {
        print(res.error);
        emit(MyQuestionsErrorState(res.error ?? "could not load message for this collection"));
        emit(MyQuestionsLoadedState(
          collections: currentState.collections,
          collectionQuestions: currentState.collectionQuestions,
        ));
        return;
      }

      emit(MyQuestionsLoadedState(
        collections: currentState.collections,
        collectionQuestions: res.data,
      ));
    }
  }

  void _onClearCollectionQuestions(ClearCollectionQuestionsEvent event, Emitter<MyQuestionsStates> emit) {
    if (state is MyQuestionsLoadedState) {
      final currentState = state as MyQuestionsLoadedState;
      emit(MyQuestionsLoadedState(
        collections: currentState.collections,
        collectionQuestions: [],
      ));
    }
  }
}
