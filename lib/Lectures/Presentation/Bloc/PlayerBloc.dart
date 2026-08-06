import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerEvents.dart';
import 'package:study_mate/Lectures/Presentation/Bloc/PlayerStates.dart';

import '../../Services/MediaKitService.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerBlocState> {
  final MediaKitService mediaKit;
  StreamSubscription<bool>? _bufferingSubscription;
  Timer? _bufferingTimer;

  PlayerBloc(this.mediaKit) : super(const PlayerBlocState()) {
    on<OpenVideo>(_openVideo);
    on<PlayPressed>(_play);
    on<PausePressed>(_pause);
    on<ToggleControls>(_toggleControls);
    on<ShowControls>(_showControls);
    on<HideControls>(_hideControls);
    on<SeekTo>(_seek);
    on<ForwardFiveSeconds>(_forward);
    on<BackwardFiveSeconds>(_backward);
    on<ChangePlaybackSpeed>(_speed);
    on<ChangeQuality>(_quality);
    on<EnterFullscreen>(_enterFullscreen);
    on<ExitFullscreen>(_exitFullscreen);
    on<BufferingStateChanged>(_onBufferingChanged);
    on<ShowConnectionPrompt>(_showConnectionPrompt);
    on<AcceptConnectionPrompt>(_acceptConnectionPrompt);
    on<DismissConnectionPrompt>(_dismissConnectionPrompt);

    _bufferingSubscription = mediaKit.player.stream.buffering.listen((isBuffering) {
      add(BufferingStateChanged(isBuffering));
    });
  }

  Future<void> _openVideo(
    OpenVideo event,
    Emitter<PlayerBlocState> emit,
  ) async {
    final uri = Uri.parse(event.url);
    final segments = List<String>.from(uri.pathSegments);
    if (segments.isNotEmpty) {
      segments.removeLast();
    }
    segments.addAll(["1080", "index.m3u8"]);
    final targetUrl = uri.replace(pathSegments: segments).toString();

    await mediaKit.open(targetUrl);

    emit(
      state.copyWith(
        currentVideo: event.url,
        quality: VideoQuality.p1080,
        showConnectionPrompt: false,
        connectionPromptShown: false,
      ),
    );
  }

  Future<void> _play(
    PlayPressed event,
    Emitter<PlayerBlocState> emit,
  ) async {
    await mediaKit.play();
  }

  Future<void> _pause(
    PausePressed event,
    Emitter<PlayerBlocState> emit,
  ) async {
    await mediaKit.pause();
  }

  Future<void> _seek(
    SeekTo event,
    Emitter<PlayerBlocState> emit,
  ) async {
    await mediaKit.seek(event.position);
  }

  Future<void> _forward(
    ForwardFiveSeconds event,
    Emitter<PlayerBlocState> emit,
  ) async {
    final current = mediaKit.player.state.position;

    await mediaKit.seek(
      current + const Duration(seconds: 5),
    );
  }

  Future<void> _backward(
      BackwardFiveSeconds event,
      Emitter<PlayerBlocState> emit) async {
    final current = mediaKit.player.state.position;
    
    var target = current - const Duration(seconds: 5);
    if (target < Duration.zero) {
      target = Duration.zero;
    }

    await mediaKit.seek(target);
  }

  Future<void> _speed(
    ChangePlaybackSpeed event,
    Emitter<PlayerBlocState> emit,
  ) async {
    await mediaKit.speed(event.speed);

    emit(
      state.copyWith(
        playbackSpeed: event.speed,
      ),
    );
  }

  Future<void> _quality(
    ChangeQuality event,
    Emitter<PlayerBlocState> emit,
  ) async {
    if (state.currentVideo == null) return;

    final currentPosition = mediaKit.player.state.position;
    final wasPlaying = mediaKit.player.state.playing;

    emit(
      state.copyWith(
        quality: event.quality,
      ),
    );

    String targetUrl = state.currentVideo!;

    if (event.quality != VideoQuality.auto) {
      final uri = Uri.parse(state.currentVideo!);

      final segments = List<String>.from(uri.pathSegments);

      // Remove master.m3u8
      segments.removeLast();

      switch (event.quality) {
        case VideoQuality.p360:
          segments.addAll(["360", "index.m3u8"]);
          break;

        case VideoQuality.p480:
          segments.addAll(["480", "index.m3u8"]);
          break;

        case VideoQuality.p720:
          segments.addAll(["720", "index.m3u8"]);
          break;

        case VideoQuality.p1080:
          segments.addAll(["1080", "index.m3u8"]);
          break;

        case VideoQuality.auto:
          break;
      }

      targetUrl = uri.replace(pathSegments: segments).toString();
    }

    await mediaKit.open(targetUrl);
    await mediaKit.seek(currentPosition);

    if (!wasPlaying) {
      await mediaKit.pause();
    }
  }

  void _toggleControls(
    ToggleControls event,
    Emitter<PlayerBlocState> emit,
  ) {
    emit(
      state.copyWith(
        controlsVisible: !state.controlsVisible,
      ),
    );
  }

  void _showControls(
    ShowControls event,
    Emitter<PlayerBlocState> emit,
  ) {
    emit(
      state.copyWith(
        controlsVisible: true,
      ),
    );
  }

  void _hideControls(
    HideControls event,
    Emitter<PlayerBlocState> emit,
  ) {
    emit(
      state.copyWith(
        controlsVisible: false,
      ),
    );
  }

  void _enterFullscreen(
    EnterFullscreen event,
    Emitter<PlayerBlocState> emit,
  ) {
    emit(
      state.copyWith(
        fullscreen: true,
      ),
    );
  }

  void _exitFullscreen(
    ExitFullscreen event,
    Emitter<PlayerBlocState> emit,
  ) {
    emit(
      state.copyWith(
        fullscreen: false,
      ),
    );
  }

  void _onBufferingChanged(
    BufferingStateChanged event,
    Emitter<PlayerBlocState> emit,
  ) {
    if (event.isBuffering) {
      if (state.quality == VideoQuality.p1080 && !state.connectionPromptShown) {
        _bufferingTimer?.cancel();
        _bufferingTimer = Timer(const Duration(seconds: 3), () {
          add(ShowConnectionPrompt());
        });
      }
    } else {
      _bufferingTimer?.cancel();
    }
  }

  void _showConnectionPrompt(
    ShowConnectionPrompt event,
    Emitter<PlayerBlocState> emit,
  ) {
    if (state.quality == VideoQuality.p1080 && !state.connectionPromptShown) {
      emit(state.copyWith(showConnectionPrompt: true));
    }
  }

  Future<void> _acceptConnectionPrompt(
    AcceptConnectionPrompt event,
    Emitter<PlayerBlocState> emit,
  ) async {
    emit(state.copyWith(showConnectionPrompt: false, connectionPromptShown: true));
    add(ChangeQuality(VideoQuality.auto));
  }

  void _dismissConnectionPrompt(
    DismissConnectionPrompt event,
    Emitter<PlayerBlocState> emit,
  ) {
    emit(state.copyWith(showConnectionPrompt: false, connectionPromptShown: true));
  }

  @override
  Future<void> close() async {
    _bufferingTimer?.cancel();
    await _bufferingSubscription?.cancel();
    mediaKit.dispose();
    await super.close();
  }
}