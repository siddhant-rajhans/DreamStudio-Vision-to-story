import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_theme.dart';

/// Matches web .stat in hero section
class HeroStat extends StatelessWidget {
  final String value;
  final String label;
  const HeroStat({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: GoogleFonts.inter(
            fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary,
          )),
          const SizedBox(height: 2),
          Text(label.toUpperCase(), style: GoogleFonts.inter(
            fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textMuted, letterSpacing: 0.8,
          )),
        ],
      ),
    );
  }
}

/// Vertical divider — web: .stat-divider
class StatDivider extends StatelessWidget {
  const StatDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 28, color: AppColors.borderLight);
  }
}

/// Matches web .tech-card exactly
class TechCard extends StatelessWidget {
  final String label;
  final String name;
  final String detail;
  const TechCard({super.key, required this.label, required this.name, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.toUpperCase(), style: GoogleFonts.inter(
            fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.accentWarm, letterSpacing: 1.2,
          )),
          const SizedBox(height: 6),
          Text(name, style: GoogleFonts.inter(
            fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
          )),
          const SizedBox(height: 4),
          Text(detail, style: GoogleFonts.inter(
            fontSize: 12, color: AppColors.textMuted, height: 1.4,
          )),
        ],
      ),
    );
  }
}

/// Matches web .team-card
class TeamCard extends StatelessWidget {
  final String role;
  final String description;
  final Color accentColor;
  const TeamCard({super.key, required this.role, required this.description, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          Container(
            width: 56, height: 56,
            decoration: const BoxDecoration(color: AppColors.bgElevated, shape: BoxShape.circle),
            child: Icon(Icons.person_outline_rounded, color: accentColor, size: 28),
          ),
          const SizedBox(height: 12),
          Text(role, style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
          const SizedBox(height: 4),
          Text(description, style: AppTextStyles.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// Output screen stat card (for stats like "5 IMAGES")
class OutputStatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const OutputStatCard({super.key, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(value, style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 4),
          Text(label.toUpperCase(), style: GoogleFonts.inter(
            fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 1.5,
          )),
        ],
      ),
    );
  }
}
