

abstract class PersonDetailsEvents {}

class LoadPersonDetailsEvent extends PersonDetailsEvents {
  final String personId;
  LoadPersonDetailsEvent({required this.personId});
}

