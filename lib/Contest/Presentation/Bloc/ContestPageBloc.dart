import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Contest/Data/ContestRepo.dart';
import 'package:study_mate/Contest/Domain/Contest.dart';
import 'package:study_mate/Contest/Domain/Rating.dart';
import 'package:study_mate/Contest/Presentation/Bloc/ContestPageEvents.dart';
import 'package:study_mate/Contest/Presentation/Bloc/ContestPageStates.dart';

class ContestPageBloc extends Bloc<Contestpageevents, ContestPagestates> {
  final ContestRepo contestRepo;
  Timer? _timer;

  ContestPageBloc(this.contestRepo) : super(InitialContestPageState()) {
    on<LoadContestPageData>(_onLoadContestPageData);
    on<ChnageFilter>(_onChangeFilter);
    on<UpdateTimerEvent>(_onUpdateTimer);
    on<SearchContestEvent>(_onSearchContest);
    on<RefreshContestDataEvent>(_onRefreshContestData);

    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      add(UpdateTimerEvent());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> _onLoadContestPageData(LoadContestPageData event, Emitter<ContestPagestates> emit) async {
    emit(LoadingContestListState());
    
    var contestRes = await contestRepo.getContestList();
    var ratingRes = await contestRepo.getMyRating();

    if (contestRes.statusCode == 200 && ratingRes.statusCode == 200) {
      List<Contest> allContests = contestRes.data as List<Contest>;
      Rating rating = ratingRes.data as Rating;

      emit(SuccessContestPageState(
        contests: allContests,
        rating: rating,
        selectedFilter: 0,
        filteredList: _getFilteredList(allContests, 0, "", DateTime.now()),
        time: DateTime.now(),
        searchQuery: "",
      ));
    } else {
      // If fetching fails, we just emit initial state to retry, or we could have a failed state.
      // Assuming a generic error state is not explicitly defined in the states file, 
      // falling back to initial state or we can just stay in loading. Let's stay in initial.
      emit(InitialContestPageState());
    }
  }

  Future<void> _onRefreshContestData(RefreshContestDataEvent event, Emitter<ContestPagestates> emit) async {
    // Save current filter and search
    int currentFilter = 0;
    String currentSearch = "";
    if (state is SuccessContestPageState) {
      currentFilter = (state as SuccessContestPageState).selectedFilter;
      currentSearch = (state as SuccessContestPageState).searchQuery;
    }

    emit(LoadingContestListState());
    
    var contestRes = await contestRepo.getContestList();
    var ratingRes = await contestRepo.getMyRating();

    if (contestRes.statusCode == 200 && ratingRes.statusCode == 200) {
      List<Contest> allContests = contestRes.data as List<Contest>;
      Rating rating = ratingRes.data as Rating;

      emit(SuccessContestPageState(
        contests: allContests,
        rating: rating,
        selectedFilter: currentFilter,
        filteredList: _getFilteredList(allContests, currentFilter, currentSearch, DateTime.now()),
        time: DateTime.now(),
        searchQuery: currentSearch,
      ));
    } else {
      emit(InitialContestPageState());
    }
  }

  void _onChangeFilter(ChnageFilter event, Emitter<ContestPagestates> emit) {
    if (state is SuccessContestPageState) {
      final currentState = state as SuccessContestPageState;
      emit(SuccessContestPageState(
        contests: currentState.contests,
        rating: currentState.rating,
        selectedFilter: event.newFilter,
        filteredList: _getFilteredList(currentState.contests, event.newFilter, currentState.searchQuery, currentState.time),
        time: currentState.time,
        searchQuery: currentState.searchQuery,
      ));
    }
  }

  void _onSearchContest(SearchContestEvent event, Emitter<ContestPagestates> emit) {
    if (state is SuccessContestPageState) {
      final currentState = state as SuccessContestPageState;
      emit(SuccessContestPageState(
        contests: currentState.contests,
        rating: currentState.rating,
        selectedFilter: currentState.selectedFilter,
        filteredList: _getFilteredList(currentState.contests, currentState.selectedFilter, event.query, currentState.time),
        time: currentState.time,
        searchQuery: event.query,
      ));
    }
  }

  void _onUpdateTimer(UpdateTimerEvent event, Emitter<ContestPagestates> emit) {
    if (state is SuccessContestPageState) {
      final currentState = state as SuccessContestPageState;
      DateTime newTime = DateTime.now();
      emit(SuccessContestPageState(
        contests: currentState.contests,
        rating: currentState.rating,
        selectedFilter: currentState.selectedFilter,
        filteredList: _getFilteredList(currentState.contests, currentState.selectedFilter, currentState.searchQuery, newTime),
        time: newTime,
        searchQuery: currentState.searchQuery,
      ));
    }
  }

  List<Contest> _getFilteredList(List<Contest> all, int filterIndex, String query, DateTime currentTime) {
    List<Contest> list = all;
    
    // Search filter
    if (query.trim().isNotEmpty) {
      list = list.where((c) => c.contestName.toLowerCase().contains(query.toLowerCase())).toList();
    }

    // Status filter
    // 0: Current (Ongoing)
    // 1: Upcoming
    // 2: Ended
    list = list.where((c) {
      if (filterIndex == 0) { // Ongoing
        return c.startTime.isBefore(currentTime) && currentTime.isBefore(c.startTime.add(Duration(minutes: c.duration)));
      } else if (filterIndex == 1) { // Upcoming
        return c.startTime.isAfter(currentTime);
      } else if (filterIndex == 2) { // Ended
        return currentTime.isAfter(c.startTime.add(Duration(minutes: c.duration))) || currentTime.isAtSameMomentAs(c.startTime.add(Duration(minutes: c.duration)));
      }
      return true;
    }).toList();

    return list;
  }
}
