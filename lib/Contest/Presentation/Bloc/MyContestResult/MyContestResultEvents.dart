class MyContestResultEvents {}

class LoadContestResultEvent extends MyContestResultEvents {
  final String contestId;
  LoadContestResultEvent({required this.contestId});
}