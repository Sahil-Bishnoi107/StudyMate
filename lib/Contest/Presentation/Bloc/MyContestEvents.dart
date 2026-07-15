abstract class MyContestEvents {}

class LoadMyContestsEvent extends MyContestEvents {}

class LoadContestResultEvent extends MyContestEvents {
  final String contestId;
  LoadContestResultEvent({required this.contestId});
}
