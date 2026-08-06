



import 'package:study_mate/Lectures/Presentation/Bloc/PlayerStates.dart';

sealed class PlayerEvent {}

class OpenVideo extends PlayerEvent {
  final String url;

  OpenVideo(this.url);
}

class PlayPressed extends PlayerEvent {}

class PausePressed extends PlayerEvent {}

class ToggleControls extends PlayerEvent {}

class ShowControls extends PlayerEvent {}

class HideControls extends PlayerEvent {}

class SeekTo extends PlayerEvent {
  final Duration position;

  SeekTo(this.position);
}

class ForwardFiveSeconds extends PlayerEvent {}

class BackwardFiveSeconds extends PlayerEvent {}

class ChangePlaybackSpeed extends PlayerEvent {
  final double speed;

  ChangePlaybackSpeed(this.speed);
}

class ChangeQuality extends PlayerEvent {
  final VideoQuality quality;

  ChangeQuality(this.quality);
}

class EnterFullscreen extends PlayerEvent {}

class ExitFullscreen extends PlayerEvent {}