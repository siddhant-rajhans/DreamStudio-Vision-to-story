import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_theme.dart';

/// Matches web .hero-badge styling
class HeroBadge extends StatelessWidget {
  final String text;
  const HeroBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.accentWarm.withValues(alpha: 0.2)),
        color: AppColors.accentWarm.withValues(alpha: 0.08),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.accentWarm,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

/// Matches web .feature-model badge
class ModelBadge extends StatelessWidget {
  final String text;
  final Color? color;
  const ModelBadge({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.accentWarm;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: c.withValues(alpha: 0.15)),
        color: c.withValues(alpha: 0.08),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: c,
        ),
      ),
    );
  }
}

/// Gradient text matching web .hero-gradient
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;
  final TextAlign textAlign;

  const GradientText({
    super.key,
    required this.text,
    required this.style,
    this.gradient = AppColors.primaryGradient,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) =>
          gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(text, style: style.copyWith(color: Colors.white), textAlign: textAlign),
    );
  }
}
