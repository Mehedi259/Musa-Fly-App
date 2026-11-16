import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/motion.dart';
import '../../data/models/umrah_model.dart';
import '../screens/umrah_package_detail_screen.dart';

/// Minimal, high-end Umrah card: serene photo, clean typography, concise
/// inclusions, and clear OMR pricing without badge or chip clutter.
class UmrahCard extends StatelessWidget {
  final UmrahModel package;

  const UmrahCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    final isVip = package.packageName.toLowerCase().contains('vip') ||
        package.packageName.toLowerCase().contains('executive') ||
        package.packageName.toLowerCase().contains('5★');

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Pressable(
        onTap: () => context.pushPremium(UmrahPackageDetailScreen(package: package)),
        scale: 0.985,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header Photo ──
              SizedBox(
                height: 180,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppNetworkImage(
                      imageUrl: package.displayImage,
                      fallbackUrl: AppAssets.fallbackKaaba,
                      fit: BoxFit.cover,
                    ),
                    // Subtle dark gradient over image for contrast
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.35),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                    ),
                    // Top-Left Badge
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isVip ? AppColors.secondary : AppColors.primaryDark.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isVip ? PhosphorIconsFill.crown : PhosphorIconsFill.mosque,
                              size: 13,
                              color: isVip ? AppColors.primaryDark : Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isVip
                                  ? context.pick('5★ Executive', '৫★ এক্সিকিউটিভ')
                                  : context.pick('Umrah Special', 'উমরাহ স্পেশাল'),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isVip ? AppColors.primaryDark : Colors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Top-Right Rating
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(PhosphorIconsFill.star, size: 12, color: Color(0xFFFFB800)),
                            SizedBox(width: 4),
                            Text(
                              '4.9',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bottom-Left Duration Pill on Photo
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4.5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              PhosphorIconsFill.calendarBlank,
                              size: 13,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              package.duration,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Clean Body ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.cleanTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Concise 2-line feature bullet points
                    _InclusionRow(
                      icon: PhosphorIconsFill.buildings,
                      text: context.pick(
                        'Makkah & Madinah Premium Hotel Stays',
                        'মক্কা ও মদিনায় প্রিমিয়াম হোটেল সুবিধা',
                      ),
                    ),
                    const SizedBox(height: 4),
                    _InclusionRow(
                      icon: PhosphorIconsFill.sealCheck,
                      text: context.pick(
                        'Saudi e-Visa, Direct Flights & Transport Included',
                        'সৌদি ই-ভিসা, সরাসরি ফ্লাইট ও ট্রান্সপোর্ট অন্তর্ভুক্ত',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Clean Price & Action Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.pick('STARTING AT', 'শুরু হচ্ছে'),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              CurrencyFormatter.formatSmart(package.price),
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                                letterSpacing: -0.5,
                                fontFeatures: AppText.tabular,
                              ),
                            ),
                            if (context.isBangla)
                              Text(
                                '≈ ${CurrencyFormatter.convertOmrToBdt(package.price, banglaDigits: true)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                  fontFeatures: AppText.tabular,
                                ),
                              ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: AppColors.goldCta,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            boxShadow: AppShadows.glow(AppColors.secondary, opacity: 0.25),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                context.pick('View Details', 'বিস্তারিত দেখুন'),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                PhosphorIconsBold.arrowRight,
                                size: 13,
                                color: AppColors.primaryDark,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InclusionRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InclusionRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.success),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
