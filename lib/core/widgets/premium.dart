import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import '../constants/app_colors.dart';
import '../constants/app_design.dart';
import 'motion.dart';

/// Building blocks shared by every feature. Screens compose these rather
/// than hand-rolling containers, so spacing, radii and weight stay consistent.

// ───────────────────────── Surfaces ─────────────────────────

/// Standard white card. Tappable when [onTap] is given.
class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double radius;
  final bool featured;
  final List<BoxShadow>? shadow;
  final Color? color;
  final bool clip;

  const PremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.margin,
    this.onTap,
    this.radius = AppRadius.lg,
    this.featured = false,
    this.shadow,
    this.color,
    this.clip = false,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = featured
        ? AppDecor.premiumCard(radius: radius)
        : AppDecor.card(radius: radius, shadow: shadow, color: color);

    Widget content = Container(
      margin: margin,
      padding: clip ? null : padding,
      decoration: decoration,
      clipBehavior: clip ? Clip.antiAlias : Clip.none,
      child: child,
    );

    return Pressable(onTap: onTap, child: content);
  }
}

/// Inset panel used inside a card to group secondary information.
class SoftPanel extends StatelessWidget {
  final Widget child;
  final Color tint;
  final EdgeInsetsGeometry padding;
  final double radius;

  const SoftPanel({
    super.key,
    required this.child,
    this.tint = AppColors.primary,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.radius = AppRadius.sm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: AppDecor.soft(tint, radius: radius),
      child: child,
    );
  }
}

// ───────────────────────── Chips & badges ─────────────────────────

enum ChipTone { neutral, brand, gold, success, danger, info, onImage }

/// Small labelled pill. [tone] picks the colour pair.
class ToneChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final ChipTone tone;
  final bool dense;
  final bool solid;

  const ToneChip({
    super.key,
    required this.label,
    this.icon,
    this.tone = ChipTone.neutral,
    this.dense = false,
    this.solid = false,
  });

  (Color bg, Color fg) get _colors {
    switch (tone) {
      case ChipTone.brand:
        return (AppColors.primarySubtle, AppColors.primary);
      case ChipTone.gold:
        return (AppColors.secondarySubtle, AppColors.secondaryDark);
      case ChipTone.success:
        return (AppColors.successSubtle, AppColors.success);
      case ChipTone.danger:
        return (AppColors.errorSubtle, AppColors.error);
      case ChipTone.info:
        return (const Color(0xFFEAF2FE), AppColors.info);
      case ChipTone.onImage:
        return (Colors.black.withValues(alpha: 0.55), Colors.white);
      case ChipTone.neutral:
        return (AppColors.divider, AppColors.textSecondary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors;
    final effectiveBg = solid ? fg : bg;
    final effectiveFg = solid ? Colors.white : fg;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 8 : 10,
        vertical: dense ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: dense ? 11 : 13, color: effectiveFg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: effectiveFg,
              fontSize: dense ? 10.5 : 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Gold gradient badge for "featured" / "special" markers.
class GoldBadge extends StatelessWidget {
  final String label;
  final IconData? icon;

  const GoldBadge({super.key, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: AppColors.goldGradient,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: AppColors.primaryDark),
            const SizedBox(width: 4),
          ],
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Buttons ─────────────────────────

enum PremiumButtonStyle { gold, navy, outline, ghost, whatsapp }

/// The app's primary action. Gradient fill plus a matching glow.
class PremiumButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool trailingIcon;
  final bool loading;
  final PremiumButtonStyle style;
  final double height;
  final bool expand;

  const PremiumButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon = false,
    this.loading = false,
    this.style = PremiumButtonStyle.gold,
    this.height = 54,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;

    Gradient? gradient;
    Color? solid;
    Color fg;
    BoxBorder? border;

    switch (style) {
      case PremiumButtonStyle.gold:
        gradient = AppColors.goldCta;
        fg = AppColors.primaryDark;
        break;
      case PremiumButtonStyle.navy:
        gradient = AppColors.primaryGradient;
        fg = Colors.white;
        break;
      case PremiumButtonStyle.whatsapp:
        solid = AppColors.whatsapp;
        fg = Colors.white;
        break;
      case PremiumButtonStyle.outline:
        solid = Colors.white;
        fg = AppColors.primary;
        border = Border.all(color: AppColors.borderStrong, width: 1.4);
        break;
      case PremiumButtonStyle.ghost:
        solid = AppColors.primarySubtle;
        fg = AppColors.primary;
        break;
    }

    final glowColor = switch (style) {
      PremiumButtonStyle.gold => AppColors.secondary,
      PremiumButtonStyle.navy => AppColors.primary,
      PremiumButtonStyle.whatsapp => AppColors.whatsapp,
      _ => null,
    };

    final label0 = Text(
      label,
      style: TextStyle(
        color: fg,
        fontSize: 15,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.1,
      ),
    );

    return Pressable(
      onTap: enabled ? onPressed : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Container(
          width: expand ? double.infinity : null,
          height: height,
          padding: expand ? null : const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            gradient: gradient,
            color: solid,
            border: border,
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: (glowColor != null && enabled)
                ? AppShadows.glow(glowColor)
                : null,
          ),
          child: Center(
            child: loading
                ? SizedBox(
                    width: 21,
                    height: 21,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation<Color>(fg),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null && !trailingIcon) ...[
                        Icon(icon, size: 18, color: fg),
                        const SizedBox(width: 8),
                      ],
                      label0,
                      if (icon != null && trailingIcon) ...[
                        const SizedBox(width: 8),
                        Icon(icon, size: 18, color: fg),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Square icon button with a tinted background.
class SoftIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final double size;
  final String? tooltip;

  const SoftIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = AppColors.primary,
    this.size = 46,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = Pressable(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(icon, color: color, size: size * 0.46),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

// ───────────────────────── Headers ─────────────────────────

/// Section heading with a gold accent bar, optional subtitle and action.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.page,
      AppSpacing.sm,
      AppSpacing.page,
      AppSpacing.md,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: subtitle == null ? 20 : 34,
            margin: const EdgeInsets.only(top: 2, right: 11),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.4,
                    height: 1.15,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (actionText != null && onAction != null)
            Pressable(
              onTap: onAction,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 1),
                child: Row(
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
                    Icon(
                      PhosphorIconsBold.caretRight,
                      size: 11,
                      color: AppColors.primary,
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

/// Plain navy app bar used by secondary screens.
class PremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final bool showBack;

  const PremiumAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.showBack = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: AppShadows.soft,
      ),
      // This bar is white, so the status bar above it needs dark glyphs.
      // Without this it inherits whatever the previous screen set and the
      // clock disappears into the background.
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                const SizedBox(width: AppSpacing.md),
                if (showBack && Navigator.canPop(context))
                  SoftIconButton(
                    icon: PhosphorIconsBold.arrowLeft,
                    size: 42,
                    onTap: () => Navigator.pop(context),
                  ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                ...actions,
                const SizedBox(width: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Detail-screen pieces ─────────────────────────

/// Sticky bottom bar holding a price and the screen's main action.
class StickyActionBar extends StatelessWidget {
  final String? priceLabel;
  final String? priceValue;
  final String? priceNote;
  final Widget action;
  final Widget? secondary;

  const StickyActionBar({
    super.key,
    this.priceLabel,
    this.priceValue,
    this.priceNote,
    required this.action,
    this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
        boxShadow: AppShadows.elevated,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.md,
            AppSpacing.page,
            AppSpacing.md,
          ),
          child: Row(
            children: [
              if (priceValue != null) ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (priceLabel != null)
                      Text(
                        priceLabel!,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    Text(
                      priceValue!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: -0.6,
                        fontFeatures: AppText.tabular,
                      ),
                    ),
                    if (priceNote != null)
                      Text(
                        priceNote!,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.lg),
              ],
              if (secondary != null) ...[
                secondary!,
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(child: action),
            ],
          ),
        ),
      ),
    );
  }
}

/// Row with a coloured tick and a line of copy — inclusion / requirement lists.
class CheckLine extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const CheckLine({
    super.key,
    required this.text,
    this.color = AppColors.success,
    this.icon = PhosphorIconsFill.checkCircle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textPrimary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact icon + label + value tile, laid out in rows of two or three.
class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: AppDecor.soft(color, radius: AppRadius.xs),
          child: Icon(icon, size: 17, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Horizontal dashed rule — the "tear line" on ticket-style cards.
class DashedDivider extends StatelessWidget {
  final Color color;
  final double height;

  const DashedDivider({
    super.key,
    this.color = AppColors.borderStrong,
    this.height = 1,
  });

  @override
  Widget build(BuildContext context) {
    // Painted rather than built from a LayoutBuilder + Row: these rules sit
    // inside ticket cards that use IntrinsicHeight, and a LayoutBuilder
    // cannot report an intrinsic size, which made the whole card fail to lay out.
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _DashedLinePainter(color: color, thickness: height),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double thickness;

  const _DashedLinePainter({required this.color, required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    const dash = 5.0;
    const gap = 4.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    final y = size.height / 2;
    for (double x = 0; x < size.width; x += dash + gap) {
      final end = (x + dash).clamp(0.0, size.width);
      canvas.drawLine(Offset(x, y), Offset(end, y), paint);
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) =>
      old.color != color || old.thickness != thickness;
}

/// Notch cut into a ticket card's edge, paired left and right.
class TicketNotch extends StatelessWidget {
  final bool left;
  final Color color;
  final double size;

  const TicketNotch({
    super.key,
    required this.left,
    this.color = AppColors.background,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size / 2,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.horizontal(
          left: left ? Radius.zero : Radius.circular(size),
          right: left ? Radius.circular(size) : Radius.zero,
        ),
      ),
    );
  }
}
