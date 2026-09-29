import 'package:flutter/material.dart';

/// Single source of truth for all colours.
/// Never write Color(0x…) outside this file.
class AppColors {
  // ── Brand palette ─────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF3D5A80);

  /// Lighter tint of primary — used for gradients.
  static const Color primaryLight = Color(0xFF5C7FA8);
  static const Color primarySoft = Color(0xFFE3ECF7);
  static const Color secondary = Color(0xFF2A9D8F);
  static const Color accent = Color(0xFFF4A261);
  static const Color error = Color(0xFFE76F51);

  // ── Scaffold / surface ────────────────────────────────────────────────────
  static const Color background = Color(0xFFFAF7F2);
  static const Color surface = Color(0xFFFFFFFF);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color text = Color(0xFF2B2D42);
  static const Color textSoft = Color(0xFF6B7280);

  // ── Decorative ────────────────────────────────────────────────────────────
  static const Color divider = Color(0xFFE8E2D9);

  // ── Level colours (pastel) ────────────────────────────────────────────────
  static const Color _n5 = Color(0xFF8FD3B6);
  static const Color _n4 = Color(0xFF7FB7E6);
  static const Color _n3 = Color(0xFFA99BE0);
  static const Color _n2 = Color(0xFFF0B36A);
  static const Color _n1 = Color(0xFFE58F9B);

  /// Returns the solid pastel colour for the given JLPT level string.
  static Color level(String? lvl) {
    switch (lvl) {
      case 'N5':
        return _n5;
      case 'N4':
        return _n4;
      case 'N3':
        return _n3;
      case 'N2':
        return _n2;
      case 'N1':
        return _n1;
      default:
        return primary;
    }
  }

  /// Level colour lerped 55 % toward white — soft fill variant.
  static Color levelSoft(String? lvl) =>
      Color.lerp(level(lvl), const Color(0xFFFFFFFF), 0.55)!;
}
