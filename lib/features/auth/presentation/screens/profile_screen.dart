import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/l10n/app_locale.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/language_screen.dart';
import '../../../../core/widgets/motion.dart';
import '../../../deals/presentation/screens/deals_screen.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import '../../../support/presentation/screens/support_screen.dart';
import '../providers/auth_provider.dart';
import 'auth_bottom_sheet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locale = Provider.of<LocaleProvider>(context);
    final user = auth.currentUser;
    final isSignedIn = auth.isAuthenticated && user != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          context.tr('nav.profile'),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page, vertical: AppSpacing.lg),
        children: [
          // ── User Card ──
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: isSignedIn
                ? Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                          border: Border.all(color: AppColors.secondary, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'M',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.secondarySubtle,
                                borderRadius: BorderRadius.circular(AppRadius.xs),
                                border: Border.all(color: AppColors.secondaryLight),
                              ),
                              child: const Text(
                                'MusaFly VIP Member',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.secondaryDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.primarySubtle,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          PhosphorIconsDuotone.userCircle,
                          size: 32,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const Text(
                        'Welcome to MusaFly',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Sign in to manage your bookings and access member discounts.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton.icon(
                          onPressed: () => AuthBottomSheet.show(context),
                          icon: const Icon(PhosphorIconsBold.signIn, size: 16),
                          label: Text(context.tr('action.signIn')),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Menu Section ──
          _MenuSection(
            title: 'TRAVEL & BOOKINGS',
            items: [
              _MenuItem(
                icon: PhosphorIconsDuotone.suitcaseSimple,
                title: context.tr('nav.trips'),
                subtitle: 'View your flight and Umrah tickets',
                onTap: () => context.pushPremium(const DealsScreen()),
              ),
              _MenuItem(
                icon: PhosphorIconsDuotone.bellRinging,
                title: context.tr('nav.inbox'),
                subtitle: 'Promotions, flight updates & alerts',
                onTap: () => context.pushPremium(
                  NotificationsScreen(onNavigateTab: (_) {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          _MenuSection(
            title: 'PREFERENCES',
            items: [
              _MenuItem(
                icon: PhosphorIconsDuotone.translate,
                title: 'Language / ভাষা',
                subtitle: locale.isBangla ? 'বাংলা (Bangla)' : 'English',
                trailing: Text(
                  locale.isBangla ? 'বাংলা' : 'EN',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    fontSize: 13,
                  ),
                ),
                onTap: () => context.pushPremium(const LanguageScreen()),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          _MenuSection(
            title: 'SUPPORT & VIP CARE',
            items: [
              _MenuItem(
                icon: PhosphorIconsDuotone.whatsappLogo,
                title: 'WhatsApp Concierge',
                subtitle: 'Direct 24/7 chat with travel expert',
                tint: AppColors.whatsapp,
                onTap: () => UrlHelper.launchWhatsApp(),
              ),
              _MenuItem(
                icon: PhosphorIconsDuotone.headset,
                title: 'Help Centre & FAQs',
                subtitle: 'Instant answers to booking queries',
                onTap: () => context.pushPremium(const SupportScreen()),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          if (isSignedIn) ...[
            Pressable(
              onTap: () => auth.signOut(),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.errorSubtle),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(PhosphorIconsBold.signOut, size: 16, color: AppColors.error),
                      const SizedBox(width: 8),
                      Text(
                        context.tr('action.signOut'),
                        style: const TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          const Center(
            child: Text(
              'MusaFly App v1.0.1+2\nOfficial Airline & Umrah Partner',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.9,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                items[i],
                if (i < items.length - 1)
                  const Divider(height: 1, thickness: 1, color: AppColors.divider),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final Color? tint;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.tint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (tint ?? AppColors.primary).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, size: 19, color: tint ?? AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              trailing!,
              const SizedBox(width: 8),
            ],
            const Icon(
              PhosphorIconsBold.caretRight,
              size: 14,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
