import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../../../../core/widgets/shimmer_loader.dart';

/// Pieces shared by the Tours, Umrah and Visa surfaces. Everything here is
/// composed from the core design primitives (`premium.dart`, `app_design.dart`)
/// rather than re-inventing cards, chips or buttons.

// ───────────────────────── Photo card shell ─────────────────────────

/// Full-bleed photograph with a scrim, corner chips and a title that sits
/// on the image. Used as the top half of every list card.
class PhotoHeader extends StatelessWidget {
  final String imageUrl;
  final String? fallbackUrl;
  final double height;
  final String title;
  final String? subtitle;
  final double titleSize;
  final int titleMaxLines;
  final Widget? topLeft;
  final Widget? topRight;
  final Widget? belowTitle;

  const PhotoHeader({
    super.key,
    required this.imageUrl,
    this.fallbackUrl,
    required this.height,
    required this.title,
    this.subtitle,
    this.titleSize = 20,
    this.titleMaxLines = 2,
    this.topLeft,
    this.topRight,
    this.belowTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppNetworkImage(
            imageUrl: imageUrl,
            fallbackUrl: fallbackUrl,
            width: double.infinity,
            height: height,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.imageScrim),
            child: SizedBox.expand(),
          ),
          if (topLeft != null) Positioned(top: 12, left: 12, child: topLeft!),
          if (topRight != null) Positioned(top: 12, right: 12, child: topRight!),
          Positioned(
            left: 14,
            right: 14,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: titleMaxLines,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.4,
                    height: 1.15,
                    shadows: const [
                      Shadow(color: Color(0x66000000), blurRadius: 12, offset: Offset(0, 2)),
                    ],
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.88),
                    ),
                  ),
                ],
                if (belowTitle != null) ...[
                  const SizedBox(height: 8),
                  belowTitle!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// White footer strip of a photo card: price on the left, CTA on the right.
class CardPriceFooter extends StatelessWidget {
  final String label;
  final String price;
  final String? note;
  final String ctaLabel;
  final bool goldCta;
  final EdgeInsetsGeometry padding;

  const CardPriceFooter({
    super.key,
    required this.label,
    required this.price,
    this.note,
    this.ctaLabel = 'View details',
    this.goldCta = false,
    this.padding = const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  price,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: -0.6,
                    fontFeatures: AppText.tabular,
                  ),
                ),
                if (note != null)
                  Text(
                    note!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10.5, color: AppColors.textMuted),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
              decoration: BoxDecoration(
                gradient: goldCta ? AppColors.goldCta : null,
                color: goldCta ? null : AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                boxShadow: AppShadows.glow(
                  goldCta ? AppColors.secondary : AppColors.primary,
                  opacity: 0.22,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      ctaLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: goldCta ? AppColors.primaryDark : Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    PhosphorIconsBold.arrowRight,
                    size: 13,
                    color: goldCta ? AppColors.primaryDark : Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Detail hero ─────────────────────────

/// Stretching, parallaxing hero image. The big title scales and fades out
/// as the bar collapses and a compact one fades in to replace it.
class PhotoHeroSliver extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String imageUrl;
  final String? fallbackUrl;
  final List<Widget> chips;
  final List<Widget> actions;
  final double expandedHeight;

  const PhotoHeroSliver({
    super.key,
    required this.title,
    this.subtitle,
    required this.imageUrl,
    this.fallbackUrl,
    this.chips = const [],
    this.actions = const [],
    this.expandedHeight = 316,
  });

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final minHeight = kToolbarHeight + topInset;

    return SliverAppBar(
      pinned: true,
      stretch: true,
      expandedHeight: expandedHeight,
      backgroundColor: AppColors.primaryDark,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leadingWidth: 60,
      leading: Navigator.canPop(context)
          ? Padding(
              padding: const EdgeInsets.only(left: AppSpacing.md),
              child: GlassIconButton(
                icon: PhosphorIconsBold.arrowLeft,
                onTap: () => Navigator.pop(context),
              ),
            )
          : null,
      actions: [
        ...actions,
        const SizedBox(width: AppSpacing.md),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final h = constraints.maxHeight;
          // 1 = fully expanded, 0 = collapsed.
          final t = ((h - minHeight) / (expandedHeight - minHeight)).clamp(0.0, 1.0);
          final collapsed = (1 - t).clamp(0.0, 1.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              // Parallax: the photo drifts slower than the sheet above it.
              Positioned(
                top: -28 * t,
                left: 0,
                right: 0,
                bottom: 0,
                child: AppNetworkImage(
                  imageUrl: imageUrl,
                  fallbackUrl: fallbackUrl,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(gradient: AppColors.imageScrim),
                child: SizedBox.expand(),
              ),
              // Darken the top strip too: imageScrim only shades the bottom,
              // so over a bright photo the status bar clock and the glass
              // buttons washed out.
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 150,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.42),
                        Colors.black.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Navy wash so the pinned bar's icons stay legible.
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: minHeight,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: collapsed,
                    child: const DecoratedBox(decoration: AppDecor.hero),
                  ),
                ),
              ),
              // Compact title in the pinned bar.
              Positioned(
                top: topInset,
                left: 64,
                right: 64,
                height: kToolbarHeight,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: collapsed * collapsed,
                    child: Center(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Expanded title block.
              Positioned(
                left: AppSpacing.page,
                right: AppSpacing.page,
                bottom: 42,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: Curves.easeIn.transform(t),
                    child: Transform.scale(
                      alignment: Alignment.bottomLeft,
                      scale: 0.94 + 0.06 * t,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (chips.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Wrap(spacing: 8, runSpacing: 8, children: chips),
                            ),
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.8,
                              height: 1.1,
                              shadows: [
                                Shadow(color: Color(0x73000000), blurRadius: 16, offset: Offset(0, 3)),
                              ],
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // The lip of the content sheet, overlapping the photo. It fades
              // out as the bar collapses so the pinned bar stays clean.
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 26,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: Curves.easeIn.transform(t),
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
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

/// Rounded page sheet that overlaps the bottom of the hero image.
class DetailSheet extends StatelessWidget {
  final List<Widget> children;

  const DetailSheet({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.background,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

/// Translucent circular button that sits on photography.
class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const GlassIconButton({super.key, required this.icon, required this.onTap, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Pressable(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.38),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
          ),
          child: Icon(icon, size: size * 0.45, color: Colors.white),
        ),
      ),
    );
  }
}

// ───────────────────────── List-screen header ─────────────────────────

/// Navy hero at the top of a list screen: title, subtitle and an optional
/// floating search field.
class ListHero extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;
  final IconData icon;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onRefresh;
  final List<String> highlights;

  const ListHero({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.searchHint,
    this.onSearchChanged,
    this.onRefresh,
    this.highlights = const [],
  });

  @override
  Widget build(BuildContext context) {
    final hasSearch = searchHint != null && onSearchChanged != null;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppRadius.xl)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.page,
        MediaQuery.paddingOf(context).top + AppSpacing.md,
        AppSpacing.page,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (Navigator.canPop(context)) ...[
                GlassIconButton(
                  icon: PhosphorIconsBold.arrowLeft,
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 13, color: AppColors.secondaryLight),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          eyebrow.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.7,
                            color: AppColors.secondaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              if (onRefresh != null) ...[
                const SizedBox(width: AppSpacing.sm),
                GlassIconButton(
                  icon: PhosphorIconsBold.arrowClockwise,
                  onTap: onRefresh!,
                  size: 38,
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.8,
              height: 1.14,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
          if (highlights.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final h in highlights)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(PhosphorIconsFill.checkCircle,
                            size: 12, color: AppColors.secondaryLight),
                        const SizedBox(width: 5),
                        Text(
                          h,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
          if (hasSearch) ...[
            const SizedBox(height: AppSpacing.xl),
            HeroSearchField(hint: searchHint!, onChanged: onSearchChanged!),
          ],
        ],
      ),
    );
  }
}

/// Floating white search field used under a [ListHero].
class HeroSearchField extends StatefulWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const HeroSearchField({super.key, required this.hint, required this.onChanged});

  @override
  State<HeroSearchField> createState() => _HeroSearchFieldState();
}

class _HeroSearchFieldState extends State<HeroSearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.elevated,
      ),
      child: Row(
        children: [
          Icon(PhosphorIconsBold.magnifyingGlass, size: 18, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (v) {
                widget.onChanged(v);
                setState(() {});
              },
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: widget.hint,
                hintMaxLines: 1,
                hintStyle: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            Pressable(
              onTap: () {
                _controller.clear();
                widget.onChanged('');
                setState(() {});
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Icon(PhosphorIconsFill.xCircle, size: 19, color: AppColors.textMuted),
              ),
            ),
        ],
      ),
    );
  }
}

/// "12 packages available" row above a result list.
class ResultCountRow extends StatelessWidget {
  final int count;
  final String singular;
  final String? plural;
  final String? trailing;

  const ResultCountRow({
    super.key,
    required this.count,
    required this.singular,
    this.plural,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final noun = count == 1 ? singular : (plural ?? '${singular}s');
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$count $noun available',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          if (trailing != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(PhosphorIconsFill.sealCheck, size: 13, color: AppColors.success),
                const SizedBox(width: 5),
                Text(
                  trailing!,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ───────────────────────── Loading / empty / error ─────────────────────────

/// Shimmer stand-in that matches the shape of a photo card.
class PhotoCardSkeleton extends StatelessWidget {
  final double imageHeight;

  const PhotoCardSkeleton({super.key, this.imageHeight = 196});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: AppDecor.card(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: double.infinity, height: imageHeight, borderRadius: BorderRadius.zero),
          const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 180, height: 16),
                SizedBox(height: 10),
                ShimmerBox(width: 120, height: 12),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerBox(width: 92, height: 26),
                    ShimmerBox(width: 110, height: 38, borderRadius: BorderRadius.all(Radius.circular(12))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty / error panel with an illustration-style icon and a retry action.
class FeatureStatePanel extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final bool isError;

  const FeatureStatePanel({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isError ? AppColors.error : AppColors.primary;

    return PremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xxxl),
      child: Column(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.09),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 34, color: accent),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          PremiumButton(
            label: actionLabel,
            onPressed: onAction,
            style: PremiumButtonStyle.outline,
            icon: PhosphorIconsBold.arrowClockwise,
            height: 46,
            expand: false,
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Detail-screen sections ─────────────────────────

/// Row of [InfoTile]s inside a white card — the "at a glance" strip.
class GlanceStrip extends StatelessWidget {
  final List<InfoTile> tiles;

  const GlanceStrip({super.key, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < tiles.length; i++) ...[
            if (i > 0)
              Container(
                width: 1,
                height: 56,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                color: AppColors.divider,
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: tiles[i],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Icon + title + supporting line. Used for benefit and accommodation lists.
class FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const FeatureRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: AppDecor.soft(color, radius: AppRadius.xs),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Numbered vertical timeline — the visa process, step by step.
class StepTimeline extends StatelessWidget {
  final List<({String title, String detail, IconData icon})> steps;
  final Color color;

  const StepTimeline({super.key, required this.steps, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.glow(color, opacity: 0.2),
                      ),
                      alignment: Alignment.center,
                      child: Icon(steps[i].icon, size: 16, color: Colors.white),
                    ),
                    if (i != steps.length - 1)
                      Expanded(
                        child: Container(
                          width: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 2,
                      bottom: i == steps.length - 1 ? 0 : AppSpacing.xl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'STEP ${i + 1}',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: color.withValues(alpha: 0.65),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          steps[i].title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          steps[i].detail,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            height: 1.45,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Bottom-sheet header: grab handle, title and a close button.
class SheetHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SheetHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 42,
          height: 4,
          margin: const EdgeInsets.only(bottom: AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.borderStrong,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            SoftIconButton(
              icon: PhosphorIconsBold.x,
              size: 38,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ],
    );
  }
}

/// Success dialog shown after an inquiry or application is submitted.
Future<void> showSubmissionSuccess(
  BuildContext context, {
  required String title,
  required String message,
  required String chatLabel,
  required VoidCallback onChat,
}) {
  return showDialog(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.successSubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(PhosphorIconsFill.checkCircle, size: 40, color: AppColors.success),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            PremiumButton(
              label: chatLabel,
              icon: PhosphorIconsFill.whatsappLogo,
              style: PremiumButtonStyle.whatsapp,
              height: 50,
              onPressed: () {
                Navigator.pop(ctx);
                onChat();
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            Pressable(
              onTap: () => Navigator.pop(ctx),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
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
