import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/section_title.dart';
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
                      // WhatsApp Quick Chat Button
                      ElevatedButton.icon(
                        onPressed: () => UrlHelper.launchWhatsApp(),
                        icon: const Icon(Icons.chat_bubble_rounded, size: 16),
                        label: const Text('Concierge'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.whatsapp,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
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

                  const SizedBox(height: 20),

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
