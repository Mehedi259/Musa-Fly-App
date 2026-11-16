import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/shimmer_loader.dart';

/// Shown when a section has loaded but came back with nothing.
class HomeEmptyNote extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  final Color tint;

  const HomeEmptyNote({
    super.key,
    required this.icon,
    required this.message,
    this.actionText,
    this.onAction,
    this.tint = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: AppDecor.soft(tint, radius: AppRadius.xs),
              child: Icon(icon, size: 18, color: tint),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ),
            if (actionText != null && onAction != null)
              Pressable(
                onTap: onAction,
                child: Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.sm),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        actionText!,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(PhosphorIconsBold.caretRight, size: 11, color: AppColors.primary),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer stand-in for a stacked list section (flights, visas).
class HomeListSkeleton extends StatelessWidget {
  final int count;
  final double height;

  const HomeListSkeleton({super.key, this.count = 2, this.height = 118});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
      child: Column(
        children: [
          for (var i = 0; i < count; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: AppDecor.card(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        ShimmerBox(width: 110, height: 16),
                        ShimmerBox(width: 64, height: 16),
                      ],
                    ),
                    SizedBox(height: height * 0.2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        ShimmerBox(width: 58, height: 24),
                        ShimmerBox(width: 70, height: 14),
                        ShimmerBox(width: 58, height: 24),
                      ],
                    ),
                    SizedBox(height: height * 0.2),
                    const ShimmerBox(width: double.infinity, height: 34),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Shimmer stand-in for a horizontally scrolling card strip (tours).
class HomeStripSkeleton extends StatelessWidget {
  final double height;

  const HomeStripSkeleton({super.key, this.height = 250});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(left: AppSpacing.page),
        itemCount: 3,
        itemBuilder: (_, _) => Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md),
          child: Container(
            width: 232,
            decoration: AppDecor.card(),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(width: 232, height: 136),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ShimmerBox(width: 150, height: 16),
                      SizedBox(height: 8),
                      ShimmerBox(width: 92, height: 12),
                      SizedBox(height: 12),
                      ShimmerBox(width: 72, height: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Single tall shimmer block — used for the Umrah highlight card.
class HomeBlockSkeleton extends StatelessWidget {
  final double height;

  const HomeBlockSkeleton({super.key, this.height = 180});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
      child: ShimmerBox(
        width: double.infinity,
        height: height,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    );
  }
}
