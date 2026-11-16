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

/// Standard, rock-solid bottom navigation bar.
///
/// Labels and icons are always clearly visible, with crisp active states
/// and fluid haptics. Supports both English and Bangla without any overflow.
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
        border: const Border(
          top: BorderSide(color: Color(0xFFEBF0F6), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              for (var i = 0; i < destinations.length; i++)
                Expanded(
                  child: _NavBarItem(
                    destination: destinations[i],
                    label: label(destinations[i].labelKey),
                    selected: currentIndex == i,
                    onTap: () {
                      if (currentIndex != i) {
                        HapticFeedback.selectionClick();
                        onTap(i);
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final NavDestination destination;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.destination,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primary;
    const inactiveColor = Color(0xFF8A99AC);

    return InkWell(
      onTap: onTap,
      splashColor: AppColors.primary.withValues(alpha: 0.08),
      highlightColor: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primarySubtle
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Icon(
                selected ? destination.activeIcon : destination.icon,
                size: 22,
                color: selected ? activeColor : inactiveColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: selected ? activeColor : inactiveColor,
                letterSpacing: -0.2,
                height: 1.1,
              ),
            ),
          ],
        ),
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
