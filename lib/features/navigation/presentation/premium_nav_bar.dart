import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_design.dart';

class NavDestination {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavDestination({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// Floating bottom bar. The selected item becomes a navy pill that grows
/// to reveal its label, while the others stay as plain icons.
class PremiumNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavDestination> destinations;

  const PremiumNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        MediaQuery.of(context).padding.bottom > 0
            ? AppSpacing.sm
            : AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (var i = 0; i < destinations.length; i++)
              _NavPill(
                destination: destinations[i],
                selected: currentIndex == i,
                onTap: () {
                  if (currentIndex != i) HapticFeedback.selectionClick();
                  onTap(i);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _NavPill extends StatelessWidget {
  final NavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  const _NavPill({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      // The visible pill is only ~48pt wide when deselected, which left wide
      // dead gaps between items. This transparent padding sits inside the
      // detector, so the tap target spans the full slot and the full bar height.
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        child: AnimatedContainer(
          duration: AppMotion.base,
          curve: AppMotion.emphasized,
          height: 46,
          padding: EdgeInsets.symmetric(horizontal: selected ? 16 : 13),
          decoration: BoxDecoration(
            gradient: selected ? AppColors.primaryGradient : null,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: selected
                ? AppShadows.glow(AppColors.primary, opacity: 0.3)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: AppMotion.fast,
                child: Icon(
                  selected ? destination.activeIcon : destination.icon,
                  key: ValueKey(selected),
                  size: 22,
                  color: selected ? Colors.white : AppColors.textMuted,
                ),
              ),
              // Label slides out of the pill when the item is deselected.
              ClipRect(
                child: AnimatedAlign(
                  duration: AppMotion.base,
                  curve: AppMotion.emphasized,
                  alignment: Alignment.centerLeft,
                  widthFactor: selected ? 1.0 : 0.0,
                  child: AnimatedOpacity(
                    duration: AppMotion.fast,
                    opacity: selected ? 1 : 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(
                        destination.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
    label: 'Home',
  ),
  NavDestination(
    icon: PhosphorIconsRegular.airplaneTilt,
    activeIcon: PhosphorIconsFill.airplaneTilt,
    label: 'Flights',
  ),
  NavDestination(
    icon: PhosphorIconsRegular.mosque,
    activeIcon: PhosphorIconsFill.mosque,
    label: 'Umrah',
  ),
  NavDestination(
    icon: PhosphorIconsRegular.identificationCard,
    activeIcon: PhosphorIconsFill.identificationCard,
    label: 'Visa',
  ),
  NavDestination(
    icon: PhosphorIconsRegular.ticket,
    activeIcon: PhosphorIconsFill.ticket,
    label: 'Trips',
  ),
];
