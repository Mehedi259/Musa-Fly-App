import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_design.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/widgets/motion.dart';
import '../../../core/widgets/premium.dart';

/// Pieces shared by the four booking-desk surfaces (bookings, support, auth
/// and notifications). They live here, next to `services_strings.dart`, for
/// the same reason that file does: one place, four features.
///
/// The look is deliberately plain — white page, a centred title, hairline
/// rules — because the heavy navy slabs these replaced were what made the
/// app read as amateur next to the apps we are measured against.

// ───────────────────────── Page header ─────────────────────────

/// Centred page title on white, with a back chevron when there is something
/// to go back to. [trailing] is balanced against the chevron so the title
/// stays optically centred whether or not either is present.
class ServicePageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  /// Forces the chevron off even when the route can pop (tab roots).
  final bool showBack;

  const ServicePageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.showBack = true,
  });

  static const double _slot = 44;

  @override
  Widget build(BuildContext context) {
    final canPop = showBack && Navigator.canPop(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      // White page behind the status bar, so its glyphs have to be dark.
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Container(
        color: Colors.white,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: _slot,
                  child: canPop
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: ServiceBackButton(onTap: () => Navigator.pop(context)),
                        )
                      : null,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(
                  width: _slot,
                  child: trailing == null
                      ? null
                      : Align(alignment: Alignment.centerRight, child: trailing),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Outlined circular chevron — the back affordance on every white page here.
class ServiceBackButton extends StatelessWidget {
  final VoidCallback onTap;

  const ServiceBackButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(
          PhosphorIconsBold.caretLeft,
          size: 17,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

// ───────────────────────── Rows ─────────────────────────

/// Full-width settings-style row: soft icon, title, value, chevron. Used for
/// the help centre's language and contact rows.
class ServiceListRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;
  final Color accent;
  final bool divider;

  const ServiceListRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
    this.accent = AppColors.primary,
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
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md + 2,
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: AppDecor.soft(accent, radius: AppRadius.sm),
                  child: Icon(icon, color: accent, size: 18),
                ),
                const SizedBox(width: AppSpacing.md + 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(PhosphorIconsBold.caretRight, size: 13, color: AppColors.textMuted),
              ],
            ),
          ),
        ),
        if (divider)
          const Padding(
            padding: EdgeInsets.only(left: 68, right: AppSpacing.lg),
            child: Divider(height: 1, thickness: 1, color: AppColors.divider),
          ),
      ],
    );
  }
}

// ───────────────────────── Form input ─────────────────────────

/// The editable twin of `BookingField`: same small uppercase label over a
/// large value, same hairline rule, but you can type in it.
class BookingInput extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? placeholder;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final bool divider;

  const BookingInput({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    this.placeholder,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.divider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md + 2,
            AppSpacing.xl,
            AppSpacing.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Icon(icon, size: 18, color: AppColors.textMuted),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.9,
                        color: AppColors.textMuted,
                      ),
                    ),
                    TextFormField(
                      controller: controller,
                      keyboardType: keyboardType,
                      textInputAction: textInputAction,
                      textCapitalization: textCapitalization,
                      validator: validator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      cursorColor: AppColors.primary,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                        height: 1.2,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.only(top: 4, bottom: 2),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        hintText: placeholder,
                        hintStyle: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.4,
                          color: AppColors.textMuted,
                        ),
                        errorStyle: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                        ),
                        errorMaxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
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

// ───────────────────────── Empty / error ─────────────────────────

/// Centred illustration, title, body and an optional action — the one empty
/// state these four screens share.
class ServiceMessageState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Color tint;
  final Widget? action;
  final EdgeInsetsGeometry padding;

  const ServiceMessageState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.tint = AppColors.primary,
    this.action,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.xxxl,
      AppSpacing.xxxl,
      AppSpacing.xxxl,
      AppSpacing.xxxl,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: tint.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: tint),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// One-line snack bar in the app's voice — used by the inquiry form and the
/// sign-in sheet so success and failure read the same everywhere.
SnackBar serviceSnack(String message, {required bool success}) {
  return SnackBar(
    content: Row(
      children: [
        Icon(
          success ? PhosphorIconsFill.checkCircle : PhosphorIconsFill.warningCircle,
          color: Colors.white,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
    backgroundColor: success ? AppColors.success : AppColors.error,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
  );
}

/// Thin wrapper so screens can show a white card without repeating the
/// padding/:radius pair.
class ServiceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const ServiceCard({super.key, required this.child, this.padding = EdgeInsets.zero});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(padding: padding, child: child);
  }
}
