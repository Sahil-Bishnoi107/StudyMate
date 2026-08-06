import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class MediaKitService {
  final Player player = Player();

  late final VideoController controller =
      VideoController(player);

 Future<void> open(String url) async {
  print("Opening: $url");

  await player.open(Media(url)); 

  print("Opened successfully");

  print("Playing: ${player.state.playing}");
  print("Buffering: ${player.state.buffering}");
  print("Duration: ${player.state.duration}");
}

  Future<void> play() async {
    await player.play();
  }

  Future<void> pause() async {
    await player.pause();
  }

  Future<void> seek(Duration duration) async {
    await player.seek(duration);
  }

  Future<void> speed(double speed) async {
    await player.setRate(speed);
  }

  void dispose() {
    player.dispose();
  }
}