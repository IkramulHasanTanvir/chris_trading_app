import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/custom_loader.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';
import 'package:flutter_task/features/signals/presentation/controllers/video_controller.dart';
import 'package:get/get.dart';
import 'package:media_kit_video/media_kit_video.dart';

class ChartSection extends StatefulWidget {
  final SignalsModel? signal;

  const ChartSection({super.key, required this.signal});

  @override
  State<ChartSection> createState() => _ChartSectionState();
}

class _ChartSectionState extends State<ChartSection> {
  late final VideosController _controller;
  late final VideoController _videoController; // media_kit VideoController

  @override
  void initState() {
    super.initState();
    _controller = VideosController.to;
    _videoController = VideoController(
      _controller.player,
    );
    _controller.initializeVideo(widget.signal);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading) {
        return _buildContainer(child: const CustomLoader());
      }

      if (!_controller.isInitialized) {
        return _buildContainer(
          child: const Icon(
            Icons.video_library_outlined,
            color: Colors.white54,
            size: 42,
          ),
        );
      }

      // ── Video player ────────────────────────────────────────────────────────
      return ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: SizedBox(
          height: 220.h,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Video ──────────────────────────────────────────────────────
              Positioned.fill(
                child: GestureDetector(
                  onTap: _controller.togglePlayPause,
                  child: Video(
                    controller: _videoController,
                    controls: NoVideoControls, // আমাদের নিজের controls আছে
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // ── Buffering loader ───────────────────────────────────────────
              if (_controller.isBuffering) const CustomLoader(),

              // ── Controls overlay ───────────────────────────────────────────
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _controller.isPlaying ? 0 : 1,
                child: IgnorePointer(
                  ignoring: _controller.isPlaying,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ← 10s backward
                      _SeekButton(
                        icon: Icons.replay_10_rounded,
                        onTap: _controller.seekBackward10s,
                      ),

                      SizedBox(width: 16.w),

                      // Play / Replay
                      GestureDetector(
                        onTap: _controller.togglePlayPause,
                        child: Container(
                          padding: EdgeInsets.all(14.r),
                          decoration: const BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _controller.isEnded
                                ? Icons.replay_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 42.r,
                          ),
                        ),
                      ),

                      SizedBox(width: 16.w),

                      // → 10s forward
                      _SeekButton(
                        icon: Icons.forward_10_rounded,
                        onTap: _controller.seekForward10s,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      height: 220.h,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.navBackground,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: child,
    );
  }
}

// ─── Reusable seek button ─────────────────────────────────────────────────────
class _SeekButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SeekButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: const BoxDecoration(
          color: Colors.black38,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 28.r),
      ),
    );
  }
}