import 'package:flutter/material.dart';

class AppColors {
  // Brand Palette
  static const Color primary = Color(0xFF6366F1); // Indigo Primary
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color accent = Color(0xFF10B981); // Emerald Teal Accent
  static const Color warning = Color(0xFFF59E0B); // Amber Warning
  static const Color danger = Color(0xFFEF4444); // Red Danger

  // Dark Theme Colors
  static const Color bgDark = Color(0xFF0F172A); // Deep Slate Navy
  static const Color cardDark = Color(0xFF1E293B); // Dark Slate Card
  static const Color cardBorderDark = Color(0xFF334155);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Light Theme Colors
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardBorderLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient activeTokenGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aiCardGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
