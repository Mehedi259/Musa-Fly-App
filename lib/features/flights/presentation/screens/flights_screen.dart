import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../../../home/presentation/widgets/home_blocks.dart';
import '../providers/flight_provider.dart';
import '../widgets/flight_header.dart';
import '../widgets/flight_search_card.dart';
import 'flight_results_screen.dart';

/// Dedicated flight search screen (matching top travel app UX standards).
/// Clean white page, floating search form with round gold CTA, and contextual deals.
class FlightsScreen extends StatefulWidget {
  const FlightsScreen({super.key});

  @override
  State<FlightsScreen> createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
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

  void _onSearch(FlightProvider provider) {
    provider.executeSearch();
    context.pushPremium(const FlightResultsScreen());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlightProvider>(context);

    final flightDeals = <DealOfferItem>[
      DealOfferItem(
        discountBadge: context.pick('Up to 8%\nDiscount*', '৮% পর্যন্ত\nডিসকাউন্ট*'),
        title: context.pick(
          'On Domestic & International Flight Bookings via MusaFly',
          'মুসাফ্লাইয়ের মাধ্যমে অভ্যন্তরীণ ও আন্তর্জাতিক ফ্লাইট বুকিংয়ে বিশেষ ছাড়',
        ),
        icon: PhosphorIconsFill.airplaneTilt,
        badgeColor: const Color(0xFF1E3A8A),
        onTap: () => _onSearch(provider),
      ),
      DealOfferItem(
        discountBadge: context.pick('Flat 5%\nDiscount*', 'ফ্ল্যাট ৫%\nডিসকাউন্ট*'),
        title: context.pick(
          'Special bKash & Nagad Cashback on Flight Bookings',
          'ফ্লাইট বুকিংয়ে বিকাশ ও নগদ ক্যাশব্যাক অফার',
        ),
        icon: PhosphorIconsFill.deviceMobile,
        badgeColor: const Color(0xFF0F172A),
        onTap: () => _onSearch(provider),
      ),
      DealOfferItem(
        discountBadge: context.pick('Student\nFare', 'স্টুডেন্ট\nভাড়া'),
        title: context.pick(
          'Extra 10kg Baggage Allowance on Selected Routes',
          'নির্দিষ্ট রুটে অতিরিক্ত ১০ কেজি লাগেজ সুবিধা',
        ),
        icon: PhosphorIconsFill.student,
        badgeColor: const Color(0xFF064E3B),
        onTap: () => _onSearch(provider),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          FlightHeader(
            title: context.tr('flights.title'),
            action: SoftIconButton(
              icon: PhosphorIconsBold.arrowsClockwise,
              size: 40,
              tooltip: 'Refresh',
              onTap: () => provider.fetchFlights(),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                    child: FadeSlideIn(
                      child: FlightSearchCard(
                        provider: provider,
                        onSearch: () => _onSearch(provider),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SectionHeader(
                    title: context.tr('flights.hotDeals'),
                    subtitle: context.pick(
                      'Exclusive discounts on airline bookings',
                      'এয়ারলাইন টিকিটে বিশেষ ছাড় ও অফার',
                    ),
                    actionText: context.tr('action.viewAll'),
                    onAction: () => _onSearch(provider),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  HomeHotDealsCarousel(deals: flightDeals),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
