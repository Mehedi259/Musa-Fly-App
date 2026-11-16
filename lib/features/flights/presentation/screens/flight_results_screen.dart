import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/widgets/booking_ui.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../data/models/flight_model.dart';
import '../providers/flight_provider.dart';
import '../widgets/flight_card.dart';
import '../widgets/flight_header.dart';
import 'flight_booking_dialog.dart';

enum _FlightSort { recommended, cheapest, fastest, earliest }

enum _FlightFilter { all, cheap, direct, morning, evening }

/// The fare list. White page, a rail of filters, and one clean ticket per
/// flight — nothing competes with the fares themselves.
class FlightResultsScreen extends StatefulWidget {
  const FlightResultsScreen({super.key});

  @override
  State<FlightResultsScreen> createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends State<FlightResultsScreen> {
  _FlightFilter _filter = _FlightFilter.all;
  _FlightSort _sort = _FlightSort.recommended;

  static const _filterKeys = <_FlightFilter, String>{
    _FlightFilter.all: 'flights.filterAll',
    _FlightFilter.cheap: 'flights.filterCheap',
    _FlightFilter.direct: 'flights.filterDirect',
    _FlightFilter.morning: 'flights.filterMorning',
    _FlightFilter.evening: 'flights.filterEvening',
  };

  static const _sortKeys = <_FlightSort, String>{
    _FlightSort.recommended: 'flights.sortRecommended',
    _FlightSort.cheapest: 'flights.sortCheapest',
    _FlightSort.fastest: 'flights.sortFastest',
    _FlightSort.earliest: 'flights.sortEarliest',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<FlightProvider>();
      if (provider.flights.isEmpty) provider.fetchFlights();
    });
  }

  List<FlightModel> _applyFilters(List<FlightModel> source) {
    final list = source.where((f) {
      switch (_filter) {
        case _FlightFilter.cheap:
          return f.price < 150;
        case _FlightFilter.morning:
          return f.departureTime.hour < 12;
        case _FlightFilter.evening:
          return f.departureTime.hour >= 12;
        case _FlightFilter.direct:
        case _FlightFilter.all:
          return true;
      }
    }).toList();

    switch (_sort) {
      case _FlightSort.cheapest:
        list.sort((a, b) => a.price.compareTo(b.price));
      case _FlightSort.fastest:
        list.sort(
          (a, b) => a.arrivalTime
              .difference(a.departureTime)
              .compareTo(b.arrivalTime.difference(b.departureTime)),
        );
      case _FlightSort.earliest:
        list.sort((a, b) => a.departureTime.compareTo(b.departureTime));
      case _FlightSort.recommended:
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlightProvider>();
    final flights = _applyFilters(
      provider.searchResults.isNotEmpty ? provider.searchResults : provider.flights,
    );
    final loading = provider.isLoading && provider.flights.isEmpty;
    final failed = provider.errorMessage != null && provider.flights.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          FlightHeader(
            title: context.tr('flights.results'),
            subtitle: '${provider.originCode} → ${provider.destCode}',
            action: _HeaderIcon(
              icon: PhosphorIconsBold.arrowsClockwise,
              onTap: provider.fetchFlights,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: provider.fetchFlights,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: FilterChipRail(
                        labels: [
                          for (final k in _filterKeys.values) context.tr(k),
                        ],
                        index: _FlightFilter.values.indexOf(_filter),
                        onChanged: (i) =>
                            setState(() => _filter = _FlightFilter.values[i]),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _countRow(context, loading, flights.length),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.page,
                      0,
                      AppSpacing.page,
                      AppSpacing.xxxl,
                    ),
                    sliver: _content(provider, flights, loading, failed),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _countRow(BuildContext context, bool loading, int count) {
    final word = context.tr(
      count == 1 ? 'flights.optionsOne' : 'flights.optionsMany',
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.md,
        AppSpacing.page,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              loading ? context.tr('flights.searching') : '$count $word',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
                fontFeatures: AppText.tabular,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Pressable(
            onTap: _showSortSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.border),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    PhosphorIconsBold.slidersHorizontal,
                    size: 13,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 110),
                    child: Text(
                      context.tr(_sortKeys[_sort]!),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.page,
              AppSpacing.md,
              AppSpacing.page,
              AppSpacing.xl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: SheetHandle()),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  ctx.tr('flights.sortTitle'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ..._sortKeys.entries.map((e) {
                  final selected = _sort == e.key;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Pressable(
                      onTap: () {
                        setState(() => _sort = e.key);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primarySubtle : Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: selected ? AppColors.primary : AppColors.border,
                            width: selected ? 1.4 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                ctx.tr(e.value),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight:
                                      selected ? FontWeight.w800 : FontWeight.w600,
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (selected)
                              const Icon(
                                PhosphorIconsFill.checkCircle,
                                size: 20,
                                color: AppColors.primary,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(
    FlightProvider provider,
    List<FlightModel> flights,
    bool loading,
    bool failed,
  ) {
    if (loading) {
      return const SliverToBoxAdapter(
        child: Column(
          children: [
            FlightCardSkeleton(),
            FlightCardSkeleton(),
            FlightCardSkeleton(),
          ],
        ),
      );
    }

    if (failed) {
      return SliverToBoxAdapter(
        child: ErrorStateView(
          message: provider.errorMessage!,
          onRetry: provider.fetchFlights,
        ),
      );
    }

    if (flights.isEmpty) {
      final isAll = _filter == _FlightFilter.all;
      return SliverToBoxAdapter(
        child: EmptyStateView(
          icon: PhosphorIconsDuotone.airplaneTilt,
          title: context.tr('flights.noMatch'),
          message: context.tr(
            isAll ? 'flights.noMatchAll' : 'flights.noMatchFilter',
          ),
          actionText: context.tr(
            isAll ? 'flights.refreshFares' : 'flights.clearFilter',
          ),
          onAction: () {
            if (isAll) {
              provider.fetchFlights();
            } else {
              setState(() => _filter = _FlightFilter.all);
            }
          },
        ),
      );
    }

    return SliverList.builder(
      itemCount: flights.length,
      itemBuilder: (context, index) {
        final flight = flights[index];
        return FadeSlideIn(
          key: ValueKey('${flight.id}-$_filter-$_sort'),
          index: index,
          child: FlightCard(
            flight: flight,
            onBook: () => FlightBookingDialog.show(context, flight),
          ),
        );
      },
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.divider,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }
}
