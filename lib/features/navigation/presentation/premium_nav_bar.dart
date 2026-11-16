import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_design.dart';
import '../../../core/constants/app_icons.dart';

class NavDestination {
  final IconData icon;
  final IconData activeIcon;

  /// Key into the string tables, so the bar follows the chosen language.
  final String labelKey;

  const NavDestination({
    required this.icon,
    required this.activeIcon,
    required this.labelKey,
  });
}

/// Bottom bar with a single indicator that glides between items rather than
/// snapping. The active icon lifts, scales and recolours as the indicator
/// arrives, so moving between tabs reads as one continuous motion.
class PremiumNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavDestination> destinations;

  /// Resolves a destination's label key for the active language.
  final String Function(String key) label;

  const PremiumNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final slot = constraints.maxWidth / destinations.length;

              return Stack(
                children: [
                  // The travelling indicator — one widget for the whole bar,
                  // which is what makes the movement continuous.
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 420),
                    curve: Curves.easeOutQuint,
                    left: slot * currentIndex,
                    top: 0,
                    width: slot,
                    height: 66,
                    child: Center(
                      child: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.32),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < destinations.length; i++)
                        Expanded(
                          child: _NavItem(
                            destination: destinations[i],
                            label: label(destinations[i].labelKey),
                            selected: currentIndex == i,
                            onTap: () {
                              if (currentIndex != i) HapticFeedback.selectionClick();
                              onTap(i);
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final NavDestination destination;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.destination,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      // Animates its own slice of the transition; the indicator behind it
      // carries the horizontal movement.
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: selected ? 1 : 0),
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutQuint,
        builder: (context, t, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0, -5 * t),
                child: Transform.scale(
                  scale: 1 + 0.08 * t,
                  child: Icon(
                    selected ? destination.activeIcon : destination.icon,
                    size: 23,
                    color: Color.lerp(AppColors.textMuted, Colors.white, t),
                  ),
                ),
              ),
              // The label fades and slides away as the tile is taken over by
              // the indicator, leaving just the icon on the pill.
              Flexible(
                child: Opacity(
                  opacity: 1 - t,
                  child: Transform.translate(
                    offset: Offset(0, 6 * t),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// The five primary destinations.
const kNavDestinations = <NavDestination>[
  NavDestination(
    icon: PhosphorIconsRegular.house,
    activeIcon: PhosphorIconsFill.house,
    labelKey: 'nav.home',
  ),
  NavDestination(
    icon: PhosphorIconsRegular.suitcaseSimple,
    activeIcon: PhosphorIconsFill.suitcaseSimple,
    labelKey: 'nav.bookings',
  ),
  NavDestination(
    icon: PhosphorIconsRegular.chatCircleDots,
    activeIcon: PhosphorIconsFill.chatCircleDots,
    labelKey: 'nav.chat',
  ),
  NavDestination(
    icon: PhosphorIconsRegular.paperPlaneTilt,
    activeIcon: PhosphorIconsFill.paperPlaneTilt,
    labelKey: 'nav.inbox',
  ),
  NavDestination(
    icon: PhosphorIconsRegular.user,
    activeIcon: PhosphorIconsFill.user,
    labelKey: 'nav.profile',
  ),
];
