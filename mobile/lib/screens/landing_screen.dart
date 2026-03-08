import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            // NAV — matches web .nav
            SliverAppBar(
              floating: true,
              backgroundColor: AppColors.bgPrimary.withValues(alpha: 0.95),
              title: Row(
                children: [
                  // Logo circle — matches web nav SVG
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 1.5,
                        color: AppColors.accentWarm,
                      ),
                    ),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: AppColors.accentWarm, size: 16),
                  ),
                  const SizedBox(width: 8),
                  // Brand — web: Playfair Display, gradient text
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.primaryGradient
                        .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                    child: Text('StoryLine',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
              actions: [
                // CTA button — matches web .nav-cta
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/studio'),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.accentWarm,
                      foregroundColor: AppColors.bgPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Text('Launch Studio',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ),
              ],
            ),

            // HERO — matches web .hero section
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  // Background orbs — web: .hero-orb
                  Positioned(
                    top: -80,
                    left: -80,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accentWarm.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: -60,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accentPink.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 48),
                        // Badge — web: .hero-badge
                        const HeroBadge(
                            text: 'Google Cloud x Gemini AI Hackathon — Columbia University 2026'),
                        const SizedBox(height: 24),
                        // Title — web: .hero-title with Playfair Display
                        Text(
                          'Direct Stories with',
                          style: AppTextStyles.heroTitle,
                          textAlign: TextAlign.center,
                        ),
                        // Gradient part — web: .hero-gradient
                        GradientText(
                          text: 'Your Voice & Vision',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Subtitle — web: .hero-subtitle
                        Text(
                          'StoryLine transforms your spoken words and camera feed into a cinematic story experience — complete with AI-generated imagery, video clips, and ambient music, all in real-time.',
                          style: AppTextStyles.subtitle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        // CTA — web: .btn-primary
                        _GradientButton(
                          label: 'Start Directing',
                          icon: Icons.play_arrow_rounded,
                          onTap: () => Navigator.pushNamed(context, '/studio'),
                        ),
                        const SizedBox(height: 12),
                        // Ghost button — web: .btn-ghost
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {},
                            child: Text('See How It Works',
                                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500)),
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Stats — web: .hero-stats
                        Row(
                          children: const [
                            HeroStat(value: '<5s', label: 'Image Gen'),
                            StatDivider(),
                            HeroStat(value: 'Real-time', label: 'Voice + Vision'),
                            StatDivider(),
                            HeroStat(value: '5', label: 'AI Models'),
                          ],
                        ),
                        const SizedBox(height: 36),
                        // Browser mockup — matches web .mockup-browser
                        _BrowserMockup(),
                        const SizedBox(height: 56),

                        // FEATURES — web: #features section
                        _SectionHeader(tag: 'FEATURES', title: 'Five AI Models, One Story'),
                        const SizedBox(height: 24),
                        ..._featureCards(),
                        const SizedBox(height: 56),

                        // HOW IT WORKS — web: #how-it-works, bg: bgSecondary
                        _SectionHeader(tag: 'HOW IT WORKS', title: 'From Voice to Vision in Seconds'),
                        const SizedBox(height: 24),
                        ..._howItWorksSteps(),
                        const SizedBox(height: 56),

                        // TECH STACK — web: #tech
                        _SectionHeader(tag: 'TECHNOLOGY', title: 'Built on Google Cloud'),
                        const SizedBox(height: 24),
                        ..._techCards(),
                        const SizedBox(height: 56),

                        // TEAM — web: #team
                        _SectionHeader(tag: 'TEAM', title: 'Meet the Creators'),
                        const SizedBox(height: 24),
                        ..._teamCards(),
                        const SizedBox(height: 56),

                        // CTA — web: .cta-section
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: AppColors.bgPrimary,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: Column(
                            children: [
                              Text('Ready to Direct\nYour Story?',
                                  style: AppTextStyles.sectionTitle,
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 12),
                              Text(
                                'Launch the studio and start creating with AI in real-time.',
                                style: AppTextStyles.bodyText,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              _GradientButton(
                                label: 'Open Story Studio',
                                icon: Icons.play_arrow_rounded,
                                onTap: () => Navigator.pushNamed(context, '/studio'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        // FOOTER — web: .footer
                        Divider(color: AppColors.borderSubtle, height: 1),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 20, height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.accentWarm, width: 1.5),
                              ),
                              child: const Icon(Icons.play_arrow_rounded,
                                  color: AppColors.accentWarm, size: 12),
                            ),
                            const SizedBox(width: 6),
                            ShaderMask(
                              shaderCallback: (bounds) => AppColors.primaryGradient
                                  .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                              child: Text('StoryLine',
                                  style: GoogleFonts.playfairDisplay(
                                      fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Built for Google Cloud x Gemini AI Hackathon 2026 · Columbia University',
                          style: AppTextStyles.caption,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                      ],
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

  static List<Widget> _featureCards() {
    const features = [
      {'icon': Icons.mic_rounded, 'color': 0xFFE8A87C, 'title': 'Real-Time Voice Dialogue',
       'desc': 'Talk naturally with your AI co-director. It listens, responds, and shapes the story based on your voice.', 'model': 'Gemini 2.5 Flash · Native Audio'},
      {'icon': Icons.image_rounded, 'color': 0xFFD4789C, 'title': 'Instant Storyboard Art',
       'desc': 'Scene descriptions become stunning AI-generated images in under 5 seconds.', 'model': 'Imagen 4'},
      {'icon': Icons.videocam_rounded, 'color': 0xFF6C8EBF, 'title': 'AI Video Clips',
       'desc': 'Key moments come alive as short video clips, automatically generated for dramatic scenes.', 'model': 'Veo 3.1'},
      {'icon': Icons.music_note_rounded, 'color': 0xFF7BC47F, 'title': 'Ambient Soundtrack',
       'desc': 'AI-composed music that adapts to your story\'s mood — from suspense to triumph.', 'model': 'Lyria 2'},
      {'icon': Icons.language_rounded, 'color': 0xFFE07070, 'title': 'Camera Vision',
       'desc': 'Show objects through your camera. The AI sees them and weaves what it sees into the narrative.', 'model': 'Gemini Live Vision'},
      {'icon': Icons.search_rounded, 'color': 0xFFE8A87C, 'title': 'Web Grounding',
       'desc': 'The AI searches the web for real facts and references to weave into your fiction.', 'model': 'Google Search'},
    ];
    return features.map((f) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FeatureCard(
        icon: f['icon'] as IconData,
        iconColor: Color(f['color'] as int),
        title: f['title'] as String,
        description: f['desc'] as String,
        modelBadge: f['model'] as String,
      ),
    )).toList();
  }

  static List<Widget> _howItWorksSteps() {
    const steps = [
      {'num': '1', 'title': 'Speak Your Story', 'desc': 'Describe a scene, set the mood, or introduce a character. The AI listens through a real-time audio stream.', 'icon': Icons.mic_rounded, 'color': 0xFFE8A87C},
      {'num': '2', 'title': 'AI Generates Media', 'desc': 'The StoryDirector agent calls Imagen, Veo, and Lyria to create images, clips, and music.', 'icon': Icons.image_rounded, 'color': 0xFFD4789C},
      {'num': '3', 'title': 'Watch It Unfold', 'desc': 'Generated art, video, and narration appear on your cinematic canvas with smooth transitions.', 'icon': Icons.play_arrow_rounded, 'color': 0xFF6C8EBF},
      {'num': '4', 'title': 'Collaborate & Iterate', 'desc': 'Change direction, add twists, show props on camera. The story evolves with every interaction.', 'icon': Icons.refresh_rounded, 'color': 0xFF7BC47F},
    ];
    final widgets = <Widget>[];
    for (var i = 0; i < steps.length; i++) {
      final s = steps[i];
      widgets.add(StepCard(
        number: s['num'] as String,
        title: s['title'] as String,
        description: s['desc'] as String,
        icon: s['icon'] as IconData,
        iconColor: Color(s['color'] as int),
      ));
      if (i < steps.length - 1) widgets.add(const StepConnector());
    }
    return widgets;
  }

  static List<Widget> _techCards() {
    const techs = [
      ['Voice + Vision', 'Gemini 2.5 Flash', 'Native audio mode with bidi-streaming'],
      ['Image Gen', 'Imagen 4', 'Cinematic storyboard art in <5s'],
      ['Video Gen', 'Veo 3.1', 'Short clips for key story moments'],
      ['Music Gen', 'Lyria 2', 'Mood-adaptive ambient soundtrack'],
      ['Agent Framework', 'Google ADK', 'Tool orchestration + session state'],
      ['Backend', 'FastAPI', 'WebSocket server on Cloud Run'],
      ['Storage', 'Cloud Storage', 'Media asset persistence'],
      ['Search', 'Google Search', 'Real-world fact grounding'],
    ];
    final rows = <Widget>[];
    for (var i = 0; i < techs.length; i += 2) {
      rows.add(Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(child: TechCard(label: techs[i][0], name: techs[i][1], detail: techs[i][2])),
            const SizedBox(width: 10),
            Expanded(child: TechCard(label: techs[i + 1][0], name: techs[i + 1][1], detail: techs[i + 1][2])),
          ],
        ),
      ));
    }
    return rows;
  }

  static List<Widget> _teamCards() {
    const members = [
      ['Agent Engineer', 'ADK agent design, tool orchestration, prompt engineering', 0xFFE8A87C],
      ['Backend Engineer', 'FastAPI WebSocket server, Cloud Run deployment, GCS', 0xFFD4789C],
      ['Frontend Engineer', 'Cinematic UI, AudioWorklet, camera integration', 0xFF6C8EBF],
      ['Creative Director', 'Story design, UX flow, demo narrative, presentation', 0xFF7BC47F],
    ];
    final rows = <Widget>[];
    for (var i = 0; i < members.length; i += 2) {
      rows.add(Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Expanded(child: TeamCard(
              role: members[i][0] as String,
              description: members[i][1] as String,
              accentColor: Color(members[i][2] as int),
            )),
            const SizedBox(width: 12),
            Expanded(child: TeamCard(
              role: members[i + 1][0] as String,
              description: members[i + 1][1] as String,
              accentColor: Color(members[i + 1][2] as int),
            )),
          ],
        ),
      ));
    }
    return rows;
  }
}

/// Section header — matches web .section-header (.section-tag + .section-title)
class _SectionHeader extends StatelessWidget {
  final String tag;
  final String title;
  const _SectionHeader({required this.tag, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(tag, style: AppTextStyles.sectionTag),
        const SizedBox(height: 8),
        Text(title, style: AppTextStyles.sectionTitle, textAlign: TextAlign.center),
      ],
    );
  }
}

/// Gradient button — matches web .btn-primary with gradient background
class _GradientButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _GradientButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: AppColors.bgPrimary, size: 20),
                  const SizedBox(width: 8),
                  Text(label, style: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.bgPrimary,
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Browser mockup — matches web .mockup-browser
class _BrowserMockup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 32, offset: const Offset(0, 8)),
          BoxShadow(color: AppColors.accentWarm.withValues(alpha: 0.04), blurRadius: 60),
        ],
      ),
      child: Column(
        children: [
          // Chrome bar — web: .mockup-bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.bgElevated,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: Row(
              children: [
                _dot(const Color(0xFFE07070)),
                const SizedBox(width: 6),
                _dot(const Color(0xFFE8A87C)),
                const SizedBox(width: 6),
                _dot(const Color(0xFF7BC47F)),
                const SizedBox(width: 12),
                Expanded(
                  child: Center(
                    child: Text('storyline.app/studio',
                        style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted)),
                  ),
                ),
              ],
            ),
          ),
          // Top bar — web: .mockup-topbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: Row(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => AppColors.primaryGradient
                      .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                  child: Text('StoryLine',
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.2)),
                  ),
                  child: Text('Mood: Mysterious',
                      style: GoogleFonts.inter(fontSize: 9, color: AppColors.accentBlue)),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppColors.accentGreen.withValues(alpha: 0.5), blurRadius: 6)],
                  ),
                ),
              ],
            ),
          ),
          // Canvas — web: .mockup-canvas
          Container(
            height: 100,
            width: double.infinity,
            color: AppColors.bgPrimary,
            child: Stack(
              children: [
                Center(child: Text('Your story unfolds here...',
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted))),
                Positioned(
                  bottom: 8, left: 16, right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.bgOverlay,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Text(
                      '"The fog rolls in, revealing a city that shouldn\'t exist..."',
                      style: GoogleFonts.inter(
                          fontSize: 10, fontStyle: FontStyle.italic, color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Timeline — web: .mockup-timeline
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              border: Border(top: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: Row(
              children: List.generate(4, (i) => Container(
                width: 48, height: 24,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: AppColors.bgElevated,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: i == 0 ? AppColors.accentWarm : Colors.transparent),
                ),
              )),
            ),
          ),
          // Controls — web: .mockup-controls
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.bgSecondary,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              border: Border(top: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: Row(
              children: [
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accentWarm.withValues(alpha: 0.15),
                    border: Border.all(color: AppColors.accentWarm),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 60, height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.bgElevated,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.bgElevated,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderSubtle),
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

  static Widget _dot(Color c) =>
      Container(width: 8, height: 8, decoration: BoxDecoration(color: c, shape: BoxShape.circle));
}
