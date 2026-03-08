import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_theme.dart';
import '../widgets/waveform_bar.dart';

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
  int _activeScene = 0;
  final int _sceneCount = 3;
  final TextEditingController _textController = TextEditingController();

  final List<Map<String, dynamic>> _moods = [
    {'name': 'Mysterious', 'color': AppColors.accentBlue},
    {'name': 'Tense', 'color': AppColors.accentRed},
    {'name': 'Wonder', 'color': AppColors.accentGreen},
    {'name': 'Triumphant', 'color': AppColors.accentWarm},
    {'name': 'Melancholy', 'color': AppColors.accentPink},
  ];
  int _currentMoodIndex = 0;
  Timer? _moodTimer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _moodTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted && !_showSplash) {
        setState(() => _currentMoodIndex = (_currentMoodIndex + 1) % _moods.length);
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _moodTimer?.cancel();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _showSplash ? _buildSplash() : _buildStudio();
  }

  Widget _buildSplash() {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo — matches web splash with gradient glow
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: AppColors.accentWarm.withValues(alpha: 0.3), blurRadius: 30, spreadRadius: 5),
                ],
              ),
              child: const Icon(Icons.play_arrow_rounded, color: AppColors.bgPrimary, size: 40),
            ),
            const SizedBox(height: 24),
            ShaderMask(
              shaderCallback: (bounds) => AppColors.primaryGradient
                  .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: Text('StoryLine',
                  style: GoogleFonts.playfairDisplay(fontSize: 40, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
            const SizedBox(height: 8),
            Text('Story Studio', style: AppTextStyles.bodyText),
            const SizedBox(height: 40),
            // CTA with gradient
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() => _showSplash = false),
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome_rounded, color: AppColors.bgPrimary, size: 18),
                        const SizedBox(width: 8),
                        Text('Begin Your Story',
                            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.bgPrimary)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudio() {
    final mood = _moods[_currentMoodIndex];
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar — matches web .top-bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.bgSecondary,
                border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: ShaderMask(
                      shaderCallback: (bounds) => AppColors.primaryGradient
                          .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                      child: Text('StoryLine',
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
                  const Spacer(),
                  // Mood badge — matches web .mood-badge
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.bgElevated,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: (mood['color'] as Color).withValues(alpha: 0.3),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        'Mood: ${mood['name']}',
                        key: ValueKey(mood['name']),
                        style: GoogleFonts.inter(
                          fontSize: 12, color: mood['color'] as Color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Connection dot
                  Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AppColors.accentGreen.withValues(alpha: 0.5), blurRadius: 6)],
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/output'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.accentRed,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    child: Text('End Story',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ],
              ),
            ),

            // Story Canvas — matches web .story-canvas
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: AppColors.bgPrimary,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome_rounded, size: 48,
                            color: AppColors.textMuted.withValues(alpha: 0.3)),
                        const SizedBox(height: 16),
                        Text('Speak or type to begin',
                            style: GoogleFonts.inter(fontSize: 16, color: AppColors.textMuted)),
                        const SizedBox(height: 6),
                        Text('AI generates scenes as you narrate',
                            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  // Narration overlay — matches web .narration-overlay
                  Positioned(
                    left: 16, right: 16, bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.bgOverlay,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Text(
                        '"The fog rolls in over a city that no map has charted..."',
                        style: GoogleFonts.inter(
                            fontSize: 14, color: AppColors.textPrimary, fontStyle: FontStyle.italic, height: 1.5),
                      ),
                    ),
                  ),
                  // Camera PIP — matches web .camera-pip
                  Positioned(
                    right: 16, bottom: 80,
                    child: Container(
                      width: 72, height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.bgElevated,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderLight),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 16)],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.videocam_outlined, color: AppColors.textMuted, size: 24),
                          const SizedBox(height: 4),
                          Text('Camera', style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Timeline — matches web .timeline
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.bgSecondary,
                border: Border(top: BorderSide(color: AppColors.borderSubtle)),
              ),
              child: SceneTimeline(
                sceneCount: _sceneCount,
                activeScene: _activeScene,
                onSceneTap: (i) => setState(() => _activeScene = i),
              ),
            ),

            // Audio controls — matches web .audio-controls
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.bgSecondary,
                border: Border(top: BorderSide(color: AppColors.borderSubtle)),
              ),
              child: Row(
                children: [
                  // Mic button — matches web .mic-btn
                  GestureDetector(
                    onTap: () => setState(() => _isRecording = !_isRecording),
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isRecording
                                ? AppColors.accentWarm.withValues(alpha: 0.15 + _pulseController.value * 0.1)
                                : AppColors.bgElevated,
                            border: Border.all(
                              color: _isRecording ? AppColors.accentWarm : AppColors.borderSubtle,
                              width: _isRecording ? 2 : 1,
                            ),
                          ),
                          child: Icon(
                            _isRecording ? Icons.mic : Icons.mic_none,
                            color: _isRecording ? AppColors.accentWarm : AppColors.textPrimary,
                            size: 22,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: WaveformBar(
                      isAnimating: _isRecording,
                      barCount: 24, height: 32,
                      color: _isRecording ? AppColors.accentWarm : AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => setState(() => _musicEnabled = !_musicEnabled),
                    child: Container(
                      width: 38, height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _musicEnabled ? AppColors.accentGreen.withValues(alpha: 0.15) : AppColors.bgElevated,
                        border: Border.all(
                          color: _musicEnabled ? AppColors.accentGreen.withValues(alpha: 0.4) : AppColors.borderSubtle,
                        ),
                      ),
                      child: Icon(
                        _musicEnabled ? Icons.music_note_rounded : Icons.music_off_rounded,
                        color: _musicEnabled ? AppColors.accentGreen : AppColors.textMuted, size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Text input — matches web .text-input-wrap
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: AppColors.bgPrimary,
                border: Border(top: BorderSide(color: AppColors.borderSubtle)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.bgElevated,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: TextField(
                        controller: _textController,
                        style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Type direction...',
                          hintStyle: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(Icons.send_rounded, color: AppColors.bgPrimary, size: 20),
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
