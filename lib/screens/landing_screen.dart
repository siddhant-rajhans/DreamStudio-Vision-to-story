import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/gradient_badge.dart';
import '../widgets/feature_card.dart';
import '../widgets/stat_card.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              backgroundColor: AppColors.bgPrimary.withValues(alpha: 0.95),
              title: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: AppColors.bgPrimary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'StoryLine',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentPink,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/studio'),
                  child: const Text('Studio',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // Hackathon badge
                    const GradientBadge(
                      text: 'GOOGLE CLOUD × GEMINI AI HACKATHON 2026',
                      colors: [AppColors.accentGold],
                      fontSize: 10,
                    ),
                    const SizedBox(height: 24),

                    // Hero Title
                    Text(
                      'Direct Stories with Your',
                      style: AppTextStyles.heroTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const GradientText(
                      text: 'Voice & Vision',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subtitle
                    Text(
                      'Transform spoken words and camera into cinematic stories with AI imagery, video, and music.',
                      style: AppTextStyles.bodyText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // CTA Buttons
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/studio'),
                        icon: const Icon(Icons.play_arrow_rounded, size: 20),
                        label: const Text('Start Directing'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Text('See How It Works'),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Stats Row
                    Row(
                      children: [
                        _buildStatItem('<5s', 'IMAGE GEN'),
                        _divider(),
                        _buildStatItem('Real-time', 'VOICE+VISION'),
                        _divider(),
                        _buildStatItem('5', 'AI MODELS'),
                      ],
                    ),
                    const SizedBox(height: 48),

                    // Browser Mockup
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          // Browser dots
                          Row(
                            children: [
                              _dot(const Color(0xFFff5f57)),
                              const SizedBox(width: 6),
                              _dot(const Color(0xFFfebc2e)),
                              const SizedBox(width: 6),
                              _dot(const Color(0xFF28c840)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  height: 24,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.bgPrimary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    'storyline.app/studio',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Mockup content
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: AppColors.bgPrimary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                // Top bar
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: AppColors.border, width: 1),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('StoryLine',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.accentPink)),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.accentPurple
                                              .withValues(alpha: 0.2),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'Mood: Mysterious',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: AppColors.accentPurple),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Expanded(
                                  child: Center(
                                    child: Text(
                                      'Your story unfolds here...',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textMuted,
                                        fontStyle: FontStyle.italic,
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
                    const SizedBox(height: 60),

                    // Features Section
                    _sectionHeader('FEATURES', 'Powered by Google\'s\nLatest AI Models'),
                    const SizedBox(height: 24),

                    FeatureCard(
                      icon: Icons.record_voice_over_rounded,
                      iconColor: AppColors.accentPink,
                      title: 'Voice Direction',
                      description:
                          'Narrate your story naturally. Gemini understands your creative intent in real-time.',
                      modelBadge: 'GEMINI 2.5',
                    ),
                    const SizedBox(height: 12),
                    FeatureCard(
                      icon: Icons.image_rounded,
                      iconColor: AppColors.accentGold,
                      title: 'Instant Storyboards',
                      description:
                          'AI generates cinematic images from your narration in under 5 seconds.',
                      modelBadge: 'IMAGEN 4',
                    ),
                    const SizedBox(height: 12),
                    FeatureCard(
                      icon: Icons.videocam_rounded,
                      iconColor: AppColors.accentPurple,
                      title: 'Video Generation',
                      description:
                          'Transform scenes into video clips with AI-powered generation.',
                      modelBadge: 'VEO 3.1',
                    ),
                    const SizedBox(height: 12),
                    FeatureCard(
                      icon: Icons.music_note_rounded,
                      iconColor: AppColors.accentTeal,
                      title: 'Adaptive Music',
                      description:
                          'AI composes mood-matching background music as your story unfolds.',
                      modelBadge: 'LYRIA 2',
                    ),
                    const SizedBox(height: 12),
                    FeatureCard(
                      icon: Icons.camera_alt_rounded,
                      iconColor: AppColors.accentGreen,
                      title: 'Camera Input',
                      description:
                          'Show real objects to inspire your story. AI sees and integrates them.',
                      modelBadge: 'VISION',
                    ),
                    const SizedBox(height: 12),
                    FeatureCard(
                      icon: Icons.search_rounded,
                      iconColor: AppColors.accentOrange,
                      title: 'Live Research',
                      description:
                          'Ground your story in real facts with integrated search.',
                      modelBadge: 'SEARCH',
                    ),
                    const SizedBox(height: 60),

                    // How it Works
                    _sectionHeader('HOW IT WORKS', 'Four Steps to Your Story'),
                    const SizedBox(height: 24),

                    StepCard(
                      number: '1',
                      title: 'Set the Scene',
                      description:
                          'Describe your world, show objects via camera, set the mood.',
                      icon: Icons.landscape_rounded,
                    ),
                    const SizedBox(height: 12),
                    StepCard(
                      number: '2',
                      title: 'Narrate',
                      description:
                          'Speak naturally. AI captures your words and creative direction.',
                      icon: Icons.mic_rounded,
                    ),
                    const SizedBox(height: 12),
                    StepCard(
                      number: '3',
                      title: 'AI Creates',
                      description:
                          'Watch as images, video, and music materialize from your narration.',
                      icon: Icons.auto_awesome_rounded,
                    ),
                    const SizedBox(height: 12),
                    StepCard(
                      number: '4',
                      title: 'Review & Share',
                      description:
                          'Review your complete story, refine scenes, then download or share.',
                      icon: Icons.share_rounded,
                    ),
                    const SizedBox(height: 60),

                    // Tech Stack
                    _sectionHeader('TECH STACK', 'Built on Google Cloud'),
                    const SizedBox(height: 24),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.4,
                      children: [
                        TechBadge(
                          name: 'Gemini 2.5 Flash',
                          detail: 'Native Audio',
                          icon: Icons.flash_on_rounded,
                          color: AppColors.accentPink,
                        ),
                        TechBadge(
                          name: 'Imagen 4',
                          detail: 'Image Gen',
                          icon: Icons.image_rounded,
                          color: AppColors.accentGold,
                        ),
                        TechBadge(
                          name: 'Veo 3.1',
                          detail: 'Video Gen',
                          icon: Icons.videocam_rounded,
                          color: AppColors.accentPurple,
                        ),
                        TechBadge(
                          name: 'Lyria 2',
                          detail: 'Music Gen',
                          icon: Icons.music_note_rounded,
                          color: AppColors.accentTeal,
                        ),
                        TechBadge(
                          name: 'Google ADK',
                          detail: 'Agent Framework',
                          icon: Icons.smart_toy_rounded,
                          color: AppColors.accentGreen,
                        ),
                        TechBadge(
                          name: 'Cloud Run',
                          detail: 'Serverless',
                          icon: Icons.cloud_rounded,
                          color: AppColors.accentOrange,
                        ),
                        TechBadge(
                          name: 'Cloud Storage',
                          detail: 'Asset CDN',
                          icon: Icons.storage_rounded,
                          color: AppColors.accentPink,
                        ),
                        TechBadge(
                          name: 'FastAPI',
                          detail: 'WebSocket Server',
                          icon: Icons.bolt_rounded,
                          color: AppColors.accentRed,
                        ),
                      ],
                    ),
                    const SizedBox(height: 60),

                    // Team Section
                    _sectionHeader('TEAM', 'Columbia University'),
                    const SizedBox(height: 24),

                    ..._buildTeamCards(),
                    const SizedBox(height: 60),

                    // CTA Section
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.accentPink.withValues(alpha: 0.15),
                            AppColors.accentGold.withValues(alpha: 0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.accentPink.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Ready to Direct\nYour Story?',
                            style: AppTextStyles.sectionTitle,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Start creating with just your voice and vision.',
                            style: AppTextStyles.bodyText,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/studio'),
                              icon: const Icon(Icons.play_arrow_rounded),
                              label: const Text('Start Directing'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Footer
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.play_arrow_rounded,
                              color: AppColors.bgPrimary, size: 14),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'StoryLine',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentPink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Built for Google Cloud × Gemini AI Hackathon 2026\nColumbia University',
                      style: AppTextStyles.caption,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _sectionHeader(String label, String title) {
    return Column(
      children: [
        GradientBadge(text: label, fontSize: 10),
        const SizedBox(height: 12),
        Text(
          title,
          style: AppTextStyles.sectionTitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  static Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }

  static Widget _divider() {
    return Container(width: 1, height: 32, color: AppColors.border);
  }

  static Widget _dot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  static List<Widget> _buildTeamCards() {
    final members = [
      {'name': 'Team Lead', 'role': 'Full-Stack & AI', 'emoji': '🎬'},
      {'name': 'ML Engineer', 'role': 'Gemini & ADK', 'emoji': '🤖'},
      {'name': 'Frontend Dev', 'role': 'UI/UX & Audio', 'emoji': '🎨'},
      {'name': 'Cloud Architect', 'role': 'GCP & Deploy', 'emoji': '☁️'},
    ];
    return members.map((m) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(m['emoji']!, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m['name']!, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 2),
                  Text(m['role']!, style: AppTextStyles.bodyText),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}