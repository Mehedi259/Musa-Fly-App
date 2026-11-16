import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/widgets/motion.dart';

/// One service entry in the home category row.
class HomeCategory {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const HomeCategory({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

/// The five core services, shown as a single lifted card directly under the
/// search panel. Duotone icons sit on a tinted tile in the service's accent.
class HomeCategoryRow extends StatelessWidget {
  final List<HomeCategory> categories;

  const HomeCategoryRow({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg, horizontal: AppSpacing.sm),
        decoration: AppDecor.card(radius: AppRadius.lg, shadow: AppShadows.medium),
        child: Row(
          children: [
            for (var i = 0; i < categories.length; i++)
              Expanded(
                child: FadeSlideIn(
                  index: i,
                  offsetY: 10,
                  child: _CategoryTile(category: categories[i]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final HomeCategory category;

  const _CategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    final c = category.color;
    return Pressable(
      onTap: category.onTap,
      scale: 0.93,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [c.withValues(alpha: 0.16), c.withValues(alpha: 0.06)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: c.withValues(alpha: 0.14)),
            ),
            child: Icon(category.icon, color: c, size: 25),
          ),
          const SizedBox(height: 7),
          Text(
            category.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Icons used by the home category row, kept here so the screen file stays
/// about layout rather than icon names.
class HomeCategoryIcons {
  static final IconData flight = PhosphorIconsDuotone.airplaneTakeoff;
  static final IconData tour = PhosphorIconsDuotone.island;
  static final IconData umrah = PhosphorIconsDuotone.mosque;
  static final IconData visa = PhosphorIconsDuotone.identificationCard;
  static final IconData deal = PhosphorIconsDuotone.ticket;
}
