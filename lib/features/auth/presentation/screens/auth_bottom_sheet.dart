import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../providers/auth_provider.dart';

/// Sign-in sheet. Shows the Google entry point when signed out and a
/// gold-ringed profile card with sign-out when signed in.
class AuthBottomSheet extends StatefulWidget {
  const AuthBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.primaryDark.withValues(alpha: 0.5),
      builder: (_) => const AuthBottomSheet(),
    );
  }

  @override
  State<AuthBottomSheet> createState() => _AuthBottomSheetState();
}

class _AuthBottomSheetState extends State<AuthBottomSheet> {
  void _triggerGoogleSignIn(AuthProvider authProvider) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final success = await authProvider.signInWithGoogle(
      email: 'user@gmail.com',
      name: 'MusaFly Traveller',
      photoUrl: 'https://lh3.googleusercontent.com/a/default-user',
      googleId: 'google_${DateTime.now().millisecondsSinceEpoch}',
    );

    if (!mounted) return;

    if (success) {
      navigator.pop();
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(PhosphorIconsFill.checkCircle, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'গুগল দিয়ে সফলভাবে সাইন-ইন সম্পন্ন হয়েছে!',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    final signedIn = authProvider.isAuthenticated && user != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
        boxShadow: AppShadows.elevated,
      ),
      child: SafeArea(
        top: false,
        child: AnimatedPadding(
          duration: AppMotion.fast,
          curve: AppMotion.ease,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxl,
              AppSpacing.md,
              AppSpacing.xxl,
              AppSpacing.xxl + 4,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: AppColors.borderStrong,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                if (signedIn)
                  _SignedInView(
                    name: user.name,
                    email: user.email,
                    loading: authProvider.isLoading,
                    onSignOut: () async {
                      final navigator = Navigator.of(context);
                      await authProvider.signOut();
                      if (mounted) navigator.pop();
                    },
                  )
                else
                  _SignedOutView(
                    loading: authProvider.isLoading,
                    onGoogle: () => _triggerGoogleSignIn(authProvider),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Signed out ─────────────────────────

class _SignedOutView extends StatelessWidget {
  final bool loading;
  final VoidCallback onGoogle;

  const _SignedOutView({required this.loading, required this.onGoogle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeSlideIn(
          child: Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadows.glow(AppColors.primary),
            ),
            child: Icon(
              PhosphorIconsFill.airplaneTakeoff,
              color: AppColors.secondary,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const Text(
          'মুসাফ্লাই একাউন্টে সাইন-ইন',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'আপনার বুকিং, ফ্লাইট টিকেট এবং স্পেশাল অফার আপডেট পেতে গুগল দিয়ে সহজে সাইন-ইন করুন।',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.55),
        ),
        const SizedBox(height: AppSpacing.xl),
        SoftPanel(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          radius: AppRadius.md + 2,
          child: Column(
            children: [
              _BenefitRow(
                icon: PhosphorIconsFill.ticket,
                text: 'এক জায়গায় সব বুকিং ও টিকেট',
              ),
              _BenefitRow(
                icon: PhosphorIconsFill.tagSimple,
                text: 'এক্সক্লুসিভ অফার ও ডিল আপডেট',
              ),
              _BenefitRow(
                icon: PhosphorIconsFill.lightning,
                text: 'দ্রুত ও সহজ চেকআউট',
                isLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        _GoogleButton(loading: loading, onTap: onGoogle),
        const SizedBox(height: AppSpacing.md + 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(PhosphorIconsRegular.shieldCheck, size: 13, color: AppColors.textMuted),
            const SizedBox(width: 5),
            const Flexible(
              child: Text(
                'সাইন-ইন এর মাধ্যমে আপনি আমাদের শর্তাবলী ও প্রাইভেসিতে সম্মত হচ্ছেন।',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10.5, color: AppColors.textMuted, height: 1.4),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isLast;

  const _BenefitRow({required this.icon, required this.text, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xs),
              boxShadow: AppShadows.soft,
            ),
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onTap;

  const _GoogleButton({required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md + 2),
          border: Border.all(color: AppColors.borderStrong, width: 1.4),
          boxShadow: AppShadows.soft,
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://www.gstatic.com/images/branding/product/2x/googleg_48dp.png',
                      height: 21,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        PhosphorIconsBold.googleLogo,
                        size: 20,
                        color: const Color(0xFF4285F4),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Continue with Google',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ───────────────────────── Signed in ─────────────────────────

class _SignedInView extends StatelessWidget {
  final String name;
  final String email;
  final bool loading;
  final Future<void> Function() onSignOut;

  const _SignedInView({
    required this.name,
    required this.email,
    required this.loading,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'U';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeSlideIn(
          child: Container(
            width: 86,
            height: 86,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.goldGradient,
              boxShadow: AppShadows.glow(AppColors.secondary, opacity: 0.3),
            ),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: Center(
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          email,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.md),
        ToneChip(
          label: 'গুগল একাউন্ট সংযুক্ত',
          icon: PhosphorIconsFill.sealCheck,
          tone: ChipTone.success,
        ),
        const SizedBox(height: AppSpacing.xxl),
        PremiumButton(
          label: 'লগআউট করুন',
          icon: PhosphorIconsBold.signOut,
          style: PremiumButtonStyle.outline,
          height: 52,
          onPressed: loading ? null : () => onSignOut(),
        ),
      ],
    );
  }
}
