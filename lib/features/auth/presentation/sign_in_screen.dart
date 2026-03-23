import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:zeroed/core/router/app_router.dart';
import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';
import 'package:zeroed/core/theme/app_text_styles.dart';
import 'package:zeroed/features/auth/presentation/auth_view_model.dart';
import 'package:zeroed/shared/widgets/app_button.dart';
import 'package:zeroed/shared/widgets/app_text_field.dart';

@RoutePage()
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) return;

    ref.read(authViewModelProvider.notifier).signIn(
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
              // Top: brand + form
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

              // Bottom: sign up link
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
          'Freelance invoicing, simplified.',
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
          labelTrailing: GestureDetector(
            onTap: () {
              // TODO: forgot password flow
            },
            child: Text('Forgot?', style: AppTextStyles.link.copyWith(fontSize: 12)),
          ),
          hintText: '••••••••',
          prefixIcon: LucideIcons.lock,
          suffixIcon:
              _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
          onSuffixTap: () =>
              setState(() => _obscurePassword = !_obscurePassword),
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _handleSignIn(),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: 'Sign In',
          onPressed: _handleSignIn,
          isLoading: authState.isLoading,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildDivider(),
        const SizedBox(height: AppSpacing.lg),
        _buildSocialButtons(),
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
            // TODO: Google sign in
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
            // TODO: Apple sign in
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
            "Don't have an account?",
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          GestureDetector(
            onTap: () => context.router.push(const SignUpRoute()),
            child: Text('Sign Up', style: AppTextStyles.link),
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
