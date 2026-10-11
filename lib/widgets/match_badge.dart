import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Petit badge circulaire affichant le pourcentage d'ingrédients disponibles
/// pour une recette.
class MatchBadge extends StatelessWidget {
  final int percent;

  const MatchBadge({super.key, required this.percent});

  Color get _color {
    if (percent >= 80) return AppTheme.primaryGreen;
    if (percent >= 40) return AppTheme.accentOrange;
    return const Color(0xFFB0594B);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: _color.withOpacity(0.12),
        shape: BoxShape.circle,
        border: Border.all(color: _color, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        '$percent%',
        style: TextStyle(
          color: _color,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }
}
