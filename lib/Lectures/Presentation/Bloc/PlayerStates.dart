import 'package:equatable/equatable.dart';

enum VideoQuality {
  auto,
  p360,
  p480,
  p720,
  p1080,
}

class PlayerBlocState extends Equatable {
  final bool controlsVisible;
  final bool fullscreen;
  final double playbackSpeed;
  final VideoQuality quality;
  final String? currentVideo;
  final bool showConnectionPrompt;
  final bool connectionPromptShown;

  const PlayerBlocState({
    this.controlsVisible = true,
    this.fullscreen = false,
    this.playbackSpeed = 1.0,
    this.quality = VideoQuality.p1080,
    this.currentVideo,
    this.showConnectionPrompt = false,
    this.connectionPromptShown = false,
  });

  PlayerBlocState copyWith({
    bool? controlsVisible,
    bool? fullscreen,
    double? playbackSpeed,
    VideoQuality? quality,
    String? currentVideo,
    bool? showConnectionPrompt,
    bool? connectionPromptShown,
  }) {
    return PlayerBlocState(
      controlsVisible: controlsVisible ?? this.controlsVisible,
      fullscreen: fullscreen ?? this.fullscreen,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      quality: quality ?? this.quality,
      currentVideo: currentVideo ?? this.currentVideo,
      showConnectionPrompt: showConnectionPrompt ?? this.showConnectionPrompt,
      connectionPromptShown: connectionPromptShown ?? this.connectionPromptShown,
    );
  }

  @override
  List<Object?> get props => [
        controlsVisible,
        fullscreen,
        playbackSpeed,
        quality,
        currentVideo,
        showConnectionPrompt,
        connectionPromptShown,
      ];
}