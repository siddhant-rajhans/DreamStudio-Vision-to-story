import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import '../constants/app_theme.dart';
import '../widgets/waveform_bar.dart';
import '../widgets/video_player_widget.dart';
import '../services/camera_service.dart';
import '../services/audio_service.dart';

class StudioScreen extends StatefulWidget {
  const StudioScreen({super.key});

  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen>
    with TickerProviderStateMixin {
  bool _showSplash = true;
  bool _isRecording = false;
  bool _musicEnabled = true;
  bool _cameraEnabled = false;
  int _activeScene = 0;
  int _sceneCount = 3;
  String? _recordedVideoPath;
  final TextEditingController _textController = TextEditingController();

  late CameraService _cameraService;
  late AudioService _audioService;

  // Mood cycling
  final List<Map<String, dynamic>> _moods = [
    {'name': 'Mysterious', 'color': AppColors.accentPurple},
    {'name': 'Tense', 'color': AppColors.accentRed},
    {'name': 'Wonder', 'color': AppColors.accentTeal},
    {'name': 'Triumphant', 'color': AppColors.accentGold},
    {'name': 'Melancholy', 'color': AppColors.accentPink},
  ];
  int _currentMoodIndex = 0;
  Timer? _moodTimer;

  late AnimationController _pulseController;
  late AnimationController _cameraController;

  @override
  void initState() {
    super.initState();
    _cameraService = CameraService();
    _audioService = AudioService();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _cameraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _moodTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted && !_showSplash) {
        setState(() {
          _currentMoodIndex = (_currentMoodIndex + 1) % _moods.length;
        });
      }
    });
  }

  Future<void> _initializeServices() async {
    try {
      await _cameraService.initializeCamera();
      await _audioService.requestMicrophonePermission();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error initializing services: $e');
      _showErrorSnackbar('Failed to initialize camera/audio: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.accentRed,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _toggleCamera() async {
    try {
      if (!_cameraService.isInitialized) {
        _showErrorSnackbar('Camera not initialized');
        return;
      }

      setState(() => _cameraEnabled = !_cameraEnabled);
      HapticFeedback.mediumImpact();

      if (_cameraEnabled) {
        await _cameraService.startVideoRecording();
      } else {
        final video = await _cameraService.stopVideoRecording();
        if (video != null) {
          setState(() => _recordedVideoPath = video.path);
          print('Video saved: ${video.path}');
          _showErrorSnackbar('Video recorded successfully!');
        }
      }
    } catch (e) {
      print('Error toggling camera: $e');
      _showErrorSnackbar('Camera error: $e');
      setState(() => _cameraEnabled = false);
    }
  }

  Future<void> _toggleMicrophone() async {
    try {
      if (_isRecording) {
        final audioPath = await _audioService.stopRecording();
        setState(() => _isRecording = false);
        if (audioPath != null) {
          print('Audio saved: $audioPath');
          _showErrorSnackbar('Audio recorded successfully!');
        }
      } else {
        await _audioService.startRecording();
        setState(() => _isRecording = true);
        _showErrorSnackbar('Recording audio...');
      }
      HapticFeedback.mediumImpact();
    } catch (e) {
      print('Error toggling microphone: $e');
      _showErrorSnackbar('Microphone error: $e');
      setState(() => _isRecording = false);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _cameraController.dispose();
    _moodTimer?.cancel();
    _textController.dispose();
    _cameraService.dispose();
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) return _buildSplash();
    return _buildStudio();
  }

  Widget _buildSplash() {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentPink.withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(Icons.play_arrow_rounded,
                  color: AppColors.bgPrimary, size: 40),
            ),
            const SizedBox(height: 24),
            Text('StoryLens', style: AppTextStyles.heroTitle),
            const SizedBox(height: 8),
            Text('Story Studio', style: AppTextStyles.bodyText),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () async {
                await _initializeServices();
                setState(() => _showSplash = false);
              },
              icon: const Icon(Icons.auto_awesome_rounded, size: 18),
              label: const Text('Begin Your Story'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudio() {
    final mood = _moods[_currentMoodIndex];
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: 12,
              ),
              decoration: const BoxDecoration(
                color: AppColors.bgSecondary,
                border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'StoryLens',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentPink,
                    ),
                  ),
                  const Spacer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: (mood['color'] as Color).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (mood['color'] as Color).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: mood['color'] as Color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          mood['name'] as String,
                          style: TextStyle(
                            fontSize: isMobile ? 11 : 12,
                            fontWeight: FontWeight.w600,
                            color: mood['color'] as Color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/output'),
                    child: Text(
                      'End Story',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Video Player Area (Main Canvas) - NOW WITH DEFAULT VIDEO!
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                child: VideoPlayerWidget(
                  videoPath: _recordedVideoPath ?? 'assets/images/videos/background.mp4',
                  isRecording: _cameraEnabled,
                  useAssetVideo: _recordedVideoPath == null,
                ),
              ),
            ),

            // Bottom Controls
            Container(
              decoration: const BoxDecoration(
                color: AppColors.bgSecondary,
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: Column(
                children: [
                  // Scene Timeline
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: isMobile ? 10 : 12,
                        horizontal: isMobile ? 16 : 20,
                      ),
                      child: Row(
                        children: [
                          ...List.generate(_sceneCount, (index) {
                            final isActive = index == _activeScene;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => _activeScene = index),
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 12 : 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: isActive
                                      ? AppColors.primaryGradient
                                      : null,
                                  color: isActive
                                      ? null
                                      : AppColors.bgCard,
                                  borderRadius: BorderRadius.circular(10),
                                  border: isActive
                                      ? null
                                      : Border.all(
                                          color: AppColors.border),
                                ),
                                child: Text(
                                  'Scene ${index + 1}',
                                  style: TextStyle(
                                    fontSize: isMobile ? 12 : 13,
                                    fontWeight: FontWeight.w600,
                                    color: isActive
                                        ? AppColors.bgPrimary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                  // Audio Controls
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 20,
                      vertical: isMobile ? 10 : 12,
                    ),
                    child: Row(
                      children: [
                        // Mic button
                        GestureDetector(
                          onTap: _toggleMicrophone,
                          child: AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                width: isMobile ? 40 : 44,
                                height: isMobile ? 40 : 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isRecording
                                      ? AppColors.accentRed.withValues(
                                          alpha: 0.15 +
                                              _pulseController.value * 0.1,
                                        )
                                      : AppColors.bgCard,
                                  border: Border.all(
                                    color: _isRecording
                                        ? AppColors.accentRed
                                        : AppColors.border,
                                    width: _isRecording ? 2 : 1,
                                  ),
                                  boxShadow: _isRecording
                                      ? [
                                          BoxShadow(
                                            color: AppColors.accentRed
                                                .withValues(alpha: 0.15),
                                            blurRadius: 12,
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Icon(
                                  _isRecording
                                      ? Icons.mic
                                      : Icons.mic_none,
                                  color: _isRecording
                                      ? AppColors.accentRed
                                      : AppColors.textSecondary,
                                  size: isMobile ? 18 : 20,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Waveform
                        Expanded(
                          child: WaveformBar(
                            isAnimating: _isRecording,
                            barCount: isMobile ? 16 : 24,
                            height: isMobile ? 30 : 36,
                            color: _isRecording
                                ? AppColors.accentPink
                                : AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Music toggle
                        GestureDetector(
                          onTap: () {
                            setState(() =>
                                _musicEnabled = !_musicEnabled);
                            HapticFeedback.lightImpact();
                          },
                          child: Container(
                            width: isMobile ? 36 : 40,
                            height: isMobile ? 36 : 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _musicEnabled
                                  ? AppColors.accentTeal
                                      .withValues(alpha: 0.12)
                                  : AppColors.bgCard,
                              border: Border.all(
                                color: _musicEnabled
                                    ? AppColors.accentTeal
                                        .withValues(alpha: 0.3)
                                    : AppColors.border,
                              ),
                            ),
                            child: Icon(
                              _musicEnabled
                                  ? Icons.music_note_rounded
                                  : Icons.music_off_rounded,
                              color: _musicEnabled
                                  ? AppColors.accentTeal
                                  : AppColors.textMuted,
                              size: isMobile ? 16 : 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Text Input
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 20,
                      vertical: isMobile ? 10 : 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: isMobile ? 40 : 44,
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 12 : 16,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.bgCard,
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: AppColors.border),
                            ),
                            child: TextField(
                              controller: _textController,
                              style: TextStyle(
                                fontSize: isMobile ? 13 : 14,
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Type direction...',
                                hintStyle: TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: isMobile ? 13 : 14,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                          },
                          child: Container(
                            width: isMobile ? 40 : 44,
                            height: isMobile ? 40 : 44,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.send_rounded,
                              color: AppColors.bgPrimary,
                              size: isMobile ? 16 : 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Camera Button (floating in bottom right)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 20,
                      vertical: isMobile ? 10 : 12,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _toggleCamera,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isMobile ? 90 : 110,
                          height: isMobile ? 45 : 50,
                          decoration: BoxDecoration(
                            gradient: _cameraEnabled
                                ? AppColors.primaryGradient
                                : null,
                            color: _cameraEnabled
                                ? null
                                : AppColors.bgCard,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _cameraEnabled
                                  ? AppColors.accentPink
                                  : AppColors.border,
                              width: _cameraEnabled ? 2 : 1,
                            ),
                            boxShadow: _cameraEnabled
                                ? [
                                    BoxShadow(
                                      color: AppColors.accentPink
                                          .withValues(alpha: 0.3),
                                      blurRadius: 16,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_cameraEnabled)
                                AnimatedBuilder(
                                  animation: _cameraController,
                                  builder: (context, child) {
                                    return Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(
                                          alpha: 0.4 +
                                              _cameraController.value *
                                                  0.6,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              else
                                const SizedBox.shrink(),
                              const SizedBox(width: 6),
                              Icon(
                                _cameraEnabled
                                    ? Icons.videocam
                                    : Icons.videocam_outlined,
                                color: _cameraEnabled
                                    ? Colors.white
                                    : AppColors.textMuted,
                                size: isMobile ? 20 : 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}