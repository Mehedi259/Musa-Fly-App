import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/widgets/motion.dart';

/// Plain white page header: a back chevron on the left, the page name centred,
/// and nothing else. The heavy navy bar is deliberately gone — the white page
/// is what makes the form below it read as airy.
class FlightHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  /// Optional control pinned to the right edge. The title stays centred
  /// whether or not one is given.
  final Widget? action;

  const FlightHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
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
              AppSpacing.sm,
            ),
            child: SizedBox(
              height: 48,
              child: Stack(
                children: [
                  // Centred title, inset past the side controls so a long
                  // Bangla title never runs under them.
                  Positioned.fill(
                    left: 56,
                    right: 56,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textSecondary,
                              fontFeatures: AppText.tabular,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (canPop)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Pressable(
                        onTap: () => Navigator.pop(context),
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(
                            PhosphorIconsBold.caretLeft,
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  if (action != null)
                    Align(alignment: Alignment.centerRight, child: action!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The grab handle every flight sheet starts with.
class SheetHandle extends StatelessWidget {
  const SheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.borderStrong,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
