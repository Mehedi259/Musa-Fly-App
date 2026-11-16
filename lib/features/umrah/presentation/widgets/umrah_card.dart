import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../../../tours/presentation/widgets/travel_ui.dart';
import '../../data/models/umrah_model.dart';
import '../screens/umrah_package_detail_screen.dart';

class UmrahCard extends StatelessWidget {
  final UmrahModel package;

  const UmrahCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      clip: true,
      featured: true,
      margin: const EdgeInsets.only(bottom: AppSpacing.xl),
      onTap: () => context.pushPremium(UmrahPackageDetailScreen(package: package)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PhotoHeader(
            imageUrl: package.displayImage,
            fallbackUrl: AppAssets.fallbackKaaba,
            height: 206,
            title: package.cleanTitle,
            titleSize: 22,
            topLeft: const GoldBadge(
              label: 'Umrah special',
              icon: PhosphorIconsFill.crown,
            ),
            topRight: const ToneChip(
              label: '4.9',
              icon: PhosphorIconsFill.star,
              tone: ChipTone.onImage,
            ),
            belowTitle: ToneChip(
              label: package.duration,
              icon: PhosphorIconsFill.calendarBlank,
              tone: ChipTone.onImage,
              dense: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ToneChip(
                      label: 'Saudi e-Visa',
                      icon: PhosphorIconsFill.identificationCard,
                      tone: ChipTone.brand,
                      dense: true,
                    ),
                    ToneChip(
                      label: 'Return flights',
                      icon: PhosphorIconsFill.airplaneTilt,
                      tone: ChipTone.brand,
                      dense: true,
                    ),
                    ToneChip(
                      label: 'Makkah & Madinah',
                      icon: PhosphorIconsFill.buildings,
                      tone: ChipTone.brand,
                      dense: true,
                    ),
                    ToneChip(
                      label: 'Guided Ziyarah',
                      icon: PhosphorIconsFill.mosque,
                      tone: ChipTone.gold,
                      dense: true,
                    ),
                  ],
                ),
                if (package.inclusions.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    package.inclusions,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                const DashedDivider(color: AppColors.secondaryLight),
              ],
            ),
          ),
          CardPriceFooter(
            label: 'Starting at / pilgrim',
            price: CurrencyFormatter.formatSmart(package.price),
            ctaLabel: 'View package',
            goldCta: true,
          ),
        ],
      ),
    );
  }
}
