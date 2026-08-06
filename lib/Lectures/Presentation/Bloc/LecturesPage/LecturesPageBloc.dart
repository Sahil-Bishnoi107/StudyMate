import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Lectures/Data/VideoRepo.dart';
import 'package:study_mate/Lectures/Domain/VideoModel.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/LecturesPage/LecturesPageEvents.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/LecturesPage/LecturesPageStates.dart';

class LecturesPageBloc extends Bloc<LecturesPageEvents, LecturesPageStates> {
  final VideoRepo videoRepo;

  LecturesPageBloc(this.videoRepo) : super(InitialLecturesState()) {
    on<LoadLecturesData>(_onLoadLecturesData);
  }

  Future<void> _onLoadLecturesData(LoadLecturesData event, Emitter<LecturesPageStates> emit) async {
    emit(LoadingLecturesState());
    
    var response = await videoRepo.getVideosList();

    if (response.statusCode == 200) {
      List<VideoModel> videos = response.data as List<VideoModel>;
      emit(SuccessLecturesState(videos: videos));
    } else {
      emit(ErrorLecturesState(message: response.error ?? "Failed to load videos."));
    }
  }
}
