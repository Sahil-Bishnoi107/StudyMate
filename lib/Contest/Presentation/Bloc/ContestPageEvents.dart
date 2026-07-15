class Contestpageevents {}

class LoadContestPageData extends Contestpageevents{}

class ChnageFilter extends Contestpageevents{
  int newFilter;
  ChnageFilter({required this.newFilter});
}

class UpdateTimerEvent extends Contestpageevents{}

class SearchContestEvent extends Contestpageevents{
  String query;
  SearchContestEvent({required this.query});
}

class RefreshContestDataEvent extends Contestpageevents{}