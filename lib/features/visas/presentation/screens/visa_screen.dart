import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../providers/visa_provider.dart';
import '../widgets/visa_card.dart';

class VisaScreen extends StatefulWidget {
  const VisaScreen({super.key});

  @override
  State<VisaScreen> createState() => _VisaScreenState();
}

class _VisaScreenState extends State<VisaScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<VisaProvider>(context, listen: false);
      if (provider.visas.isEmpty) {
        provider.fetchVisas();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VisaProvider>(context);

    final filteredVisas = provider.visas.where((v) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return v.country.toLowerCase().contains(q) ||
          v.visaType.toLowerCase().contains(q) ||
          (v.requirements?.toLowerCase().contains(q) ?? false);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Visa Services'),
        actions: [
          IconButton(
            onPressed: () => provider.fetchVisas(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchVisas(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Country Field
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search country (e.g. Malaysia, Oman, Singapore)...',
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

              // Visa List
              if (provider.isLoading && provider.visas.isEmpty) ...[
                const ShimmerBox(width: double.infinity, height: 160),
                const SizedBox(height: 16),
                const ShimmerBox(width: double.infinity, height: 160),
              ] else if (provider.errorMessage != null && provider.visas.isEmpty) ...[
                ErrorStateView(
                  message: provider.errorMessage!,
                  onRetry: () => provider.fetchVisas(),
                ),
              ] else if (filteredVisas.isEmpty) ...[
                EmptyStateView(
                  title: 'No Visa Found',
                  message: 'No country visa services match "$_searchQuery".',
                  actionText: 'Clear Search',
                  onAction: () => setState(() => _searchQuery = ''),
                ),
              ] else ...[
                ...filteredVisas.map((visa) => VisaCard(visa: visa)),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
