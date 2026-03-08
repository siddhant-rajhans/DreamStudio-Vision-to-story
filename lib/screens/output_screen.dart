import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/gradient_badge.dart';
import '../widgets/stat_card.dart';
import '../widgets/waveform_bar.dart';

class OutputScreen extends StatefulWidget {
  const OutputScreen({super.key});

  @override
  State<OutputScreen> createState() => _OutputScreenState();
}

class _OutputScreenState extends State<OutputScreen> {
  late PageController _frameController;
  int _currentFrameIndex = 0;

  static const List<Map<String, dynamic>> _scenes = [
    {
      'number': 1,
      'type': 'IMAGE',
      'typeColor': AppColors.accentGold,
      'title': 'The Fog Descends',
      'narration':
          'Towers of black glass twist upward like frozen lightning.',
      'mood': 'MYSTERIOUS',
      'moodColor': AppColors.accentPurple,
    },
    {
      'number': 2,
      'type': 'IMAGE',
      'typeColor': AppColors.accentGold,
      'title': 'The Empty Market',
      'narration':
          'Stalls of impossible goods line the silent corridor — fruit that glows, fabrics that hum.',
      'mood': 'WONDER',
      'moodColor': AppColors.accentTeal,
    },
    {
      'number': 3,
      'type': 'VIDEO',
      'typeColor': AppColors.accentPurple,
      'title': 'The Figure Appears',
      'narration':
          'A silhouette steps from the mist, moving wrong — too smooth, too deliberate.',
      'mood': 'TENSE',
      'moodColor': AppColors.accentRed,
    },
    {
      'number': 4,
      'type': 'IMAGE',
      'typeColor': AppColors.accentGold,
      'title': 'The Archive',
      'narration':
          'Walls of screens flicker with memories that belong to no one living.',
      'mood': 'MELANCHOLY',
      'moodColor': AppColors.accentPink,
    },
    {
      'number': 5,
      'type': 'IMAGE',
      'typeColor': AppColors.accentGold,
      'title': 'The Departure',
      'narration':
          'The city folds behind you like a page being turned, already fading.',
      'mood': 'TRIUMPHANT',
      'moodColor': AppColors.accentGold,
    },
  ];

  static const List<Map<String, dynamic>> _soundtracks = [
    {
      'title': 'Ethereal Ambient — Scene 1-3',
      'duration': '2:15',
      'color': AppColors.accentPurple,
    },
    {
      'title': 'Tension Rising — Scene 3-5',
      'duration': '2:17',
      'color': AppColors.accentRed,
    },
  ];

  static const List<Map<String, dynamic>> _videoFrames = [
    {'frame': 1, 'time': '0:00'},
    {'frame': 2, 'time': '0:15'},
    {'frame': 3, 'time': '0:30'},
    {'frame': 4, 'time': '0:45'},
    {'frame': 5, 'time': '1:00'},
    {'frame': 6, 'time': '1:15'},
    {'frame': 7, 'time': '1:30'},
    {'frame': 8, 'time': '1:45'},
  ];

  @override
  void initState() {
    super.initState();
    _frameController = PageController(viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _frameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth < 1200;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
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
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: AppColors.bgPrimary, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'StoryLens',
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentPink,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/studio'),
                    child: Text(
                      'New',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: isMobile ? 12 : 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.accentPink.withValues(alpha: 0.15),
                        foregroundColor: AppColors.accentPink,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 14 : 18,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Share',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: isMobile ? 12 : 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 32,
                    vertical: isMobile ? 20 : 32,
                  ),
                  child: Column(
                    children: [
                      // Story Complete badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.accentGreen
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.accentGreen
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_rounded,
                                color: AppColors.accentGreen,
                                size: 16),
                            SizedBox(width: 8),
                            Text(
                              'STORY COMPLETE',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: AppColors.accentGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title
                      Text(
                        'The City That\nShouldn\'t Exist',
                        style: TextStyle(
                          fontSize: isMobile ? 28 : 36,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),

                      // Meta info
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: isMobile ? 12 : 20,
                        children: [
                          _metaItem(
                            Icons.access_time_rounded,
                            '4:32',
                          ),
                          _metaItem(
                            Icons.movie_creation_outlined,
                            '5 Scenes',
                          ),
                          _metaItem(
                            Icons.mic_rounded,
                            'Voice-directed',
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Stats Grid
                      GridView.count(
                        crossAxisCount: isMobile ? 2 : 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: isMobile ? 12 : 16,
                        crossAxisSpacing: isMobile ? 12 : 16,
                        childAspectRatio: 2.4,
                        children: [
                          StatCard(
                              value: '5',
                              label: 'IMAGES',
                              color: AppColors.accentGold),
                          StatCard(
                              value: '1',
                              label: 'VIDEO',
                              color: AppColors.accentPurple),
                          StatCard(
                              value: '2',
                              label: 'MUSIC',
                              color: AppColors.accentTeal),
                          StatCard(
                              value: '4',
                              label: 'MOODS',
                              color: AppColors.accentPink),
                        ],
                      ),
                      const SizedBox(height: 48),

                      // Video Frames Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppColors.accentPurple,
                                  borderRadius:
                                      BorderRadius.circular(2),
                                ),
                                margin:
                                    const EdgeInsets.only(right: 12),
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Video Clip',
                                    style: TextStyle(
                                      fontSize: isMobile ? 18 : 22,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Generated video scene frames',
                                    style: TextStyle(
                                      fontSize: isMobile ? 12 : 13,
                                      color: AppColors.textMuted,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Frame carousel
                          SizedBox(
                            height: isMobile ? 220 : 280,
                            child: PageView.builder(
                              controller: _frameController,
                              onPageChanged: (index) {
                                setState(
                                  () => _currentFrameIndex = index,
                                );
                              },
                              itemCount: _videoFrames.length,
                              itemBuilder: (context, index) {
                                final frame = _videoFrames[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(16),
                                    border: Border.all(
                                      color: _currentFrameIndex ==
                                              index
                                          ? AppColors.accentPurple
                                          : AppColors.border,
                                      width: _currentFrameIndex ==
                                              index
                                          ? 2
                                          : 1,
                                    ),
                                    boxShadow:
                                        _currentFrameIndex == index
                                            ? [
                                                BoxShadow(
                                                  color: AppColors
                                                      .accentPurple
                                                      .withValues(
                                                    alpha: 0.25,
                                                  ),
                                                  blurRadius: 20,
                                                  spreadRadius: 2,
                                                ),
                                              ]
                                            : [],
                                  ),
                                  child: Stack(
                                    children: [
                                      // Frame background
                                      Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.bgCard,
                                          borderRadius:
                                              BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),

                                      // Overlay
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black
                                              .withValues(alpha: 0.3),
                                          borderRadius:
                                              BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),

                                      // Content
                                      Padding(
                                        padding: const EdgeInsets.all(
                                          20,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                          children: [
                                            // Play button
                                            Container(
                                              width: isMobile
                                                  ? 48
                                                  : 56,
                                              height: isMobile
                                                  ? 48
                                                  : 56,
                                              decoration: BoxDecoration(
                                                gradient: AppColors
                                                    .primaryGradient,
                                                borderRadius:
                                                    BorderRadius
                                                        .circular(14),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors
                                                        .accentPink
                                                        .withValues(
                                                      alpha: 0.3,
                                                    ),
                                                    blurRadius: 16,
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                Icons
                                                    .play_arrow_rounded,
                                                color: AppColors
                                                    .bgPrimary,
                                                size: isMobile
                                                    ? 24
                                                    : 28,
                                              ),
                                            ),

                                            // Frame info
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                              children: [
                                                Text(
                                                  'Frame ${frame['frame']}',
                                                  style: TextStyle(
                                                    fontSize: isMobile
                                                        ? 14
                                                        : 16,
                                                    fontWeight:
                                                        FontWeight
                                                            .w700,
                                                    color: Colors
                                                        .white,
                                                    letterSpacing:
                                                        0.3,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  frame['time']
                                                      as String,
                                                  style: TextStyle(
                                                    fontSize: isMobile
                                                        ? 12
                                                        : 13,
                                                    color:
                                                        Colors.white70,
                                                    letterSpacing:
                                                        0.2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          // Indicator dots
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: List.generate(
                              _videoFrames.length,
                              (index) => AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 300),
                                width:
                                    _currentFrameIndex == index
                                        ? 28
                                        : 8,
                                height: 8,
                                margin:
                                    const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _currentFrameIndex == index
                                      ? AppColors.accentPurple
                                      : AppColors.border,
                                  borderRadius:
                                      BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),

                      // Storyboard Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppColors.accentGold,
                                  borderRadius:
                                      BorderRadius.circular(2),
                                ),
                                margin:
                                    const EdgeInsets.only(right: 12),
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Storyboard',
                                    style: TextStyle(
                                      fontSize: isMobile ? 18 : 22,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_scenes.length} scenes generated',
                                    style: TextStyle(
                                      fontSize: isMobile ? 12 : 13,
                                      color: AppColors.textMuted,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          GridView.count(
                            crossAxisCount: isMobile ? 1 : 2,
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: isMobile ? 12 : 16,
                            crossAxisSpacing: isMobile ? 12 : 16,
                            childAspectRatio:
                                isMobile ? 1.2 : 1.1,
                            children: _scenes
                                .map((s) => _buildSceneCard(s))
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),

                      // Soundtrack Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppColors.accentTeal,
                                  borderRadius:
                                      BorderRadius.circular(2),
                                ),
                                margin:
                                    const EdgeInsets.only(right: 12),
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Soundtrack',
                                    style: TextStyle(
                                      fontSize: isMobile ? 18 : 22,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Adaptive music generated for your story',
                                    style: TextStyle(
                                      fontSize: isMobile ? 12 : 13,
                                      color: AppColors.textMuted,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          GridView.count(
                            crossAxisCount: isMobile ? 1 : 2,
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: isMobile ? 12 : 16,
                            crossAxisSpacing: isMobile ? 12 : 16,
                            childAspectRatio:
                                isMobile ? 3.5 : 4.0,
                            children: _soundtracks
                                .map((t) => _buildSoundtrackCard(t))
                                .toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),

                      // Download & Share buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.download_rounded,
                                size: 18,
                              ),
                              label: Text(
                                'Download',
                                style: TextStyle(
                                  fontSize: isMobile ? 12 : 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.share_rounded,
                                size: 18,
                              ),
                              label: Text(
                                'Share',
                                style: TextStyle(
                                  fontSize: isMobile ? 12 : 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
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
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  static Widget _buildSceneCard(Map<String, dynamic> scene) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (scene['typeColor'] as Color).withValues(alpha: 0.15),
                  (scene['moodColor'] as Color).withValues(alpha: 0.08),
                ],
              ),
              color: AppColors.bgSurface,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  scene['type'] == 'VIDEO'
                      ? Icons.videocam_rounded
                      : Icons.image_rounded,
                  color: AppColors.textMuted.withValues(alpha: 0.35),
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'Generated ${scene['type'] == 'VIDEO' ? 'Video' : 'Image'}',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted.withValues(alpha: 0.5),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accentPink.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Scene ${scene['number']}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentPink,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (scene['typeColor'] as Color)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: (scene['typeColor'] as Color)
                          .withValues(alpha: 0.25),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    scene['type'] as String,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: scene['typeColor'] as Color,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: Text(
              scene['title'] as String,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 3,
                  height: 32,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: scene['moodColor'] as Color,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
                Expanded(
                  child: Text(
                    '"${scene['narration']}"',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (scene['moodColor'] as Color)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: (scene['moodColor'] as Color)
                      .withValues(alpha: 0.25),
                  width: 0.5,
                ),
              ),
              child: Text(
                scene['mood'] as String,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: scene['moodColor'] as Color,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSoundtrackCard(Map<String, dynamic> track) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            spreadRadius: 0.5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: (track['color'] as Color)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: (track['color'] as Color)
                        .withValues(alpha: 0.25),
                    width: 0.5,
                  ),
                ),
                child: Icon(Icons.play_arrow_rounded,
                    color: track['color'] as Color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track['title'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      track['duration'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          WaveformBar(
            isAnimating: false,
            barCount: 35,
            height: 24,
            color: track['color'] as Color,
          ),
        ],
      ),
    );
  }
}