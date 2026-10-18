import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_view.dart';
import '../../../../core/widgets/error_state_view.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../providers/umrah_provider.dart';
import '../widgets/umrah_card.dart';

class UmrahScreen extends StatefulWidget {
  const UmrahScreen({super.key});

  @override
  State<UmrahScreen> createState() => _UmrahScreenState();
}

class _UmrahScreenState extends State<UmrahScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UmrahProvider>(context, listen: false);
      if (provider.packages.isEmpty) {
        provider.fetchPackages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UmrahProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Umrah Packages'),
        actions: [
          IconButton(
            onPressed: () => provider.fetchPackages(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchPackages(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF204D90), Color(0xFF0D1F3A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'BLESSED JOURNEY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Complete Umrah & Hajj Services',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Includes Saudi e-Visa, direct flights, 4-star/5-star luxury hotels in Makkah & Madinah, and guided Ziyarah.',
                      style: TextStyle(
                        color: Colors.white.withAlpha(200),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Featured Packages',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 16),

              if (provider.isLoading && provider.packages.isEmpty) ...[
                const ShimmerBox(width: double.infinity, height: 260),
                const SizedBox(height: 16),
                const ShimmerBox(width: double.infinity, height: 260),
              ] else if (provider.errorMessage != null && provider.packages.isEmpty) ...[
                ErrorStateView(
                  message: provider.errorMessage!,
                  onRetry: () => provider.fetchPackages(),
                ),
              ] else if (provider.packages.isEmpty) ...[
                EmptyStateView(
                  title: 'No Umrah Packages Found',
                  message: 'Please check back soon or contact our advisor on WhatsApp.',
                  actionText: 'Retry',
                  onAction: () => provider.fetchPackages(),
                ),
              ] else ...[
                ...provider.packages.map(
                  (pkg) => UmrahCard(package: pkg),
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
