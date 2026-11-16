import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/motion.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';

/// Collapsing navy hero. The brand row stays pinned at the top while the
/// greeting and headline fade and lift away as the page scrolls.
class HomeHeroSliver extends StatelessWidget {
  static const double toolbarHeight = 64;
  static const double expandedHeight = 206;

  final VoidCallback onNotifications;
  final VoidCallback onProfile;

  const HomeHeroSliver({
    super.key,
    required this.onNotifications,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final minH = toolbarHeight + top;
    final maxH = expandedHeight + top;

    return SliverAppBar(
      pinned: true,
      stretch: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: toolbarHeight,
      collapsedHeight: toolbarHeight,
      expandedHeight: expandedHeight,
      backgroundColor: AppColors.primaryDark,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final t = maxH == minH
              ? 0.0
              : ((constraints.maxHeight - minH) / (maxH - minH)).clamp(0.0, 1.0);
          return _HeroSurface(
            t: t,
            topInset: top,
            onNotifications: onNotifications,
            onProfile: onProfile,
          );
        },
      ),
    );
  }
}

class _HeroSurface extends StatelessWidget {
  final double t;
  final double topInset;
  final VoidCallback onNotifications;
  final VoidCallback onProfile;

  const _HeroSurface({
    required this.t,
    required this.topInset,
    required this.onNotifications,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecor.hero,
      child: ClipRect(
        child: Stack(
          children: [
            // Warm gold bloom behind the brand row. Radial, not a flat disc:
            // a solid circle at low opacity reads as a grey smudge with a
            // visible hard edge rather than as light.
            Positioned(
              right: -110,
              top: -130,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.22 + 0.06 * t),
                      AppColors.secondary.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: -110,
              bottom: -140,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryLight.withValues(alpha: 0.26 * t),
                      AppColors.primaryLight.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
            // Greeting + headline — fades out as the hero collapses.
            Positioned(
              left: AppSpacing.page,
              right: AppSpacing.page,
              bottom: AppSpacing.lg,
              child: Opacity(
                opacity: t,
                child: Transform.translate(
                  offset: Offset(0, (1 - t) * 16),
                  child: const _HeroGreeting(),
                ),
              ),
            ),
            Positioned(
              top: topInset,
              left: 0,
              right: 0,
              height: HomeHeroSliver.toolbarHeight,
              child: _HeroBrandRow(
                onNotifications: onNotifications,
                onProfile: onProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroGreeting extends StatelessWidget {
  const _HeroGreeting();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<AuthProvider>(
          builder: (context, auth, _) {
            final user = auth.currentUser;
            final name = (auth.isAuthenticated && user != null && user.name.trim().isNotEmpty)
                ? user.name.trim().split(RegExp(r'\s+')).first
                : null;
            return Row(
              children: [
                const Icon(PhosphorIconsFill.sparkle, size: 13, color: AppColors.secondaryLight),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    name != null ? 'Welcome back, $name' : 'Your journey starts here',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.82),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        const Text(
          'Fly smarter.\nTravel better.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 29,
            height: 1.1,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.9,
          ),
        ),
      ],
    );
  }
}

class _HeroBrandRow extends StatelessWidget {
  final VoidCallback onNotifications;
  final VoidCallback onProfile;

  const _HeroBrandRow({required this.onNotifications, required this.onProfile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              boxShadow: AppShadows.glow(AppColors.primaryDark, opacity: 0.25),
            ),
            child: Image.asset(
              AppAssets.logo,
              height: 24,
              width: 24,
              errorBuilder: (_, _, _) => const Icon(
                PhosphorIconsFill.airplaneTakeoff,
                color: AppColors.primary,
                size: 21,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(
            child: Text(
              AppStrings.appName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
          ),
          _HeroAction(
            onTap: onNotifications,
            child: Consumer<NotificationProvider>(
              builder: (context, notif, _) {
                final unread = notif.unreadCount;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(PhosphorIconsRegular.bellRinging, color: Colors.white, size: 21),
                    if (unread > 0)
                      Positioned(
                        top: -4,
                        right: -7,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 17),
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                            border: Border.all(color: AppColors.primaryDark, width: 1.5),
                          ),
                          child: Text(
                            unread > 9 ? '9+' : '$unread',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              height: 1.3,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Consumer<AuthProvider>(
            builder: (context, auth, _) {
              final user = auth.currentUser;
              final signedIn = auth.isAuthenticated && user != null;
              final initial = (signedIn && user.name.trim().isNotEmpty)
                  ? user.name.trim()[0].toUpperCase()
                  : 'U';
              return _HeroAction(
                filled: signedIn,
                onTap: onProfile,
                child: signedIn
                    ? Text(
                        initial,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      )
                    : const Icon(PhosphorIconsRegular.user, color: Colors.white, size: 20),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool filled;

  const _HeroAction({required this.child, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.9,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: filled ? AppColors.goldGradient : null,
          color: filled ? null : Colors.white.withValues(alpha: 0.13),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
        ),
        child: Center(child: child),
      ),
    );
  }
}
