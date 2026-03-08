import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_theme.dart';

class WaveformBar extends StatefulWidget {
  final bool isAnimating;
  final int barCount;
  final double height;
  final Color color;

  const WaveformBar({
    super.key,
    this.isAnimating = false,
    this.barCount = 30,
    this.height = 40,
    this.color = AppColors.accentWarm,
  });

  @override
  State<WaveformBar> createState() => _WaveformBarState();
}

class _WaveformBarState extends State<WaveformBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();
  late List<double> _heights;

  @override
  void initState() {
    super.initState();
    _heights = List.generate(widget.barCount, (_) => _random.nextDouble());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..addListener(() {
        if (widget.isAnimating) {
          setState(() {
            _heights = List.generate(
              widget.barCount,
              (_) => 0.2 + _random.nextDouble() * 0.8,
            );
          });
        }
      });
    if (widget.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(WaveformBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isAnimating && _controller.isAnimating) {
      _controller.stop();
      setState(() {
        _heights = List.generate(widget.barCount, (_) => _random.nextDouble());
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(widget.barCount, (i) {
          return Container(
            width: 3,
            height: widget.height * _heights[i],
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: widget.color.withValues(
                alpha: 0.4 + _heights[i] * 0.6,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}

/// Scene timeline — matches web .timeline styling
class SceneTimeline extends StatelessWidget {
  final int sceneCount;
  final int activeScene;
  final Function(int) onSceneTap;

  const SceneTimeline({
    super.key,
    required this.sceneCount,
    required this.activeScene,
    required this.onSceneTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: sceneCount + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == sceneCount) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.bgSecondary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: const Icon(Icons.add, color: AppColors.textMuted, size: 18),
              ),
            );
          }
          final isActive = index == activeScene;
          return GestureDetector(
            onTap: () => onSceneTap(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: isActive ? AppColors.primaryGradient : null,
                color: isActive ? null : AppColors.bgSecondary,
                borderRadius: BorderRadius.circular(10),
                border: isActive
                    ? null
                    : Border.all(color: AppColors.borderSubtle),
              ),
              alignment: Alignment.center,
              child: Text(
                'Scene ${index + 1}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppColors.bgPrimary : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
