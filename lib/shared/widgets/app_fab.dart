import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';

/// Floating action button with accent glow and scale animation on tap.
///
/// Matches design component: FAB (c0y4p)
class AppFab extends StatefulWidget {
  const AppFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  State<AppFab> createState() => _AppFabState();
}

class _AppFabState extends State<AppFab> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();
  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
    HapticFeedback.lightImpact();
    widget.onPressed();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: AppSizing.fabSize,
        height: AppSizing.fabSize,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: AppRadius.fabBorder,
          boxShadow: const [
            BoxShadow(
              color: Color(0x4022D3EE),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: Icon(
              LucideIcons.plus,
              size: AppSizing.iconLg,
              color: AppColors.textInverted,
            ),
          ),
        ),
      ),
    );
  }
}
