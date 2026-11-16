import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../../data/models/tour_model.dart';
import '../screens/tour_detail_screen.dart';
import 'travel_ui.dart';

class TourCard extends StatelessWidget {
  final TourModel tour;
  final bool isHorizontal;

  const TourCard({
    super.key,
    required this.tour,
    this.isHorizontal = false,
  });

  void _open(BuildContext context) => context.pushPremium(TourDetailScreen(tour: tour));

  @override
  Widget build(BuildContext context) =>
      isHorizontal ? _horizontal(context) : _vertical(context);

  Widget _horizontal(BuildContext context) {
    return SizedBox(
      width: 262,
      child: PremiumCard(
        clip: true,
        margin: const EdgeInsets.only(right: AppSpacing.lg, bottom: 4),
        shadow: AppShadows.medium,
        onTap: () => _open(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            PhotoHeader(
              imageUrl: tour.displayImage,
              fallbackUrl: AppAssets.fallbackTour,
              height: 156,
              title: tour.destination,
              titleSize: 17,
              titleMaxLines: 1,
              topLeft: ToneChip(
                label: tour.duration,
                icon: PhosphorIconsFill.clock,
                tone: ChipTone.onImage,
                dense: true,
              ),
              topRight: const ToneChip(
                label: '4.8',
                icon: PhosphorIconsFill.star,
                tone: ChipTone.onImage,
                dense: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
              child: Text(
                tour.inclusions.isEmpty ? 'Flights, stay & transfers arranged' : tour.inclusions,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ),
            CardPriceFooter(
              label: context.pick('Starting at', 'শুরু হচ্ছে'),
              price: CurrencyFormatter.formatSmart(tour.price),
              note: context.isBangla
                  ? '≈ ${CurrencyFormatter.convertOmrToBdt(tour.price, banglaDigits: true)}'
                  : null,
              ctaLabel: context.pick('View', 'দেখুন'),
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vertical(BuildContext context) {
    return PremiumCard(
      clip: true,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      shadow: AppShadows.medium,
      onTap: () => _open(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PhotoHeader(
            imageUrl: tour.displayImage,
            fallbackUrl: AppAssets.fallbackTour,
            height: 208,
            title: tour.destination,
            titleSize: 22,
            titleMaxLines: 2,
            topLeft: ToneChip(
              label: tour.duration,
              icon: PhosphorIconsFill.clock,
              tone: ChipTone.onImage,
            ),
            topRight: const ToneChip(
              label: '4.8',
              icon: PhosphorIconsFill.star,
              tone: ChipTone.onImage,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tour.inclusions.isEmpty
                      ? 'Hotels, airport transfers and guided sightseeing included.'
                      : tour.inclusions,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Icon(PhosphorIconsFill.sealCheck, size: 15, color: AppColors.success),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Verified operator · free cancellation',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const DashedDivider(),
              ],
            ),
          ),
          CardPriceFooter(
            label: context.pick('Starting at / person', 'শুরু হচ্ছে / প্রতি জন'),
            price: CurrencyFormatter.formatSmart(tour.price),
            note: context.isBangla
                ? '≈ ${CurrencyFormatter.convertOmrToBdt(tour.price, banglaDigits: true)}'
                : null,
            ctaLabel: context.pick('View details', 'বিস্তারিত দেখুন'),
          ),
        ],
      ),
    );
  }
}
