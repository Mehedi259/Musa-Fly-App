import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../providers/deal_provider.dart';
import 'create_booking_inquiry_screen.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DealProvider>(context, listen: false);
      provider.fetchDeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DealProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings & Deals'),
        actions: [
          IconButton(
            onPressed: () => provider.fetchDeals(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateBookingInquiryScreen()),
        ),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Inquiry', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchDeals(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Deals Overview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF204D90), Color(0xFF132E56)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.confirmation_number_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'My Bookings & Inquiries',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${provider.deals.length} active deals synced with backend',
                            style: const TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              if (provider.isLoading && provider.deals.isEmpty) ...[
                const ShimmerBox(width: double.infinity, height: 120),
                const SizedBox(height: 12),
                const ShimmerBox(width: double.infinity, height: 120),
              ] else if (provider.errorMessage != null && provider.deals.isEmpty) ...[
                ErrorStateView(
                  message: provider.errorMessage!,
                  onRetry: () => provider.fetchDeals(),
                ),
              ] else if (provider.deals.isEmpty) ...[
                EmptyStateView(
                  title: 'No Active Bookings',
                  message: 'Create your first flight, tour, or visa inquiry now!',
                  actionText: 'Book a Service',
                  onAction: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateBookingInquiryScreen()),
                  ),
                ),
              ] else ...[
                ...provider.deals.map((deal) => _buildDealCard(deal)),
              ],

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDealCard(dynamic deal) {
    final travelDateStr = DateFormat('dd MMM, yyyy').format(deal.travelDate);

    IconData icon;
    Color iconColor;
    if (deal.serviceCategory.toLowerCase().contains('flight')) {
      icon = Icons.flight_takeoff_rounded;
      iconColor = AppColors.primary;
    } else if (deal.serviceCategory.toLowerCase().contains('tour')) {
      icon = Icons.beach_access_rounded;
      iconColor = AppColors.secondary;
    } else if (deal.serviceCategory.toLowerCase().contains('umrah')) {
      icon = Icons.mosque_rounded;
      iconColor = const Color(0xFF10B981);
    } else {
      icon = Icons.article_rounded;
      iconColor = const Color(0xFF8B5CF6);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deal.serviceCategory,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      deal.routeDestination,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Confirmed',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Customer', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  Text(deal.customerName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Travel Date', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  Text(travelDateStr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Deal Price', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  Text(
                    CurrencyFormatter.formatSmart(deal.dealPrice),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
