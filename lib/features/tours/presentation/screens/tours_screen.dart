import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/widgets/motion.dart';
import '../../data/models/tour_model.dart';
import '../providers/tour_provider.dart';
import '../widgets/tour_card.dart';
import '../widgets/travel_ui.dart';

class ToursScreen extends StatefulWidget {
  const ToursScreen({super.key});

  @override
  State<ToursScreen> createState() => _ToursScreenState();
}

class _ToursScreenState extends State<ToursScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TourProvider>(context, listen: false);
      if (provider.tours.isEmpty) {
        provider.fetchTours();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TourProvider>(context);

    final filteredTours = provider.tours.where((t) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return t.destination.toLowerCase().contains(q) ||
          t.inclusions.toLowerCase().contains(q) ||
          t.duration.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => provider.fetchTours(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: ListHero(
                eyebrow: 'Holidays & Tours',
                title: 'Curated escapes,\nplanned end to end',
                subtitle:
                    'Hand-picked holiday packages with flights, hotels, transfers and guided sightseeing.',
                icon: PhosphorIconsFill.airplaneTilt,
                searchHint: 'Search Dubai, Maldives, Alps…',
                onSearchChanged: (val) => setState(() => _searchQuery = val),
                onRefresh: () => provider.fetchTours(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.xl,
                AppSpacing.page,
                AppSpacing.xxxl,
              ),
              sliver: SliverToBoxAdapter(child: _content(provider, filteredTours)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(TourProvider provider, List<TourModel> filteredTours) {
    if (provider.isLoading && provider.tours.isEmpty) {
      return const Column(
        children: [
          PhotoCardSkeleton(imageHeight: 208),
          PhotoCardSkeleton(imageHeight: 208),
        ],
      );
    }

    if (provider.errorMessage != null && provider.tours.isEmpty) {
      return FeatureStatePanel(
        icon: PhosphorIconsRegular.warningCircle,
        title: "Couldn't load tours",
        message: provider.errorMessage!,
        actionLabel: 'Try again',
        isError: true,
        onAction: () => provider.fetchTours(),
      );
    }

    if (filteredTours.isEmpty) {
      return FeatureStatePanel(
        icon: PhosphorIconsRegular.binoculars,
        title: _searchQuery.isEmpty ? 'No tours yet' : 'Nothing matched',
        message: _searchQuery.isEmpty
            ? 'No holiday packages are published right now. Pull to refresh or check back soon.'
            : 'No packages match "$_searchQuery". Try a different destination.',
        actionLabel: _searchQuery.isEmpty ? 'Refresh' : 'Clear search',
        onAction: () {
          if (_searchQuery.isEmpty) {
            provider.fetchTours();
          } else {
            setState(() => _searchQuery = '');
          }
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResultCountRow(
          count: filteredTours.length,
          singular: 'package',
          trailing: 'Best price promise',
        ),
        for (var i = 0; i < filteredTours.length; i++)
          FadeSlideIn(index: i, child: TourCard(tour: filteredTours[i])),
      ],
    );
  }
}
