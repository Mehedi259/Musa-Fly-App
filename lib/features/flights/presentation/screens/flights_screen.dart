import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../data/models/flight_model.dart';
import '../providers/flight_provider.dart';
import '../widgets/flight_card.dart';
import '../widgets/flight_search_card.dart';
import 'flight_booking_dialog.dart';

enum _FlightSort { recommended, cheapest, fastest, earliest }

class FlightsScreen extends StatefulWidget {
  const FlightsScreen({super.key});

  @override
  State<FlightsScreen> createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
  String _selectedFilter = 'All';
  _FlightSort _sort = _FlightSort.recommended;

  static const _filters = <String, IconData>{
    'All': PhosphorIconsRegular.squaresFour,
    'Under \$500': PhosphorIconsRegular.tag,
    'Direct Flights': PhosphorIconsRegular.airplaneTilt,
    'Morning': PhosphorIconsRegular.sun,
    'Evening': PhosphorIconsRegular.moon,
  };

  static const _sortLabels = <_FlightSort, String>{
    _FlightSort.recommended: 'Recommended',
    _FlightSort.cheapest: 'Cheapest',
    _FlightSort.fastest: 'Fastest',
    _FlightSort.earliest: 'Earliest',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<FlightProvider>(context, listen: false);
      if (provider.flights.isEmpty) {
        provider.fetchFlights();
      }
    });
  }

  List<FlightModel> _applyFilters(List<FlightModel> source) {
    final list = source.where((f) {
      switch (_selectedFilter) {
        case 'Under \$500':
          return f.price < 500;
        case 'Morning':
          return f.departureTime.hour < 12;
        case 'Evening':
          return f.departureTime.hour >= 12;
        case 'Direct Flights':
        case 'All':
        default:
          return true;
      }
    }).toList();

    switch (_sort) {
      case _FlightSort.cheapest:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case _FlightSort.fastest:
        list.sort(
          (a, b) => a.arrivalTime
              .difference(a.departureTime)
              .compareTo(b.arrivalTime.difference(b.departureTime)),
        );
        break;
      case _FlightSort.earliest:
        list.sort((a, b) => a.departureTime.compareTo(b.departureTime));
        break;
      case _FlightSort.recommended:
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlightProvider>(context);
    final displayFlights = _applyFilters(provider.flights);
    final loading = provider.isLoading && provider.flights.isEmpty;
    final failed = provider.errorMessage != null && provider.flights.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PremiumAppBar(
        title: 'Flight Booking',
        subtitle: '${provider.originCode} → ${provider.destCode}',
        actions: [
          SoftIconButton(
            icon: PhosphorIconsBold.arrowsClockwise,
            size: 42,
            tooltip: 'Refresh',
            onTap: () => provider.fetchFlights(),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => provider.fetchFlights(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.lg,
                AppSpacing.page,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: FadeSlideIn(
                  child: FlightSearchCard(
                    provider: provider,
                    onSearch: () => _onSearch(provider),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FadeSlideIn(
                index: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xxl),
                  child: _resultsHeader(loading, displayFlights.length),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: FadeSlideIn(index: 2, child: _chipRail()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.lg,
                AppSpacing.page,
                AppSpacing.xxxl,
              ),
              sliver: _content(provider, displayFlights, loading, failed),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearch(FlightProvider provider) {
    provider.executeSearch();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              PhosphorIconsFill.airplaneTilt,
              size: 16,
              color: AppColors.secondaryLight,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Searching ${provider.originCode} → ${provider.destCode}…',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ───────────────────────── Header & chips ─────────────────────────

  Widget _resultsHeader(bool loading, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        0,
        AppSpacing.page,
        AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available flights',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  loading
                      ? 'Finding the best fares…'
                      : '$count option${count == 1 ? '' : 's'} · ${_sortLabels[_sort]}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                    fontFeatures: AppText.tabular,
                  ),
                ),
              ],
            ),
          ),
          Pressable(
            onTap: _showSortSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.border),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    PhosphorIconsBold.slidersHorizontal,
                    size: 13,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Sort',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
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

  Widget _chipRail() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final entry = _filters.entries.elementAt(index);
          final selected = _selectedFilter == entry.key;
          return Pressable(
            onTap: () => setState(() => _selectedFilter = entry.key),
            child: AnimatedContainer(
              duration: AppMotion.fast,
              curve: AppMotion.ease,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                ),
                boxShadow: selected
                    ? AppShadows.glow(AppColors.primary, opacity: 0.2)
                    : AppShadows.soft,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    entry.value,
                    size: 14,
                    color: selected ? Colors.white : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      color: selected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderStrong,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text(
                  'Sort results',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ..._sortLabels.entries.map((e) {
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
                          color: selected
                              ? AppColors.primarySubtle
                              : Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : AppColors.border,
                            width: selected ? 1.4 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                e.value,
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: selected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (selected)
                              Icon(
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

  // ───────────────────────── Content states ─────────────────────────

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
          onRetry: () => provider.fetchFlights(),
        ),
      );
    }

    if (flights.isEmpty) {
      return SliverToBoxAdapter(
        child: EmptyStateView(
          icon: PhosphorIconsDuotone.airplaneTilt,
          title: 'No flights match',
          message: _selectedFilter == 'All'
              ? 'Try a different destination or refresh for the latest fares.'
              : 'Nothing fits the "$_selectedFilter" filter right now.',
          actionText: _selectedFilter == 'All'
              ? 'Refresh fares'
              : 'Clear filter',
          onAction: () {
            if (_selectedFilter == 'All') {
              provider.fetchFlights();
            } else {
              setState(() => _selectedFilter = 'All');
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
          key: ValueKey('${flight.id}-$_selectedFilter-$_sort'),
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
