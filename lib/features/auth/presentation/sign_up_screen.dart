import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';
import 'package:zeroed/core/theme/app_text_styles.dart';
import 'package:zeroed/features/auth/presentation/auth_view_model.dart';
import 'package:zeroed/shared/widgets/app_button.dart';
import 'package:zeroed/shared/widgets/app_text_field.dart';

@RoutePage()
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) return;

    ref.read(authViewModelProvider.notifier).signUp(
          email: email,
          password: password,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen(authViewModelProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.toString()),
              backgroundColor: AppColors.statusOverdue,
            ),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.authPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      _buildBrand(),
                      const SizedBox(height: 40),
                      _buildForm(authState),
                    ],
                  ),
                ),
              ),
              _buildBottomLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrand() {
    return Column(
      children: [
        Text(
          'ZEROED',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            letterSpacing: 4,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Start getting paid today.',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(AsyncValue<void> authState) {
    return Column(
      children: [
        AppTextField(
          controller: _nameController,
          label: 'Full Name',
          hintText: 'Your full name',
          prefixIcon: LucideIcons.user,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          controller: _emailController,
          label: 'Email',
          hintText: 'you@email.com',
          prefixIcon: LucideIcons.mail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          controller: _passwordController,
          label: 'Password',
          hintText: '••••••••',
          helperText: 'Must be at least 8 characters',
          prefixIcon: LucideIcons.lock,
          suffixIcon:
              _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
          onSuffixTap: () =>
              setState(() => _obscurePassword = !_obscurePassword),
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _handleSignUp(),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: 'Create Account',
          onPressed: _handleSignUp,
          isLoading: authState.isLoading,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildDivider(),
        const SizedBox(height: AppSpacing.lg),
        _buildSocialButtons(),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'By signing up, you agree to our Terms of Service and Privacy Policy.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppColors.textTertiary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'or',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Column(
      children: [
        _SocialButton(
          label: 'Google',
          leading: Text(
            'G',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          onTap: () {
            // TODO: Google sign up
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _SocialButton(
          label: 'Apple',
          leading: Icon(
            LucideIcons.apple,
            size: 20,
            color: AppColors.textPrimary,
          ),
          onTap: () {
            // TODO: Apple sign up
          },
        ),
      ],
    );
  }

  Widget _buildBottomLink() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account?',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          GestureDetector(
            onTap: () => context.router.maybePop(),
            child: Text('Sign In', style: AppTextStyles.link),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.leading,
    required this.onTap,
  });

  final String label;
  final Widget leading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppSizing.inputHeightLg,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: AppRadius.inputBorder,
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
