import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_design.dart';
import '../constants/app_icons.dart';
import 'motion.dart';

/// The booking-surface vocabulary the whole app shares.
///
/// These are deliberately airy: a white card, a small uppercase label over a
/// large value, hairline dividers between rows, and one big circular action
/// that straddles the card's bottom edge. Dense, dark panels read as cheap at
/// this size; whitespace is what makes a travel form feel considered.

// ───────────────────────── Service rail ─────────────────────────

class ServiceItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const ServiceItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

/// Row of white service tiles that overlaps the hero above it and stays put
/// while the page scrolls underneath.
class ServiceRail extends StatelessWidget {
  final List<ServiceItem> items;

  /// 1 while the hero is fully open, 0 once it has collapsed. Drives the
  /// subtle lift and the backing plate that appears when pinned.
  final double expansion;

  const ServiceRail({super.key, required this.items, this.expansion = 1});

  static const double height = 108;

  @override
  Widget build(BuildContext context) {
    final pinned = 1 - expansion;

    return Container(
      height: height,
      decoration: BoxDecoration(
        // A white plate fades in behind the tiles as they pin, so they never
        // float over scrolling content.
        color: Colors.white.withValues(alpha: pinned),
        boxShadow: pinned > 0.6
            ? [
                BoxShadow(
                  color: AppColors.primaryDark.withValues(alpha: 0.05 * pinned),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in items) Expanded(child: _ServiceTile(item: item)),
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final ServiceItem item;

  const _ServiceTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: item.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: item.color.withValues(alpha: 0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(item.icon, size: 29, color: item.color),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Booking form ─────────────────────────

/// White booking card. [action] is the big circular button that hangs off the
/// bottom edge; pass null for a card without one.
class BookingCard extends StatelessWidget {
  final List<Widget> children;
  final Widget? action;
  final EdgeInsetsGeometry margin;

  const BookingCard({
    super.key,
    required this.children,
    this.action,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              0,
              AppSpacing.xs,
              0,
              action == null ? AppSpacing.xs : 52,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadows.soft,
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: children),
          ),
          if (action != null) Positioned(bottom: -34, child: action!),
        ],
      ),
    );
  }
}

/// One row of a booking form: small label, large value, optional trailing.
class BookingField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? hint;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool divider;

  const BookingField({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.hint,
    this.onTap,
    this.trailing,
    this.divider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Pressable(
          onTap: onTap,
          scale: 0.99,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 19, color: AppColors.textMuted),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.9,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          height: 1.15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (hint != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          hint!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: AppSpacing.sm), trailing!],
              ],
            ),
          ),
        ),
        if (divider)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Divider(height: 1, thickness: 1, color: AppColors.divider),
          ),
      ],
    );
  }
}

/// Two booking fields side by side, split by a hairline.
class BookingFieldPair extends StatelessWidget {
  final Widget left;
  final Widget right;
  final bool divider;

  const BookingFieldPair({
    super.key,
    required this.left,
    required this.right,
    this.divider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: left),
              const VerticalDivider(width: 1, thickness: 1, color: AppColors.divider),
              Expanded(child: right),
            ],
          ),
        ),
        if (divider)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Divider(height: 1, thickness: 1, color: AppColors.divider),
          ),
      ],
    );
  }
}

/// The big round gold action that hangs off a [BookingCard].
class RoundAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool loading;
  final double size;

  const RoundAction({
    super.key,
    required this.label,
    required this.onTap,
    this.loading = false,
    this.size = 86,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: loading ? null : onTap,
      scale: 0.94,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: AppColors.goldCta,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.46),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: loading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.6,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryDark),
                  ),
                )
              : Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: AppColors.primaryDark,
                  ),
                ),
        ),
      ),
    );
  }
}

/// Circular swap control that spins each time it is used.
class SwapButton extends StatefulWidget {
  final VoidCallback onTap;

  const SwapButton({super.key, required this.onTap});

  @override
  State<SwapButton> createState() => _SwapButtonState();
}

class _SwapButtonState extends State<SwapButton> {
  int _turns = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() => _turns++);
        widget.onTap();
      },
      child: AnimatedRotation(
        turns: _turns / 2,
        duration: AppMotion.base,
        curve: AppMotion.emphasized,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
            boxShadow: AppShadows.soft,
          ),
          child: Icon(
            PhosphorIconsBold.arrowsDownUp,
            size: 18,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

/// Segmented control in the style of the big travel apps: a gold pill slides
/// under the active label.
class SegmentedTabs extends StatelessWidget {
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;

  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        boxShadow: AppShadows.soft,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth / labels.length;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: AppMotion.base,
                curve: AppMotion.emphasized,
                left: w * index,
                top: 0,
                bottom: 0,
                width: w,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppColors.goldCta,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
              Row(
                children: [
                  for (var i = 0; i < labels.length; i++)
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onChanged(i),
                        child: Center(
                          child: AnimatedDefaultTextStyle(
                            duration: AppMotion.fast,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: i == index ? FontWeight.w800 : FontWeight.w600,
                              color: i == index ? AppColors.primaryDark : AppColors.textSecondary,
                            ),
                            child: Text(
                              labels[i],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Horizontally scrolling filter chips: navy when active, outlined when not.
class FilterChipRail extends StatelessWidget {
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;
  final EdgeInsetsGeometry padding;

  const FilterChipRail({
    super.key,
    required this.labels,
    required this.index,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.page),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm + 2),
        itemBuilder: (context, i) {
          final active = i == index;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: AppMotion.base,
              curve: AppMotion.emphasized,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              decoration: BoxDecoration(
                color: active ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: active ? AppColors.primary : AppColors.border),
              ),
              child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                  color: active ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
