import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/motion.dart';
import '../../../notifications/models/notification_model.dart';

/// Snapping campaign carousel with a parallax-free but scale-aware page
/// transition and animated page dots.
class HomeOffersCarousel extends StatefulWidget {
  final List<NotificationModel> campaigns;
  final VoidCallback onTap;

  const HomeOffersCarousel({
    super.key,
    required this.campaigns,
    required this.onTap,
  });

  @override
  State<HomeOffersCarousel> createState() => _HomeOffersCarouselState();
}

class _HomeOffersCarouselState extends State<HomeOffersCarousel> {
  static const double _height = 176;

  late final PageController _controller = PageController(viewportFraction: 0.86);
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final p = _controller.page;
      if (p != null && mounted) setState(() => _page = p);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.campaigns;
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: _height,
          child: PageView.builder(
            controller: _controller,
            itemCount: items.length,
            padEnds: false,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              // Cards just off-centre settle back a touch — gives the strip depth.
              final delta = (_page - index).abs().clamp(0.0, 1.0);
              final scale = 1 - (delta * 0.055);
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? AppSpacing.page : AppSpacing.sm,
                  right: AppSpacing.sm,
                  top: 4,
                  bottom: 4,
                ),
                child: Transform.scale(
                  scale: scale,
                  child: _OfferCard(campaign: items[index], onTap: widget.onTap),
                ),
              );
            },
          ),
        ),
        if (items.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < items.length; i++)
                  AnimatedContainer(
                    duration: AppMotion.base,
                    curve: AppMotion.ease,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _page.round() == i ? 22 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: _page.round() == i ? AppColors.goldGradient : null,
                      color: _page.round() == i ? null : AppColors.borderStrong,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _OfferCard extends StatelessWidget {
  final NotificationModel campaign;
  final VoidCallback onTap;

  const _OfferCard({required this.campaign, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.98,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.medium,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppNetworkImage(imageUrl: campaign.image, fit: BoxFit.cover),
              const DecoratedBox(
                decoration: BoxDecoration(gradient: AppColors.imageScrim),
              ),
              Positioned(
                top: AppSpacing.md,
                left: AppSpacing.md,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(PhosphorIconsFill.sparkle, size: 11, color: AppColors.primaryDark),
                      const SizedBox(width: 5),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 150),
                        child: Text(
                          campaign.badgeText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: AppSpacing.lg,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      campaign.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'View offer',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          PhosphorIconsBold.arrowRight,
                          size: 11,
                          color: Colors.white.withValues(alpha: 0.9),
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
