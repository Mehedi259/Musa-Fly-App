import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/section_title.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../flights/presentation/providers/flight_provider.dart';
import '../../../flights/presentation/screens/flight_booking_dialog.dart';
import '../../../flights/presentation/widgets/flight_card.dart';
import '../../../flights/presentation/widgets/flight_search_card.dart';
import '../../../support/presentation/providers/support_provider.dart';
import '../../../tours/presentation/providers/tour_provider.dart';
import '../../../tours/presentation/screens/tours_screen.dart';
import '../../../tours/presentation/widgets/tour_card.dart';
import '../../../umrah/presentation/providers/umrah_provider.dart';
import '../../../umrah/presentation/widgets/umrah_card.dart';
import '../../../visas/presentation/providers/visa_provider.dart';
import '../../../visas/presentation/widgets/visa_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/screens/auth_bottom_sheet.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final flightProvider = Provider.of<FlightProvider>(context);
    final tourProvider = Provider.of<TourProvider>(context);
    final umrahProvider = Provider.of<UmrahProvider>(context);
    final visaProvider = Provider.of<VisaProvider>(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _loadAllData(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Luxury Custom Header Sliver
            SliverAppBar(
              expandedHeight: 120,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF204D90), Color(0xFF132E56)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            AppAssets.logo,
                            height: 38,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.flight_takeoff_rounded,
                              color: AppColors.secondary,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                AppStrings.appName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                'Muscat • Dhaka',
                                style: TextStyle(
                                  color: Colors.white.withAlpha(200),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Header Actions: Notifications (bKash style), Profile & Concierge
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Notification Bell
                          Consumer<NotificationProvider>(
                            builder: (context, notifProvider, _) {
                              final unread = notifProvider.unreadCount;
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  IconButton(
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.all(6),
                                    icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 23),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => NotificationsScreen(onNavigateTab: widget.onTabChange),
                                        ),
                                      );
                                    },
                                  ),
                                  if (unread > 0)
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFEF4444),
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                        child: Center(
                                          child: Text(
                                            unread > 9 ? '9+' : '$unread',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(width: 4),

                          // Google Profile / Sign-in
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, _) {
                              final user = authProvider.currentUser;
                              return InkWell(
                                onTap: () => AuthBottomSheet.show(context),
                                borderRadius: BorderRadius.circular(18),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(authProvider.isAuthenticated ? 255 : 40),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white.withAlpha(80), width: 1.5),
                                  ),
                                  child: Center(
                                    child: authProvider.isAuthenticated && user != null
                                        ? Text(
                                            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                            style: const TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : const Icon(Icons.person_outline_rounded, color: Colors.white, size: 18),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),

                          // WhatsApp Concierge Button
                          ElevatedButton.icon(
                            onPressed: () => UrlHelper.launchWhatsApp(),
                            icon: const Icon(Icons.chat_bubble_rounded, size: 14),
                            label: const Text('Concierge'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.whatsapp,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              minimumSize: const Size(0, 32),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main Body Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // Quick Category Navigation Pills
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCategoryButton(
                          icon: Icons.flight_rounded,
                          label: 'Flights',
                          color: AppColors.primary,
                          onTap: () => widget.onTabChange(1),
                        ),
                        _buildCategoryButton(
                          icon: Icons.beach_access_rounded,
                          label: 'Tours',
                          color: AppColors.secondary,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ToursScreen()),
                          ),
                        ),
                        _buildCategoryButton(
                          icon: Icons.mosque_rounded,
                          label: 'Umrah',
                          color: const Color(0xFF10B981),
                          onTap: () => widget.onTabChange(2),
                        ),
                        _buildCategoryButton(
                          icon: Icons.assignment_turned_in_rounded,
                          label: 'Visas',
                          color: const Color(0xFF8B5CF6),
                          onTap: () => widget.onTabChange(3),
                        ),
                        _buildCategoryButton(
                          icon: Icons.confirmation_number_rounded,
                          label: 'Deals',
                          color: const Color(0xFFEC4899),
                          onTap: () => widget.onTabChange(4),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Dynamic Campaign & Offers Banner Carousel (bKash style)
                  Consumer<NotificationProvider>(
                    builder: (context, notifProvider, _) {
                      final campaigns = notifProvider.notifications
                          .where((n) => n.image != null && n.image!.isNotEmpty)
                          .toList();
                      if (campaigns.isEmpty) return const SizedBox.shrink();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionTitle(
                            title: 'স্পেশাল অফার ও ক্যাম্পেইন',
                            subtitle: 'মুসাফ্লাইয়ের সেরা ডিসকাউন্ট এবং ডিলসমূহ',
                            actionText: 'সবগুলো দেখুন',
                            onAction: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NotificationsScreen(onNavigateTab: widget.onTabChange),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 160,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              scrollDirection: Axis.horizontal,
                              itemCount: campaigns.length,
                              separatorBuilder: (context, index) => const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final campaign = campaigns[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => NotificationsScreen(onNavigateTab: widget.onTabChange),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    width: 280,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(12),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          AppNetworkImage(
                                            imageUrl: campaign.image!,
                                            fit: BoxFit.cover,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withAlpha(180),
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 10,
                                            left: 10,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFEF4444),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                campaign.badgeText,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 10,
                                            left: 10,
                                            right: 10,
                                            child: Text(
                                              campaign.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),

                  // Flight Search Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FlightSearchCard(
                      provider: flightProvider,
                      onSearch: () {
                        flightProvider.executeSearch();
                        widget.onTabChange(1); // Jump to Flights tab
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Featured Flights Section
                  SectionTitle(
                    title: 'Popular Flights',
                    subtitle: 'Lowest airfares from Dhaka and Muscat',
                    actionText: 'View All',
                    onAction: () => widget.onTabChange(1),
                  ),
                  if (flightProvider.flights.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: flightProvider.flights.take(2).map((flight) {
                          return FlightCard(
                            flight: flight,
                            onBook: () => FlightBookingDialog.show(context, flight),
                          );
                        }).toList(),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Popular Tour Packages Horizontal Slider
                  SectionTitle(
                    title: 'Holiday Packages',
                    subtitle: 'Exclusive worldwide tour getaways',
                    actionText: 'Explore',
                    onAction: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ToursScreen()),
                    ),
                  ),
                  if (tourProvider.tours.isNotEmpty) ...[
                    SizedBox(
                      height: 270,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 16),
                        itemCount: tourProvider.tours.length,
                        itemBuilder: (ctx, i) {
                          return TourCard(
                            tour: tourProvider.tours[i],
                            isHorizontal: true,
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Umrah Spotlight Section
                  SectionTitle(
                    title: 'Umrah Pilgrimage',
                    subtitle: 'All-inclusive premium packages with visa & hotels',
                    actionText: 'All Packages',
                    onAction: () => widget.onTabChange(2),
                  ),
                  if (umrahProvider.packages.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: UmrahCard(package: umrahProvider.packages.first),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Visa Services Section
                  SectionTitle(
                    title: 'Visa Services',
                    subtitle: 'Fast processing with 99% document approval',
                    actionText: 'View All',
                    onAction: () => widget.onTabChange(3),
                  ),
                  if (visaProvider.visas.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: visaProvider.visas.take(2).map((visa) {
                          return VisaCard(visa: visa);
                        }).toList(),
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Why Choose Us Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Why Travel With MusaFly?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildBenefitRow(Icons.verified_rounded, 'Verified Travel Partner', 'Official airline ticket distributor & Umrah organizer.'),
                          const Divider(height: 20),
                          _buildBenefitRow(Icons.price_check_rounded, 'Best Price Guarantee', 'Transparent pricing with no hidden charges.'),
                          const Divider(height: 20),
                          _buildBenefitRow(Icons.support_agent_rounded, '24/7 VIP Concierge', 'Real human support on WhatsApp & call anytime.'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withAlpha(40)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primarySubtle,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
            ],
          ),
        ),
      ],
    );
  }
}
