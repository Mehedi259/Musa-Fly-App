import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../providers/tour_provider.dart';
import '../widgets/tour_card.dart';

class ToursScreen extends StatefulWidget {
  const ToursScreen({super.key});

  @override
  State<ToursScreen> createState() => _ToursScreenState();
}

class _ToursScreenState extends State<ToursScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TourProvider>(context, listen: false);
      if (provider.tours.isEmpty) {
        provider.fetchTours();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TourProvider>(context);

    final filteredTours = provider.tours.where((t) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return t.destination.toLowerCase().contains(q) ||
          t.inclusions.toLowerCase().contains(q) ||
          t.duration.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Holiday & Tours'),
        actions: [
          IconButton(
            onPressed: () => provider.fetchTours(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchTours(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Input
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search destinations (e.g. Dubai, Maldives, Alps)...',
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Tour List
              if (provider.isLoading && provider.tours.isEmpty) ...[
                const ShimmerBox(width: double.infinity, height: 220),
                const SizedBox(height: 16),
                const ShimmerBox(width: double.infinity, height: 220),
              ] else if (provider.errorMessage != null && provider.tours.isEmpty) ...[
                ErrorStateView(
                  message: provider.errorMessage!,
                  onRetry: () => provider.fetchTours(),
                ),
              ] else if (filteredTours.isEmpty) ...[
                EmptyStateView(
                  title: 'No Tours Found',
                  message: 'No packages match "$_searchQuery".',
                  actionText: 'View All Tours',
                  onAction: () => setState(() => _searchQuery = ''),
                ),
              ] else ...[
                ...filteredTours.map((tour) => TourCard(tour: tour)),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
