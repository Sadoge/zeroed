import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_text_styles.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Settings', style: AppTextStyles.heading1),
      ),
      backgroundColor: AppColors.bgPrimary,
    );
  }
}
