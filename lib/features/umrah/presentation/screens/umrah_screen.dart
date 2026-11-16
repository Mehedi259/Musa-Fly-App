import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../../../tours/presentation/widgets/travel_ui.dart';
import '../providers/umrah_provider.dart';
import '../widgets/umrah_card.dart';

class UmrahScreen extends StatefulWidget {
  const UmrahScreen({super.key});

  @override
  State<UmrahScreen> createState() => _UmrahScreenState();
}

class _UmrahScreenState extends State<UmrahScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UmrahProvider>(context, listen: false);
      if (provider.packages.isEmpty) {
        provider.fetchPackages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UmrahProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => provider.fetchPackages(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: ListHero(
                eyebrow: 'Blessed journey',
                title: 'Umrah packages,\narranged with care',
                subtitle:
                    'Saudi e-Visa, direct flights, hotels within walking distance of the Haram and guided Ziyarah.',
                icon: PhosphorIconsFill.mosque,
                onRefresh: () => provider.fetchPackages(),
                highlights: const ['Visa included', 'Licensed operator', 'Group & family'],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.xl,
                AppSpacing.page,
                AppSpacing.xxxl,
              ),
              sliver: SliverToBoxAdapter(child: _content(provider)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(UmrahProvider provider) {
    if (provider.isLoading && provider.packages.isEmpty) {
      return const Column(
        children: [
          PhotoCardSkeleton(imageHeight: 206),
          PhotoCardSkeleton(imageHeight: 206),
        ],
      );
    }

    if (provider.errorMessage != null && provider.packages.isEmpty) {
      return FeatureStatePanel(
        icon: PhosphorIconsRegular.warningCircle,
        title: "Couldn't load packages",
        message: provider.errorMessage!,
        actionLabel: 'Try again',
        isError: true,
        onAction: () => provider.fetchPackages(),
      );
    }

    if (provider.packages.isEmpty) {
      return FeatureStatePanel(
        icon: PhosphorIconsRegular.mosque,
        title: 'No packages published',
        message:
            'No Umrah packages are available right now. Pull to refresh, or speak to an advisor on WhatsApp.',
        actionLabel: 'Refresh',
        onAction: () => provider.fetchPackages(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Featured packages',
          subtitle: 'Every package includes visa, flights and hotel',
          padding: EdgeInsets.only(bottom: AppSpacing.md),
        ),
        ResultCountRow(
          count: provider.packages.length,
          singular: 'package',
          trailing: 'Hajj & Umrah licensed',
        ),
        for (var i = 0; i < provider.packages.length; i++)
          FadeSlideIn(index: i, child: UmrahCard(package: provider.packages[i])),
      ],
    );
  }
}
