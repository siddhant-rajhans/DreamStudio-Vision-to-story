import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_theme.dart';
import '../widgets/gradient_badge.dart';
import '../widgets/stat_card.dart';
import '../widgets/waveform_bar.dart';

class OutputScreen extends StatelessWidget {
  const OutputScreen({super.key});

  // Colors matched to web CSS:
  // stat warm = accent-warm (#E8A87C), pink = accent-pink (#D4789C),
  // blue = accent-blue (#6C8EBF), green = accent-green (#7BC47F)
  // scene-number = accent-warm, scene-type .image = accent-pink, .climax = accent-red
  // mood-mysterious = accent-blue, mood-tense = accent-red,
  // mood-wonder = accent-warm, mood-triumphant = accent-green

  static const List<Map<String, dynamic>> _scenes = [
    {
      'number': 1,
      'type': 'IMAGE',
      'typeColor': AppColors.accentPink,
      'title': 'The Fog Descends',
      'narration':
          'Towers of black glass twist upward like frozen lightning.',
      'mood': 'MYSTERIOUS',
      'moodColor': AppColors.accentBlue,
    },
    {
      'number': 2,
      'type': 'IMAGE',
      'typeColor': AppColors.accentPink,
      'title': 'A Figure in the Market',
      'narration':
          'Through the chaos, one figure stands perfectly still — a woman in a red coat, watching.',
      'mood': 'TENSE',
      'moodColor': AppColors.accentRed,
    },
    {
      'number': 3,
      'type': 'IMAGE',
      'typeColor': AppColors.accentPink,
      'title': 'The Map Room',
      'narration':
          'The walls are covered in hand-drawn maps of places that don\'t exist — or shouldn\'t.',
      'mood': 'WONDER',
      'moodColor': AppColors.accentWarm,
    },
    {
      'number': 4,
      'type': 'CLIMAX',
      'typeColor': AppColors.accentRed,
      'title': 'The City Awakens',
      'narration':
          'The city\'s towers begin to rearrange themselves, shifting like a living puzzle.',
      'mood': 'TENSE',
      'moodColor': AppColors.accentRed,
    },
    {
      'number': 5,
      'type': 'IMAGE',
      'typeColor': AppColors.accentPink,
      'title': 'A New Dawn',
      'narration':
          '\'Now it\'s your city too,\' she says. The fog lifts. Roll credits.',
      'mood': 'TRIUMPHANT',
      'moodColor': AppColors.accentGreen,
    },
  ];

  static const List<Map<String, dynamic>> _soundtracks = [
    {
      'title': 'Ambient Mystery',
      'subtitle': 'Low strings, ethereal pads, sparse piano',
      'duration': '0:30',
      'color': AppColors.accentGreen,
    },
    {
      'title': 'Triumphant Resolve',
      'subtitle': 'Soaring brass, full orchestra, hopeful theme',
      'duration': '0:30',
      'color': AppColors.accentGreen,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Nav bar — matches web .nav
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/'),
                      child: Row(
                        children: [
                          // Gradient logo icon
                          Container(
                            width: 22, height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.accentWarm, width: 1.5),
                            ),
                            child: const Icon(Icons.play_arrow_rounded,
                                color: AppColors.accentWarm, size: 12),
                          ),
                          const SizedBox(width: 8),
                          ShaderMask(
                            shaderCallback: (bounds) => AppColors.primaryGradient
                                .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                            child: Text('StoryLine',
                                style: GoogleFonts.playfairDisplay(
                                    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // New Story — web .btn-outline
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/studio'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.play_arrow_rounded, color: AppColors.textPrimary, size: 14),
                            const SizedBox(width: 5),
                            Text('New Story', style: GoogleFonts.inter(
                              fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Share — web .btn-filled
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.share_rounded, color: AppColors.bgPrimary, size: 14),
                          const SizedBox(width: 5),
                          Text('Share', style: GoogleFonts.inter(
                            fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.bgPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Story Complete badge — matches web .story-complete-badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.accentGreen.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.accentGreen.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.accentGreen, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            'STORY COMPLETE',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.8,
                              color: AppColors.accentGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title — web .story-title uses Playfair Display
                    Text(
                      'The City That\nShouldn\'t Exist',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // Meta info — matches web .story-meta
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _metaItem(Icons.access_time_rounded, '4 min 32 sec'),
                        _metaItem(Icons.image_rounded, '5 Scenes'),
                        _metaItem(Icons.mic_rounded, 'Voice-directed'),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Divider
                    Container(height: 1, color: AppColors.borderSubtle),
                    const SizedBox(height: 28),

                    // Stats Grid — matches web .stats-bar with correct color mapping
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2.0,
                      children: const [
                        OutputStatCard(
                            value: '5',
                            label: 'Images',
                            color: AppColors.accentWarm),
                        OutputStatCard(
                            value: '1',
                            label: 'Video Clip',
                            color: AppColors.accentPink),
                        OutputStatCard(
                            value: '2',
                            label: 'Music Tracks',
                            color: AppColors.accentBlue),
                        OutputStatCard(
                            value: '4',
                            label: 'Mood Shifts',
                            color: AppColors.accentGreen),
                      ],
                    ),
                    const SizedBox(height: 36),

                    // Storyboard Section — matches web .storyboard-heading
                    Row(
                      children: [
                        Icon(Icons.image_rounded,
                            color: AppColors.accentWarm, size: 22),
                        const SizedBox(width: 8),
                        Text('Storyboard',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 20, fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Scene Cards
                    ...List.generate(_scenes.length, (i) {
                      final scene = _scenes[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _buildSceneCard(scene),
                      );
                    }),
                    const SizedBox(height: 28),

                    // Soundtrack Section — matches web music heading with green icon
                    Row(
                      children: [
                        Icon(Icons.music_note_rounded,
                            color: AppColors.accentGreen, size: 22),
                        const SizedBox(width: 8),
                        Text('Soundtrack',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 20, fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    ...List.generate(_soundtracks.length, (i) {
                      final track = _soundtracks[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildSoundtrackCard(track),
                      );
                    }),
                    const SizedBox(height: 28),

                    // Divider before actions
                    Container(height: 1, color: AppColors.borderSubtle),
                    const SizedBox(height: 24),

                    // Action Buttons — matches web .actions-section
                    Row(
                      children: [
                        // Create Another — gradient filled
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/studio'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.play_arrow_rounded,
                                      color: AppColors.bgPrimary, size: 16),
                                  const SizedBox(width: 6),
                                  Text('Create Another',
                                      style: GoogleFonts.inter(
                                        fontSize: 13, fontWeight: FontWeight.w600,
                                        color: AppColors.bgPrimary)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Download — outline
                        _outlineButton(Icons.download_rounded, 'Download'),
                        const SizedBox(width: 10),
                        // Share — outline
                        _outlineButton(Icons.share_rounded, 'Share'),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Footer — matches web .output-footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Made with ', style: GoogleFonts.inter(
                            fontSize: 12, color: AppColors.textMuted)),
                        ShaderMask(
                          shaderCallback: (bounds) => AppColors.primaryGradient
                              .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                          child: Text('StoryLine',
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _outlineButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 14),
            const SizedBox(width: 5),
            Text(label, style: GoogleFonts.inter(
              fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  static Widget _metaItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 5),
        Text(text, style: GoogleFonts.inter(
            fontSize: 13, color: AppColors.textMuted)),
      ],
    );
  }

  static Widget _buildSceneCard(Map<String, dynamic> scene) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder — matches web .scene-image
          Container(
            height: 180,
            width: double.infinity,
            color: AppColors.bgElevated,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        scene['type'] == 'CLIMAX'
                            ? Icons.videocam_rounded
                            : Icons.image_rounded,
                        color: AppColors.textMuted.withValues(alpha: 0.3),
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        scene['type'] == 'CLIMAX' ? 'Generated Video Clip' : 'Generated Image',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textMuted.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                // Scene number badge — web .scene-number: accent-warm on bg-overlay
                Positioned(
                  top: 10, left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.bgOverlay,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Scene ${scene['number']}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentWarm,
                      ),
                    ),
                  ),
                ),
                // Type badge — web .scene-type-badge
                Positioned(
                  top: 10, right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (scene['typeColor'] as Color).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      scene['type'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: scene['typeColor'] as Color,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scene details — matches web .scene-details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title — web uses Playfair Display
                Text(
                  scene['title'] as String,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),

                // Narration quote — web .scene-narration: border-left accent-warm
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 2,
                      height: 40,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.accentWarm,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '"${scene['narration']}"',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                          height: 1.65,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Mood badge — matches web .scene-mood .mood-*
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (scene['moodColor'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    scene['mood'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: scene['moodColor'] as Color,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSoundtrackCard(Map<String, dynamic> track) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Music icon — web .music-icon with green gradient bg
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.accentGreen.withValues(alpha: 0.15),
                      AppColors.accentGreen.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.music_note_rounded,
                    color: track['color'] as Color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track['title'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${track['subtitle']} · ${track['duration']}',
                      style: GoogleFonts.inter(
                        fontSize: 13, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Waveform — matches web .music-waveform
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: BorderRadius.circular(8),
            ),
            child: WaveformBar(
              isAnimating: false,
              barCount: 40,
              height: 32,
              color: track['color'] as Color,
            ),
          ),
        ],
      ),
    );
  }
}
