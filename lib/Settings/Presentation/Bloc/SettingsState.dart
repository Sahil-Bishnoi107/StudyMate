abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsSuccess extends SettingsState {
  final String message;
  SettingsSuccess({required this.message});
}

class SettingsFailure extends SettingsState {
  final String error;
  SettingsFailure({required this.error});
}
