import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:zeroed/core/router/app_router.dart';
import 'package:zeroed/core/services/hive_service.dart';
import 'package:zeroed/core/services/stripe_service.dart';
import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';
import 'package:zeroed/shared/widgets/app_text_field.dart';

/// Key used in Hive settings box to track onboarding completion.
const kOnboardingComplete = 'onboarding_complete';

@RoutePage()
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _businessNameCtrl = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _businessNameCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    HiveService.instance
        .settingsBox
        .put(kOnboardingComplete, 'true');
    context.router.replaceAll([const MainShellRoute()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _Page1(),
                  _Page2(businessNameCtrl: _businessNameCtrl),
                  _Page3(ref: ref),
                ],
              ),
            ),
            _buildBottom(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottom() {
    final isLastPage = _currentPage == 2;
    final skipTexts = ['Skip', "I'll do this later", 'Skip for now'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      child: Column(
        children: [
          // Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              final isActive = i == _currentPage;
              return Container(
                width: isActive ? 8 : 6,
                height: isActive ? 8 : 6,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive ? AppColors.accent : AppColors.textMuted,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Main button
          SizedBox(
            width: double.infinity,
            height: AppSizing.buttonHeight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isLastPage ? const Color(0xFF635BFF) : AppColors.accent,
                foregroundColor:
                    isLastPage ? Colors.white : AppColors.textInverted,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                elevation: 0,
              ),
              onPressed: isLastPage ? _connectStripe : _next,
              child: Text(
                isLastPage ? 'Connect Stripe' : 'Continue',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Skip
          GestureDetector(
            onTap: _skip,
            child: Text(
              skipTexts[_currentPage],
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _connectStripe() async {
    try {
      final url = await ref
          .read(stripeServiceProvider)
          .createConnectOnboardingLink();
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      // Stripe setup can fail — user can retry from Settings
    }
    _completeOnboarding();
  }
}

// ═══════════════════════════════════════════════════════════════
// Page 1: Get Paid Faster
// ═══════════════════════════════════════════════════════════════

class _Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.08),
                  AppColors.accent.withValues(alpha: 0.02),
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Mini invoice card
                Container(
                  width: 180,
                  height: 220,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 32,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'INVOICE',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$2,400.00',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0A0F1C),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(height: 1, color: const Color(0xFFE2E8F0)),
                      const Spacer(),
                      Container(
                        width: double.infinity,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            'Send',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0A0F1C),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Floating send icon
                Positioned(
                  right: 30,
                  top: 50,
                  child: Transform.rotate(
                    angle: -0.26,
                    child: Icon(
                      LucideIcons.send,
                      size: 40,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Get paid faster',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Create professional invoices on your phone\nin under 60 seconds and send them\nwith a payment link.',
            style: GoogleFonts.inter(
              fontSize: 15,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Page 2: Set Up Your Business
// ═══════════════════════════════════════════════════════════════

class _Page2 extends StatelessWidget {
  const _Page2({required this.businessNameCtrl});
  final TextEditingController businessNameCtrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Set up your business',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Add your business info so your invoices\nlook professional from day one.',
            style: GoogleFonts.inter(
              fontSize: 15,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Business name field
          AppTextField(
            controller: businessNameCtrl,
            label: 'Business Name',
            hintText: "e.g. Sarah's Design Studio",
            compact: true,
          ),
          const SizedBox(height: 14),

          // Logo upload area
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Logo (optional)',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.inputBorder,
                  border: Border.all(color: AppColors.bgCard),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.upload,
                      size: 20,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to upload',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Page 3: Connect Payments
// ═══════════════════════════════════════════════════════════════

class _Page3 extends StatelessWidget {
  const _Page3({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.08),
                  AppColors.accent.withValues(alpha: 0.02),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Stripe box
                Container(
                  width: 120,
                  height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFF635BFF),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF635BFF).withValues(alpha: 0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'stripe',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Icon(LucideIcons.arrowDown, size: 24, color: AppColors.accent),
                const SizedBox(height: 12),
                // "You" wallet box
                Container(
                  width: 100,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.bgCard),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.wallet,
                          size: 18, color: AppColors.accent),
                      const SizedBox(width: 6),
                      Text(
                        'You',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Connect payments',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Link your Stripe account so clients can\npay you directly. Funds go straight\nto your bank.',
            style: GoogleFonts.inter(
              fontSize: 15,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
