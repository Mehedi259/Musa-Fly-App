import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../../../tours/presentation/widgets/travel_ui.dart';
import '../../data/models/visa_model.dart';
import '../screens/visa_detail_screen.dart';

class VisaCard extends StatelessWidget {
  final VisaModel visa;

  const VisaCard({super.key, required this.visa});

  @override
  Widget build(BuildContext context) {
    final requirements = visa.requirementList.take(2).toList();

    return PremiumCard(
      clip: true,
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      shadow: AppShadows.medium,
      onTap: () => context.pushPremium(VisaDetailScreen(visa: visa)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PhotoHeader(
            imageUrl: visa.displayImage,
            fallbackUrl: AppAssets.fallbackVisa,
            height: 168,
            title: visa.country,
            subtitle: visa.visaType,
            titleSize: 21,
            titleMaxLines: 1,
            topLeft: const ToneChip(
              label: 'Visa service',
              icon: PhosphorIconsFill.identificationCard,
              tone: ChipTone.onImage,
              dense: true,
            ),
            topRight: ToneChip(
              label: visa.formattedProcessingTime,
              icon: PhosphorIconsFill.lightning,
              tone: ChipTone.onImage,
              dense: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final req in requirements)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Icon(PhosphorIconsFill.checkCircle, size: 14, color: AppColors.success),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            req,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                const DashedDivider(),
              ],
            ),
          ),
          CardPriceFooter(
            label: 'Total visa fee',
            price: CurrencyFormatter.formatSmart(visa.price),
            ctaLabel: 'Apply now',
          ),
        ],
      ),
    );
  }
}
