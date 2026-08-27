import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../auth/presentation/widgets/glass_container.dart';

class AIPredictionCard extends StatelessWidget {
  final String rushStatus;
  final String optimalTime;
  final double confidenceScore;

  const AIPredictionCard({
    super.key,
    required this.rushStatus,
    required this.optimalTime,
    this.confidenceScore = 0.94,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with AI Sparkles Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryCyan.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryCyan.withValues(alpha: 0.3)),
                    ),
                    child: const Icon(LucideIcons.sparkles, color: AppColors.primaryCyan, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SmartQ AI 2.0 Engine',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Real-Time Queue Analytics',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
                ),
                child: Text(
                  '${(confidenceScore * 100).toInt()}% Accurate',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Rush indicator bar
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Traffic Density',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        rushStatus,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Mini Wave Visualiser
                Row(
                  children: List.generate(5, (index) {
                    final heights = [14.0, 24.0, 36.0, 20.0, 10.0];
                    final isHighlighted = index < 3;
                    return Container(
                      width: 6,
                      height: heights[index],
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: isHighlighted
                            ? AppColors.primaryCyan
                            : AppColors.textMuted.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                     .scaleY(duration: (800 + (index * 200)).ms, begin: 0.7, end: 1.2);
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Recommended Time Slot Row
          Row(
            children: [
              const Icon(LucideIcons.clock, color: AppColors.primaryCyan, size: 16),
              const SizedBox(width: 8),
              Text(
                'AI Optimal Visit Time: ',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              Expanded(
                child: Text(
                  optimalTime,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryCyan,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
