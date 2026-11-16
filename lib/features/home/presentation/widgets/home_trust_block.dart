import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/widgets/premium.dart';

/// "Why travel with us" reassurance panel plus the WhatsApp concierge CTA.
class HomeTrustBlock extends StatelessWidget {
  final VoidCallback onWhatsApp;
  final VoidCallback onHelpCentre;

  const HomeTrustBlock({
    super.key,
    required this.onWhatsApp,
    required this.onHelpCentre,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
      child: PremiumCard(
        padding: const EdgeInsets.all(AppSpacing.xl),
        shadow: AppShadows.medium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(
                    PhosphorIconsFill.crownSimple,
                    size: 17,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                const Expanded(
                  child: Text(
                    'Why travel with MusaFly?',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _BenefitRow(
              icon: PhosphorIconsDuotone.sealCheck,
              color: AppColors.primary,
              title: 'Verified travel partner',
              subtitle: 'Official airline ticket distributor and Umrah organiser.',
            ),
            const _BenefitDivider(),
            _BenefitRow(
              icon: PhosphorIconsDuotone.currencyCircleDollar,
              color: AppColors.secondaryDark,
              title: 'Best price guarantee',
              subtitle: 'Transparent fares — no hidden charges at checkout.',
            ),
            const _BenefitDivider(),
            _BenefitRow(
              icon: PhosphorIconsDuotone.headset,
              color: AppColors.catUmrah,
              title: '24/7 VIP concierge',
              subtitle: 'Real people on WhatsApp and phone, any hour.',
            ),
            const SizedBox(height: AppSpacing.xl),
            PremiumButton(
              label: 'Chat with concierge',
              icon: PhosphorIconsFill.whatsappLogo,
              style: PremiumButtonStyle.whatsapp,
              height: 52,
              onPressed: onWhatsApp,
            ),
            const SizedBox(height: AppSpacing.sm + 2),
            PremiumButton(
              label: 'Help centre & FAQs',
              icon: PhosphorIconsBold.caretRight,
              trailingIcon: true,
              style: PremiumButtonStyle.ghost,
              height: 50,
              onPressed: onHelpCentre,
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitDivider extends StatelessWidget {
  const _BenefitDivider();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: DashedDivider(color: AppColors.divider),
      );
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _BenefitRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: AppDecor.soft(color, radius: AppRadius.sm),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
