import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Settings/Data/SettingsRepo.dart';
import 'package:study_mate/Settings/Presentation/Bloc/SettingsEvent.dart';
import 'package:study_mate/Settings/Presentation/Bloc/SettingsState.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepo settingsRepo;

  SettingsBloc(this.settingsRepo) : super(SettingsInitial()) {
    on<LogoutRequested>((event, emit) async {
      emit(SettingsLoading());
      try {
        final res = await settingsRepo.LogOut();
        if (res.statusCode == 200) {
          emit(SettingsSuccess(message: 'Logged out successfully'));
        } else {
          emit(SettingsFailure(error: 'Failed to log out. Status code: ${res.statusCode}'));
        }
      } catch (e) {
        emit(SettingsFailure(error: e.toString()));
      }
    });

    on<DeleteAccountRequested>((event, emit) async {
      emit(SettingsLoading());
      try {
        final res = await settingsRepo.DeleteAccount();
        if (res.statusCode == 200) {
          emit(SettingsSuccess(message: 'Account deleted successfully'));
        } else {
          emit(SettingsFailure(error: 'Failed to delete account. Status code: ${res.statusCode}'));
        }
      } catch (e) {
        emit(SettingsFailure(error: e.toString()));
      }
    });
  }
}
