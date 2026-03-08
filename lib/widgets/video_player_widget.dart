import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../constants/app_theme.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String? videoPath;
  final bool isRecording;
  final bool useAssetVideo;

  const VideoPlayerWidget({
    super.key,
    this.videoPath,
    this.isRecording = false,
    this.useAssetVideo = false,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController? _videoController;
  bool _isPlaying = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      if (widget.videoPath != null) {
        if (widget.useAssetVideo) {
          // Load from assets
          _videoController =
              VideoPlayerController.asset(widget.videoPath!);
        } else {
          // Load from file path
          _videoController =
              VideoPlayerController.network(widget.videoPath!);
        }

        await _videoController!.initialize();

        if (mounted) {
          setState(() => _isInitializing = false);
        }
      } else {
        if (mounted) {
          setState(() => _isInitializing = false);
        }
      }
    } catch (e) {
      print('Error initializing video: $e');
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoPath != widget.videoPath) {
      _videoController?.dispose();
      _initializeVideo();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isRecording
              ? AppColors.accentRed.withValues(alpha: 0.3)
              : AppColors.border,
          width: widget.isRecording ? 2 : 1,
        ),
        boxShadow: widget.isRecording
            ? [
                BoxShadow(
                  color: AppColors.accentRed.withValues(alpha: 0.2),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: Stack(
        children: [
          // Video preview or placeholder
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.bgPrimary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: _isInitializing
                ? _buildLoading()
                : (_videoController != null &&
                        _videoController!.value.isInitialized &&
                        widget.videoPath != null)
                    ? _buildVideoPlayer()
                    : _buildPlaceholder(),
          ),

          // Play button overlay (if video exists and not recording)
          if (_videoController != null &&
              _videoController!.value.isInitialized &&
              !widget.isRecording)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (_isPlaying) {
                        _videoController!.pause();
                      } else {
                        _videoController!.play();
                      }
                      _isPlaying = !_isPlaying;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _isPlaying
                          ? Colors.transparent
                          : Colors.black.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _isPlaying
                        ? const SizedBox.shrink()
                        : Center(
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accentPink
                                        .withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),

          // Recording indicator (red dot + text)
          if (widget.isRecording)
            Positioned(
              top: 16,
              right: 16,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.accentRed,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentRed.withValues(alpha: 0.6),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Recording',
                    style: TextStyle(
                      color: AppColors.accentRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

          // Video controls (when playing)
          if (_isPlaying && _videoController != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Progress bar
                    VideoProgressIndicator(
                      _videoController!,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: AppColors.accentPink,
                        bufferedColor:
                            AppColors.accentPink.withValues(alpha: 0.3),
                        backgroundColor:
                            Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Time display
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(
                              _videoController!.value.position),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _formatDuration(
                              _videoController!.value.duration),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.accentPink,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Loading video...',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.auto_awesome_rounded,
          size: 48,
          color: AppColors.textMuted.withValues(alpha: 0.3),
        ),
        const SizedBox(height: 16),
        Text(
          'Your story unfolds here...',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textMuted.withValues(alpha: 0.6),
            fontStyle: FontStyle.italic,
            letterSpacing: 0.3,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Generated video will appear here',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textMuted.withValues(alpha: 0.4),
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_isPlaying) {
            _videoController!.pause();
          } else {
            _videoController!.play();
          }
          _isPlaying = !_isPlaying;
        });
      },
      child: VideoPlayer(_videoController!),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}