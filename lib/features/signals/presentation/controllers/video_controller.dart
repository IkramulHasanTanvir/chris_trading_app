import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';

class VideosController extends GetxController {
  static VideosController get to => Get.find();

  // ─── Player ──────────────────────────────────────────────────────────────────
  late final Player player;

  // ─── Observable state ────────────────────────────────────────────────────────
  final _isLoading = true.obs;
  final _isPlaying = false.obs;
  final _isBuffering = false.obs;
  final _isInitialized = false.obs;
  final _isEnded = false.obs;

  bool get isLoading => _isLoading.value;
  bool get isPlaying => _isPlaying.value;
  bool get isBuffering => _isBuffering.value;
  bool get isInitialized => _isInitialized.value;
  bool get isEnded => _isEnded.value;

  // ─── GetX lifecycle ──────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    player = Player();
    _listenToPlayer();
  }

  // ─── Stream listeners ────────────────────────────────────────────────────────
  void _listenToPlayer() {
    // Playing state
    player.stream.playing.listen((playing) {
      _isPlaying.value = playing;
    });

    // Buffering state
    player.stream.buffering.listen((buffering) {
      _isBuffering.value = buffering;
    });

    // ✅ Video শেষ হলে এই stream fire হয় — কোনো hack দরকার নেই
    player.stream.completed.listen((completed) {
      if (completed) {
        _isEnded.value = true;
        _isPlaying.value = false;
      }
    });
  }

  // ─── Init video ──────────────────────────────────────────────────────────────
  Future<void> initializeVideo(SignalsModel? signal) async {
    try {
      final url = signal?.videoUrl?.trim();

      if (url == null || url.isEmpty) {
        _isLoading.value = false;
        _isInitialized.value = false;
        _isPlaying.value = false;
        _isBuffering.value = false;
        _isEnded.value = false;
        return;
      }

      _isLoading.value = true;
      _isInitialized.value = false;

      // Cache video file
      final file = await DefaultCacheManager().getSingleFile(url);

      await player.open(Media(file.path), play: true);

      _isInitialized.value = true;
      _isLoading.value = false;
      _isEnded.value = false;
    } catch (e) {
      _isLoading.value = false;
      _isInitialized.value = false;
    }
  }

  // ─── Toggle play/pause ───────────────────────────────────────────────────────
  // ✅ Stop থেকে Play করলে শুরু থেকে আসবে
  Future<void> togglePlayPause() async {
    if (_isEnded.value) {
      // Video শেষ হয়েছিল → শুরু থেকে play করো
      _isEnded.value = false;
      await player.seek(Duration.zero);
      await player.play();
    } else {
      await player.playOrPause();
    }
  }

  // ─── 10s Forward seek ────────────────────────────────────────────────────────
  Future<void> seekForward10s() async {
    final current = player.state.position;
    final duration = player.state.duration;
    final target = current + const Duration(seconds: 10);

    if (target >= duration) {
      await player.seek(duration);
    } else {
      await player.seek(target);
    }
  }

  // ─── 10s Backward seek ───────────────────────────────────────────────────────
  Future<void> seekBackward10s() async {
    final current = player.state.position;
    final target = current - const Duration(seconds: 10);

    if (_isEnded.value) {
      _isEnded.value = false;
    }

    await player.seek(target < Duration.zero ? Duration.zero : target);

    if (!player.state.playing) {
      await player.play();
    }
  }

  // ─── Dispose ─────────────────────────────────────────────────────────────────
  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}