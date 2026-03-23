import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:zeroed/core/router/app_router.dart';
import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';
import 'package:zeroed/shared/widgets/app_fab.dart';

/// Bottom navigation bar with pill-style tabs and gradient fade.
///
/// Matches design component: BottomNav (1bUaU)
class BottomNavShell extends StatelessWidget {
  const BottomNavShell({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.child,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final Widget child;

  static const _tabs = [
    _TabItem(icon: LucideIcons.layoutDashboard, label: 'DASHBOARD'),
    _TabItem(icon: LucideIcons.users, label: 'CLIENTS'),
    _TabItem(icon: LucideIcons.settings, label: 'SETTINGS'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      floatingActionButton: currentIndex == 0
          ? AppFab(
              onPressed: () => context.router.push(const CreateInvoiceRoute()),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x000A0F1C), // transparent
              Color(0xFF0A0F1C), // bgPrimary
            ],
            stops: [0.0, 0.4],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(21, AppSpacing.md, 21, 21),
        child: Container(
          height: AppSizing.navBarHeight,
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(AppRadius.navPill),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: List.generate(_tabs.length, (i) {
              final isActive = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onTap(i);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.accent : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.navTab),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _tabs[i].icon,
                          size: AppSizing.iconMd,
                          color: isActive
                              ? AppColors.textInverted
                              : AppColors.textMuted,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          _tabs[i].label,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.w500,
                            letterSpacing: 0.5,
                            color: isActive
                                ? AppColors.textInverted
                                : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _TabItem {
  const _TabItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
