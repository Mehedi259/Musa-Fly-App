import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../../../auth/presentation/screens/auth_bottom_sheet.dart';
import '../../../flights/presentation/providers/flight_provider.dart';
import '../../../flights/presentation/screens/flight_booking_dialog.dart';
import '../../../flights/presentation/widgets/flight_card.dart';
import '../../../flights/presentation/widgets/flight_search_card.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import '../../../support/presentation/providers/support_provider.dart';
import '../../../tours/presentation/providers/tour_provider.dart';
import '../../../support/presentation/screens/support_screen.dart';
import '../../../tours/presentation/screens/tours_screen.dart';
import '../../../tours/presentation/widgets/tour_card.dart';
import '../../../umrah/presentation/providers/umrah_provider.dart';
import '../../../umrah/presentation/widgets/umrah_card.dart';
import '../../../visas/presentation/providers/visa_provider.dart';
import '../../../visas/presentation/widgets/visa_card.dart';
import '../widgets/home_category_row.dart';
import '../widgets/home_hero.dart';
import '../widgets/home_offers_carousel.dart';
import '../widgets/home_section_states.dart';
import '../widgets/home_trust_block.dart';

/// Tab indexes owned by the main navigation shell.
const int _kTabFlights = 1;
const int _kTabUmrah = 2;
const int _kTabVisa = 3;
const int _kTabDeals = 4;

class HomeScreen extends StatefulWidget {
  final Function(int) onTabChange;

  const HomeScreen({super.key, required this.onTabChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllData();
    });
  }

  void _loadAllData() {
    Provider.of<FlightProvider>(context, listen: false).fetchFlights();
    Provider.of<TourProvider>(context, listen: false).fetchTours();
    Provider.of<UmrahProvider>(context, listen: false).fetchPackages();
    Provider.of<VisaProvider>(context, listen: false).fetchVisas();
    Provider.of<SupportProvider>(context, listen: false).fetchSupportData();
    Provider.of<NotificationProvider>(context, listen: false).fetchNotifications();
  }

  void _openNotifications() {
    context.pushPremium(NotificationsScreen(onNavigateTab: widget.onTabChange));
  }

  void _openTours() => context.pushPremium(const ToursScreen());

  @override
  Widget build(BuildContext context) {
    final flightProvider = Provider.of<FlightProvider>(context);
    final tourProvider = Provider.of<TourProvider>(context);
    final umrahProvider = Provider.of<UmrahProvider>(context);
    final visaProvider = Provider.of<VisaProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        edgeOffset: HomeHeroSliver.toolbarHeight + MediaQuery.of(context).padding.top,
        onRefresh: () async => _loadAllData(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            HomeHeroSliver(
              onNotifications: _openNotifications,
              onProfile: () => AuthBottomSheet.show(context),
            ),
            SliverToBoxAdapter(child: _buildSearchCard(flightProvider)),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xxl),
                  FadeSlideIn(index: 1, child: _buildCategories()),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildOffersSection(),
                  _buildFlightsSection(flightProvider),
                  _buildToursSection(tourProvider),
                  _buildUmrahSection(umrahProvider),
                  _buildVisaSection(visaProvider),
                  const SizedBox(height: AppSpacing.sm),
                  FadeSlideIn(
                    index: 2,
                    child: HomeTrustBlock(
                      onWhatsApp: () => UrlHelper.launchWhatsApp(),
                      // The support screen has no tab of its own, so this is
                      // the way into it.
                      onHelpCentre: () => context.pushPremium(const SupportScreen()),
                    ),
                  ),
                  const SizedBox(height: 110),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────── Search card over the hero edge ─────────────────────

  /// The card sits on its own navy shelf so it reads as floating over the
  /// hero's lower edge while still scrolling away with the page.
  Widget _buildSearchCard(FlightProvider flightProvider) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 54,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF143468), AppColors.primary],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppRadius.xl)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: FlightSearchCard(
            provider: flightProvider,
            onSearch: () {
              flightProvider.executeSearch();
              widget.onTabChange(_kTabFlights);
            },
          ),
        ),
      ],
    );
  }

  // ───────────────────────────── Categories ─────────────────────────────

  Widget _buildCategories() {
    return HomeCategoryRow(
      categories: [
        HomeCategory(
          icon: HomeCategoryIcons.flight,
          label: 'Flights',
          color: AppColors.catFlight,
          onTap: () => widget.onTabChange(_kTabFlights),
        ),
        HomeCategory(
          icon: HomeCategoryIcons.tour,
          label: 'Tours',
          color: AppColors.catTour,
          onTap: _openTours,
        ),
        HomeCategory(
          icon: HomeCategoryIcons.umrah,
          label: 'Umrah',
          color: AppColors.catUmrah,
          onTap: () => widget.onTabChange(_kTabUmrah),
        ),
        HomeCategory(
          icon: HomeCategoryIcons.visa,
          label: 'Visas',
          color: AppColors.catVisa,
          onTap: () => widget.onTabChange(_kTabVisa),
        ),
        HomeCategory(
          icon: HomeCategoryIcons.deal,
          label: 'Deals',
          color: AppColors.catDeal,
          onTap: () => widget.onTabChange(_kTabDeals),
        ),
      ],
    );
  }

  // ─────────────────────────────── Offers ───────────────────────────────

  Widget _buildOffersSection() {
    return Consumer<NotificationProvider>(
      builder: (context, notif, _) {
        final campaigns = notif.notifications
            .where((n) => n.image != null && n.image!.isNotEmpty)
            .toList();
        if (campaigns.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: 'Offers for you',
              subtitle: 'Hand-picked deals and seasonal fare drops',
              actionText: 'See all',
              onAction: _openNotifications,
            ),
            HomeOffersCarousel(campaigns: campaigns, onTap: _openNotifications),
            const SizedBox(height: AppSpacing.xxl),
          ],
        );
      },
    );
  }

  // ─────────────────────────────── Flights ───────────────────────────────

  Widget _buildFlightsSection(FlightProvider provider) {
    final flights = provider.flights.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Popular flights',
          subtitle: 'Lowest airfares from Dhaka and Muscat',
          actionText: 'View all',
          onAction: () => widget.onTabChange(_kTabFlights),
        ),
        if (provider.isLoading && flights.isEmpty)
          const HomeListSkeleton(count: 2)
        else if (flights.isEmpty)
          HomeEmptyNote(
            icon: PhosphorIconsDuotone.airplaneTilt,
            message: 'No fares loaded right now. Search a route to see live prices.',
            actionText: 'Search',
            onAction: () => widget.onTabChange(_kTabFlights),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
            child: Column(
              children: [
                for (var i = 0; i < flights.length; i++)
                  FadeSlideIn(
                    index: i,
                    child: FlightCard(
                      flight: flights[i],
                      onBook: () => FlightBookingDialog.show(context, flights[i]),
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  // ──────────────────────────────── Tours ────────────────────────────────

  Widget _buildToursSection(TourProvider provider) {
    final tours = provider.tours;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Holiday packages',
          subtitle: 'Curated worldwide getaways, flights included',
          actionText: 'Explore',
          onAction: _openTours,
        ),
        if (provider.isLoading && tours.isEmpty)
          const HomeStripSkeleton()
        else if (tours.isEmpty)
          HomeEmptyNote(
            icon: PhosphorIconsDuotone.island,
            tint: AppColors.catTour,
            message: 'Holiday packages are being refreshed — check back shortly.',
            actionText: 'Browse',
            onAction: _openTours,
          )
        else
          SizedBox(
            height: 272,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: AppSpacing.page, right: AppSpacing.xs),
              itemCount: tours.length,
              itemBuilder: (ctx, i) => FadeSlideIn(
                index: i,
                child: TourCard(tour: tours[i], isHorizontal: true),
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  // ──────────────────────────────── Umrah ────────────────────────────────

  Widget _buildUmrahSection(UmrahProvider provider) {
    final packages = provider.packages;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Umrah pilgrimage',
          subtitle: 'All-inclusive packages with visa, hotels and transfers',
          actionText: 'All packages',
          onAction: () => widget.onTabChange(_kTabUmrah),
        ),
        if (provider.isLoading && packages.isEmpty)
          const HomeBlockSkeleton()
        else if (packages.isEmpty)
          HomeEmptyNote(
            icon: PhosphorIconsDuotone.mosque,
            tint: AppColors.catUmrah,
            message: 'Umrah packages will appear here once published.',
            actionText: 'View',
            onAction: () => widget.onTabChange(_kTabUmrah),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
            child: FadeSlideIn(child: UmrahCard(package: packages.first)),
          ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  // ───────────────────────────────── Visa ─────────────────────────────────

  Widget _buildVisaSection(VisaProvider provider) {
    final visas = provider.visas.take(2).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Visa services',
          subtitle: 'Fast processing with a 99% document approval rate',
          actionText: 'View all',
          onAction: () => widget.onTabChange(_kTabVisa),
        ),
        if (provider.isLoading && visas.isEmpty)
          const HomeListSkeleton(count: 2, height: 96)
        else if (visas.isEmpty)
          HomeEmptyNote(
            icon: PhosphorIconsDuotone.identificationCard,
            tint: AppColors.catVisa,
            message: 'Visa destinations are loading — pull down to refresh.',
            actionText: 'View',
            onAction: () => widget.onTabChange(_kTabVisa),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
            child: Column(
              children: [
                for (var i = 0; i < visas.length; i++)
                  FadeSlideIn(index: i, child: VisaCard(visa: visas[i])),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}
