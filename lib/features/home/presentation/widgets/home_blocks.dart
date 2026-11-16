import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';

// ──────────────────────── Quick Action Pills ────────────────────────

/// Neat pill badges sitting directly below the 4 service tiles.
class HomeQuickPills extends StatelessWidget {
  final VoidCallback onGiftCard;
  final VoidCallback onUmrahInquiry;

  const HomeQuickPills({
    super.key,
    required this.onGiftCard,
    required this.onUmrahInquiry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            _QuickPillItem(
              icon: PhosphorIconsDuotone.gift,
              iconColor: AppColors.catFlight,
              label: context.tr('home.quick.giftCard'),
              onTap: onGiftCard,
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            _QuickPillItem(
              icon: PhosphorIconsDuotone.mosque,
              iconColor: AppColors.catUmrah,
              label: context.tr('home.quick.umrahInquiry'),
              onTap: onUmrahInquiry,
            ),
            const SizedBox(width: AppSpacing.sm + 2),
            _QuickPillItem(
              icon: PhosphorIconsDuotone.tag,
              iconColor: AppColors.secondaryDark,
              label: 'Seasonal Discounts',
              onTap: onGiftCard,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickPillItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _QuickPillItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.96,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────── Video Tutorial Cards ────────────────────────

/// Interactive video guide strip with phone mockup ("কিভাবে ফ্লাইট বুক করবেন?").
class HomeVideoGuideSection extends StatelessWidget {
  final VoidCallback onOpenGuide;

  const HomeVideoGuideSection({super.key, required this.onOpenGuide});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 126,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
        children: [
          _VideoGuideCard(
            title: context.tr('home.video.title'),
            ctaLabel: context.tr('home.video.cta'),
            accentColor: AppColors.secondary,
            onTap: onOpenGuide,
          ),
          const SizedBox(width: AppSpacing.md),
          _VideoGuideCard(
            title: 'উমরাহ প্যাকেজ বুকিং করবেন কিভাবে?',
            ctaLabel: context.tr('home.video.cta'),
            accentColor: AppColors.catUmrah,
            isUmrah: true,
            onTap: onOpenGuide,
          ),
        ],
      ),
    );
  }
}

class _VideoGuideCard extends StatelessWidget {
  final String title;
  final String ctaLabel;
  final Color accentColor;
  final bool isUmrah;
  final VoidCallback onTap;

  const _VideoGuideCard({
    required this.title,
    required this.ctaLabel,
    required this.accentColor,
    this.isUmrah = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.98,
      child: Container(
        width: 290,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Retina-drawn mini smartphone mockup illustrating flight search
            Container(
              width: 72,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: const Color(0xFF334155), width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md - 1),
                child: Column(
                  children: [
                    Container(
                      height: 14,
                      color: isUmrah ? AppColors.catUmrah : AppColors.primary,
                      child: Center(
                        child: Container(
                          width: 18,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        color: const Color(0xFFF8FAFC),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 10,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(3),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Center(
                                child: Icon(
                                  isUmrah
                                      ? PhosphorIconsFill.mosque
                                      : PhosphorIconsFill.airplaneTilt,
                                  size: 7,
                                  color: isUmrah
                                      ? AppColors.catUmrah
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Center(
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.secondary,
                                ),
                                child: const Icon(
                                  PhosphorIconsFill.play,
                                  size: 10,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Text & CTA
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                      letterSpacing: -0.3,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldCta,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondary.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          PhosphorIconsFill.play,
                          size: 11,
                          color: AppColors.primaryDark,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ctaLabel,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────── Hot Deals Carousel ────────────────────────

class DealOfferItem {
  final String discountBadge;
  final String title;
  final IconData icon;
  final Color badgeColor;
  final VoidCallback onTap;

  const DealOfferItem({
    required this.discountBadge,
    required this.title,
    required this.icon,
    required this.badgeColor,
    required this.onTap,
  });
}

class HomeHotDealsCarousel extends StatelessWidget {
  final List<DealOfferItem> deals;

  const HomeHotDealsCarousel({super.key, required this.deals});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 118,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
        itemCount: deals.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, i) => _DealCard(deal: deals[i]),
      ),
    );
  }
}

class _DealCard extends StatelessWidget {
  final DealOfferItem deal;

  const _DealCard({required this.deal});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: deal.onTap,
      scale: 0.98,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left navy discount badge
            Container(
              width: 82,
              height: double.infinity,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: deal.badgeColor,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    deal.discountBadge,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Icon(deal.icon, color: Colors.white, size: 20),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Right description and View Details link
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    deal.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.25,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        PhosphorIconsBold.arrowUpRight,
                        size: 13,
                        color: AppColors.primaryLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.tr('action.viewDetails'),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryLight,
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
    );
  }
}

// ──────────────────────── Special Offers Horizontal Strip ────────────────────────

class SpecialOfferItem {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final String? badge;
  final VoidCallback onTap;

  const SpecialOfferItem({
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.badge,
    required this.onTap,
  });
}

class HomeSpecialOffersCarousel extends StatelessWidget {
  final List<SpecialOfferItem> offers;

  const HomeSpecialOffersCarousel({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
        itemCount: offers.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, i) => _SpecialOfferCard(offer: offers[i]),
      ),
    );
  }
}

class _SpecialOfferCard extends StatelessWidget {
  final SpecialOfferItem offer;

  const _SpecialOfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    final hasImage = offer.imageUrl != null && offer.imageUrl!.isNotEmpty;

    return Pressable(
      onTap: offer.onTap,
      scale: 0.98,
      child: Container(
        width: 255,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (hasImage)
                    AppNetworkImage(imageUrl: offer.imageUrl, fit: BoxFit.cover)
                  else
                    Container(
                      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                      child: const Center(
                        child: Icon(
                          PhosphorIconsDuotone.airplaneTilt,
                          color: Colors.white54,
                          size: 32,
                        ),
                      ),
                    ),
                  if (offer.badge != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: Text(
                          offer.badge!,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.25,
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (offer.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      offer.subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────── Featured Section (Gift Cards & VIP Club) ────────────────────────

class HomeFeaturedStrip extends StatelessWidget {
  final VoidCallback onGiftCards;
  final VoidCallback onClubLimitless;

  const HomeFeaturedStrip({
    super.key,
    required this.onGiftCards,
    required this.onClubLimitless,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 156,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
        children: [
          _FeaturedBanner(
            title: 'INTRODUCING GIFT CARDS',
            subtitle: 'Gift experiences that last a lifetime',
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            icon: PhosphorIconsFill.gift,
            onTap: onGiftCards,
          ),
          const SizedBox(width: AppSpacing.md),
          _FeaturedBanner(
            title: 'MUSFLY VIP CONCIERGE',
            subtitle: 'Verified 5-Star Umrah ground handlers in Makkah',
            gradient: const LinearGradient(
              colors: [Color(0xFF064E3B), Color(0xFF047857)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            icon: PhosphorIconsFill.sparkle,
            onTap: onClubLimitless,
          ),
        ],
      ),
    );
  }
}

class _FeaturedBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final Gradient gradient;
  final IconData icon;
  final VoidCallback onTap;

  const _FeaturedBanner({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.98,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDark.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: AppColors.secondaryLight, size: 20),
            ),
            const Spacer(),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.85),
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────── Campaign Banner ────────────────────────

/// Wide photographic campaign banner.
class HomeCampaignBanner extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? subtitle;
  final String? badge;
  final VoidCallback onTap;

  const HomeCampaignBanner({
    super.key,
    required this.imageUrl,
    required this.onTap,
    this.title,
    this.subtitle,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final headline = (title != null && title!.trim().isNotEmpty)
        ? title!.trim()
        : context.tr('home.campaign.title');
    final body = (subtitle != null && subtitle!.trim().isNotEmpty)
        ? subtitle!.trim()
        : context.tr('home.campaign.subtitle');
    final badgeLabel = (badge != null && badge!.trim().isNotEmpty)
        ? badge!.trim()
        : context.tr('home.campaign.eyebrow');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
      child: Pressable(
        onTap: onTap,
        child: Container(
          height: 174,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: AppShadows.medium,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasImage)
                AppNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover)
              else
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF0284C7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              const DecoratedBox(
                decoration: BoxDecoration(gradient: AppColors.imageScrim),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: GoldBadge(label: badgeLabel, icon: PhosphorIconsFill.sparkle),
                    ),
                    const Spacer(),
                    Text(
                      headline,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.goldCta,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              context.tr('home.campaign.cta'),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            PhosphorIconsBold.arrowRight,
                            size: 12,
                            color: AppColors.primaryDark,
                          ),
                        ],
                      ),
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
