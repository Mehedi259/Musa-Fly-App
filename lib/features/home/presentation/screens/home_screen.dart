import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/booking_ui.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../../../auth/presentation/screens/auth_bottom_sheet.dart';
import '../../../deals/presentation/screens/create_booking_inquiry_screen.dart';
import '../../../flights/presentation/providers/flight_provider.dart';
import '../../../flights/presentation/screens/flights_screen.dart';
import '../../../notifications/models/notification_model.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import '../../../support/presentation/providers/support_provider.dart';
import '../../../support/presentation/screens/support_screen.dart';
import '../../../tours/presentation/providers/tour_provider.dart';
import '../../../tours/presentation/screens/tours_screen.dart';
import '../../../umrah/presentation/providers/umrah_provider.dart';
import '../../../umrah/presentation/screens/umrah_screen.dart';
import '../../../visas/presentation/providers/visa_provider.dart';
import '../../../visas/presentation/screens/visa_screen.dart';
import '../widgets/home_blocks.dart';
import '../widgets/home_hero.dart';
import '../widgets/home_trust_block.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onTabChange;

  const HomeScreen({super.key, required this.onTabChange});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _dealChip = 0;
  int _offerChip = 0;

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

  void _openFlights() => context.pushPremium(const FlightsScreen());
  void _openUmrah() => context.pushPremium(const UmrahScreen());
  void _openTours() => context.pushPremium(const ToursScreen());
  void _openVisa() => context.pushPremium(const VisaScreen());
  void _openInquiry() => context.pushPremium(const CreateBookingInquiryScreen());

  void _openBookingGuide() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
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
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'সহজ ৩ ধাপে ফ্লাইট ও উমরাহ বুকিং',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'মুসাফ্লাই দিয়ে ভ্রমণ হোক স্বচ্ছ ও স্বাচ্ছন্দ্যময়',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.lg),
            _guideStepRow('১', 'রুট ও তারিখ নির্বাচন করুন', 'দেশি-বিদেশি এয়ারলাইনগুলোর লাইভ ভাড়া যাচাই করে আপনার শিডিউল বেছে নিন।'),
            _guideStepRow('২', 'পেমেন্ট সম্পন্ন করুন', 'বিকাশ, নগদ, কার্ড বা যেকোনো ব্যাংক চ্যানেলে তাৎক্ষণিক পেমেন্ট।'),
            _guideStepRow('৩', 'ই-টিকিট ও ২৪/৭ ভিআইপি সহায়তা', 'আপনার হোয়াটসঅ্যাপ ও ইনবক্সে ই-টিকিট পৌঁছে যাবে। যাত্রা শেষ হওয়া পর্যন্ত আমরা আপনার পাশে আছি।'),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _openFlights();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                child: const Text('এখনই ফ্লাইট খুঁজুন', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _guideStepRow(String number, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primarySubtle,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tourProvider = Provider.of<TourProvider>(context);
    final campaigns = _campaigns(context);
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        edgeOffset: HomeHeaderDelegate.railHeight + topInset,
        onRefresh: () async => _loadAllData(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            // ── Top Photographic Hero with Service Rail ──
            SliverPersistentHeader(
              pinned: true,
              delegate: HomeHeaderDelegate(
                topInset: topInset,
                photoUrl: _heroPhoto(tourProvider, campaigns),
                services: _services(),
                onMenu: () => AuthBottomSheet.show(context),
                onNotifications: _openNotifications,
              ),
            ),

            // ── Scrollable Body ──
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),

                  // ── Quick Pills (Gift Card & Custom Umrah) ──
                  HomeQuickPills(
                    onGiftCard: _openNotifications,
                    onUmrahInquiry: _openInquiry,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // ── Video / Smart Booking Guide ──
                  HomeVideoGuideSection(onOpenGuide: _openBookingGuide),
                  const SizedBox(height: AppSpacing.xl),

                  // ── Promotional Campaign Banner ("season of travel") ──
                  FadeSlideIn(
                    index: 1,
                    child: HomeCampaignBanner(
                      imageUrl: campaigns.isEmpty ? null : campaigns.first.image,
                      title: campaigns.isEmpty ? null : campaigns.first.title,
                      subtitle: campaigns.isEmpty ? null : campaigns.first.message,
                      badge: campaigns.isEmpty ? null : campaigns.first.badgeText,
                      onTap: _openNotifications,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // ── Hot Deals Section (Signature Deal Cards) ──
                  _hotDealsSection(),
                  const SizedBox(height: AppSpacing.xxl),

                  // ── Special Offers Section ──
                  _specialOffersSection(tourProvider),
                  const SizedBox(height: AppSpacing.xxl),

                  // ── Featured Section (Gift Cards & VIP Concierge) ──
                  _featuredSection(),
                  const SizedBox(height: AppSpacing.xl),

                  // ── Trust & VIP Support Block ──
                  FadeSlideIn(
                    index: 2,
                    child: HomeTrustBlock(
                      onWhatsApp: () => UrlHelper.launchWhatsApp(),
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

  // ──────────────────────── Hero photograph ────────────────────────

  List<NotificationModel> _campaigns(BuildContext context) {
    final notif = Provider.of<NotificationProvider>(context);
    return notif.notifications.where((n) => n.image != null && n.image!.isNotEmpty).toList();
  }

  String? _heroPhoto(TourProvider tours, List<NotificationModel> campaigns) {
    final list = tours.tours;
    if (list.isNotEmpty) {
      const watery = ['maldives', 'bali', 'phuket', 'cox', 'island', 'beach', 'thai'];
      for (final tour in list) {
        final d = tour.destination.toLowerCase();
        if (watery.any(d.contains)) return tour.displayImage;
      }
      return list.first.displayImage;
    }
    if (campaigns.isNotEmpty) return campaigns.first.image;
    return null;
  }

  // ───────────────────────── 4 Service tiles ─────────────────────────

  List<ServiceItem> _services() => [
        ServiceItem(
          icon: PhosphorIconsDuotone.airplaneTilt,
          label: context.tr('service.flight'),
          color: AppColors.catFlight,
          onTap: _openFlights,
        ),
        ServiceItem(
          icon: PhosphorIconsDuotone.mosque,
          label: context.tr('service.umrah'),
          color: AppColors.catUmrah,
          onTap: _openUmrah,
        ),
        ServiceItem(
          icon: PhosphorIconsDuotone.island,
          label: context.tr('service.tour'),
          color: AppColors.catTour,
          onTap: _openTours,
        ),
        ServiceItem(
          icon: PhosphorIconsDuotone.identificationCard,
          label: context.tr('service.visa'),
          color: AppColors.catVisa,
          onTap: _openVisa,
        ),
      ];

  // ─────────────────────────── Hot deals ───────────────────────────

  Widget _hotDealsSection() {
    final dealChips = [
      context.tr('home.deals.trending'),
      context.tr('home.deals.flight'),
      context.tr('home.deals.umrah'),
      context.tr('home.deals.tour'),
    ];

    final deals = <DealOfferItem>[
      DealOfferItem(
        discountBadge: 'Flat 5%\nDiscount*',
        title: 'On Int\'l Flight & Hotel Bookings for Mobile Banking Payment',
        icon: PhosphorIconsFill.deviceMobile,
        badgeColor: const Color(0xFF0F172A),
        onTap: _openFlights,
      ),
      DealOfferItem(
        discountBadge: 'Up to 8%\nDiscount*',
        title: 'On Domestic & International Flight Bookings via MusaFly',
        icon: PhosphorIconsFill.airplaneTilt,
        badgeColor: const Color(0xFF1E3A8A),
        onTap: _openFlights,
      ),
      DealOfferItem(
        discountBadge: 'Special\n10% Off',
        title: 'Exclusive VIP Ramadan & Shawwal 5★ Umrah Packages',
        icon: PhosphorIconsFill.mosque,
        badgeColor: const Color(0xFF064E3B),
        onTap: _openUmrah,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.tr('home.hotDeals.title'),
          subtitle: context.tr('home.hotDeals.subtitle'),
          actionText: context.tr('action.viewAll'),
          onAction: _openFlights,
        ),
        FilterChipRail(
          labels: dealChips,
          index: _dealChip,
          onChanged: (i) => setState(() => _dealChip = i),
        ),
        const SizedBox(height: AppSpacing.lg),
        HomeHotDealsCarousel(deals: deals),
      ],
    );
  }

  // ───────────────────────── Special offers ─────────────────────────

  Widget _specialOffersSection(TourProvider toursProvider) {
    final chips = ['All', 'HOTEL', 'FLIGHT', 'UMRAH'];
    final tours = toursProvider.tours;

    final offers = <SpecialOfferItem>[
      SpecialOfferItem(
        title: 'Hotel Vista Bay, Cox\'s Bazar – Extended Stay Offer: BDT 1,660 Per Night',
        subtitle: 'Without VAT & Service Charges · Instant Confirmation',
        imageUrl: tours.isNotEmpty ? tours.first.displayImage : 'https://images.unsplash.com/photo-1571896349842-33c89424de2d',
        badge: 'HOTEL OFFER',
        onTap: _openTours,
      ),
      SpecialOfferItem(
        title: 'Get Up to 22% Off on Selected European Flight Routes',
        subtitle: 'Direct & 1-Stop Flights via Top Carriers',
        imageUrl: tours.length > 1 ? tours[1].displayImage : 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05',
        badge: 'FLIGHT DEAL',
        onTap: _openFlights,
      ),
      SpecialOfferItem(
        title: 'Makkah Clock Tower 5★ Executive Package – BDT 135,000',
        subtitle: 'Haram Front View · VIP Transport & Visa Included',
        imageUrl: 'https://images.unsplash.com/photo-1591604129939-f1efa4d9f7fa',
        badge: 'UMRAH SPECIAL',
        onTap: _openUmrah,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.tr('home.offers.title'),
          subtitle: context.tr('home.offers.subtitle'),
          actionText: context.tr('action.explore'),
          onAction: _openTours,
        ),
        FilterChipRail(
          labels: chips,
          index: _offerChip,
          onChanged: (i) => setState(() => _offerChip = i),
        ),
        const SizedBox(height: AppSpacing.lg),
        HomeSpecialOffersCarousel(offers: offers),
      ],
    );
  }

  // ─────────────────────────── Featured ───────────────────────────

  Widget _featuredSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.tr('home.featured.title'),
          subtitle: context.tr('home.featured.subtitle'),
        ),
        HomeFeaturedStrip(
          onGiftCards: _openNotifications,
          onClubLimitless: _openUmrah,
        ),
      ],
    );
  }
}
