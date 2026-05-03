/*
* Created by Connel Asikong on 02/05/2026
*
*/

import 'package:flutter/material.dart';

import '../../../../../core/util/hashpact_theme.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key, required this.name});

  final String name;

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Color get _color {
    final colors = [
      AppColors.primary,
      AppColors.accent,
      AppColors.success,
      AppColors.warning,
      const Color(0xFF9C6BFF),
      const Color(0xFFFF6B9C),
    ];
    final i = name.codeUnits.fold(0, (a, b) => a + b) % colors.length;
    return colors[i];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _color.withValues(alpha: 0.15),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Center(
        child: Text(
          _initials,
          style: AppTextStyles.buttonText.copyWith(color: _color, fontSize: 16),
        ),
      ),
    );
  }
}
