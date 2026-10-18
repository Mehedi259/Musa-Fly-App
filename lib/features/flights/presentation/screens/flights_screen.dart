import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../providers/flight_provider.dart';
import '../widgets/flight_card.dart';
import '../widgets/flight_search_card.dart';
import 'flight_booking_dialog.dart';

class FlightsScreen extends StatefulWidget {
  const FlightsScreen({super.key});

  @override
  State<FlightsScreen> createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
  String _selectedFilter = 'All';

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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlightProvider>(context);

    // Filter logic
    final displayFlights = provider.flights.where((f) {
      if (_selectedFilter == 'Under \$500') {
        return f.price < 500;
      } else if (_selectedFilter == 'Direct Flights') {
        return true;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Booking'),
        actions: [
          IconButton(
            onPressed: () => provider.fetchFlights(),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchFlights(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Interactive Flight Search Card
              FlightSearchCard(
                provider: provider,
                onSearch: () {
                  provider.executeSearch();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Searching flights for ${provider.originCode} → ${provider.destCode}...',
                      ),
                      backgroundColor: AppColors.primary,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Filter Chips
              Row(
                children: [
                  const Text(
                    'Available Flights',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  _buildFilterChip('All'),
                  const SizedBox(width: 6),
                  _buildFilterChip('Under \$500'),
                ],
              ),

              const SizedBox(height: 16),

              // Content State
              if (provider.isLoading && provider.flights.isEmpty) ...[
                const FlightCardSkeleton(),
                const FlightCardSkeleton(),
              ] else if (provider.errorMessage != null && provider.flights.isEmpty) ...[
                ErrorStateView(
                  message: provider.errorMessage!,
                  onRetry: () => provider.fetchFlights(),
                ),
              ] else if (displayFlights.isEmpty) ...[
                EmptyStateView(
                  title: 'No Flights Available',
                  message: 'Try changing your search destination or filters.',
                  onAction: () => provider.fetchFlights(),
                  actionText: 'View All Flights',
                ),
              ] else ...[
                ...displayFlights.map(
                  (flight) => FlightCard(
                    flight: flight,
                    onBook: () => FlightBookingDialog.show(context, flight),
                  ),
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
