import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/widgets/motion.dart';
import '../../../tours/presentation/widgets/travel_ui.dart';
import '../../data/models/visa_model.dart';
import '../providers/visa_provider.dart';
import '../widgets/visa_card.dart';

class VisaScreen extends StatefulWidget {
  const VisaScreen({super.key});

  @override
  State<VisaScreen> createState() => _VisaScreenState();
}

class _VisaScreenState extends State<VisaScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<VisaProvider>(context, listen: false);
      if (provider.visas.isEmpty) {
        provider.fetchVisas();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VisaProvider>(context);

    final filteredVisas = provider.visas.where((v) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return v.country.toLowerCase().contains(q) ||
          v.visaType.toLowerCase().contains(q) ||
          (v.requirements?.toLowerCase().contains(q) ?? false);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => provider.fetchVisas(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: ListHero(
                eyebrow: 'Visa services',
                title: 'Visas handled\nfrom form to stamp',
                subtitle:
                    'Document checks, embassy submission and status updates — handled by our consultants.',
                icon: PhosphorIconsFill.identificationCard,
                searchHint: 'Search Malaysia, Oman, Singapore…',
                onSearchChanged: (val) => setState(() => _searchQuery = val),
                onRefresh: () => provider.fetchVisas(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.xl,
                AppSpacing.page,
                AppSpacing.xxxl,
              ),
              sliver: SliverToBoxAdapter(child: _content(provider, filteredVisas)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(VisaProvider provider, List<VisaModel> filteredVisas) {
    if (provider.isLoading && provider.visas.isEmpty) {
      return const Column(
        children: [
          PhotoCardSkeleton(imageHeight: 168),
          PhotoCardSkeleton(imageHeight: 168),
        ],
      );
    }

    if (provider.errorMessage != null && provider.visas.isEmpty) {
      return FeatureStatePanel(
        icon: PhosphorIconsRegular.warningCircle,
        title: "Couldn't load visa services",
        message: provider.errorMessage!,
        actionLabel: 'Try again',
        isError: true,
        onAction: () => provider.fetchVisas(),
      );
    }

    if (filteredVisas.isEmpty) {
      return FeatureStatePanel(
        icon: PhosphorIconsRegular.identificationCard,
        title: _searchQuery.isEmpty ? 'No visa services yet' : 'Nothing matched',
        message: _searchQuery.isEmpty
            ? 'No visa services are published right now. Pull to refresh or check back soon.'
            : 'No country matches "$_searchQuery". Try another destination.',
        actionLabel: _searchQuery.isEmpty ? 'Refresh' : 'Clear search',
        onAction: () {
          if (_searchQuery.isEmpty) {
            provider.fetchVisas();
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
          count: filteredVisas.length,
          singular: 'destination',
          trailing: 'Expert document check',
        ),
        for (var i = 0; i < filteredVisas.length; i++)
          FadeSlideIn(index: i, child: VisaCard(visa: filteredVisas[i])),
      ],
    );
  }
}
