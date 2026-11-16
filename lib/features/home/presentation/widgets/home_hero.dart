import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/booking_ui.dart';
import '../../../../core/widgets/motion.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';

/// Photographic home header.
///
/// A real travel photo fills the top of the screen with a light greeting over
/// it; a row of white service tiles overlaps the photo's lower edge. As the
/// page scrolls the photo parallaxes and fades away while the tiles stay
/// pinned under the status bar — the shape every big travel app now uses.
class HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  /// Photo height below the status bar.
  static const double photoHeight = 175;

  /// How far the service tiles sit over the photo's bottom edge.
  static const double overlap = 46;

  static const double railHeight = ServiceRail.height;

  final double topInset;
  final String? photoUrl;
  final List<ServiceItem> services;
  final VoidCallback onMenu;
  final VoidCallback onNotifications;

  const HomeHeaderDelegate({
    required this.topInset,
    required this.photoUrl,
    required this.services,
    required this.onMenu,
    required this.onNotifications,
  });

  @override
  double get maxExtent => topInset + photoHeight + railHeight - overlap;

  @override
  double get minExtent => topInset + railHeight;

  @override
  bool shouldRebuild(covariant HomeHeaderDelegate old) =>
      old.topInset != topInset ||
      old.photoUrl != photoUrl ||
      old.services.length != services.length;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final range = maxExtent - minExtent;
    final t = range <= 0 ? 0.0 : (1 - (shrinkOffset / range)).clamp(0.0, 1.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: t > 0.45 ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: Colors.white),
            Positioned(
              top: -shrinkOffset * 0.38,
              left: 0,
              right: 0,
              height: topInset + photoHeight,
              child: Opacity(
                opacity: t,
                child: _HeroPhoto(
                  photoUrl: photoUrl,
                  topInset: topInset,
                  onMenu: onMenu,
                  onNotifications: onNotifications,
                  interactive: t > 0.25,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ServiceRail(items: services, expansion: t),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroPhoto extends StatelessWidget {
  final String? photoUrl;
  final double topInset;
  final VoidCallback onMenu;
  final VoidCallback onNotifications;
  final bool interactive;

  const _HeroPhoto({
    required this.photoUrl,
    required this.topInset,
    required this.onMenu,
    required this.onNotifications,
    required this.interactive,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.isNotEmpty;

    return Stack(
      fit: StackFit.expand,
      children: [
        // The photo itself, or the navy hero surface until one has loaded.
        if (hasPhoto)
          AppNetworkImage(imageUrl: photoUrl, fit: BoxFit.cover)
        else
          const DecoratedBox(decoration: AppDecor.hero),

        // Scrim so the white type stays readable over any photograph.
        const DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.imageScrim),
        ),
        // A second, lighter wash at the very top for the status bar icons.
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66000000), Color(0x00000000)],
              stops: [0.0, 0.45],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        Positioned(
          top: topInset + AppSpacing.xs,
          left: AppSpacing.page,
          right: AppSpacing.page,
          child: IgnorePointer(
            ignoring: !interactive,
            child: _HeroTopRow(
              onMenu: onMenu,
              onNotifications: onNotifications,
            ),
          ),
        ),
      ],
    );
  }
}

/// Hamburger and "Hello, Traveler" on the left, notification bell on the right.
class _HeroTopRow extends StatelessWidget {
  final VoidCallback onMenu;
  final VoidCallback onNotifications;

  const _HeroTopRow({required this.onMenu, required this.onNotifications});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _GlassButton(
          onTap: onMenu,
          tooltip: context.tr('home.menu'),
          child: const Icon(PhosphorIconsBold.list, color: Colors.white, size: 22),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Consumer<AuthProvider>(
            builder: (context, auth, _) {
              final user = auth.currentUser;
              final name = (auth.isAuthenticated && user != null && user.name.trim().isNotEmpty)
                  ? user.name.trim().split(RegExp(r'\s+')).first
                  : null;
              final greeting = name != null
                  ? '${context.tr('home.helloBack')}, $name'
                  : context.tr('home.hello');

              return Text(
                greeting,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  shadows: [
                    Shadow(color: Color(0x80000000), blurRadius: 10, offset: Offset(0, 1)),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _GlassButton(
          onTap: onNotifications,
          tooltip: context.tr('home.notifications'),
          child: Consumer<NotificationProvider>(
            builder: (context, notif, _) {
              final unread = notif.unreadCount;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(PhosphorIconsRegular.bellRinging, color: Colors.white, size: 20),
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
                          border: Border.all(color: Colors.white, width: 1.4),
                        ),
                        child: Text(
                          unread > 9 ? '9+' : '$unread',
                          textAlign: TextAlign.center,
                          maxLines: 1,
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
      ],
    );
  }
}

class _GlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final String tooltip;

  const _GlassButton({
    required this.child,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Pressable(
        onTap: onTap,
        scale: 0.9,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.26),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.34)),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
