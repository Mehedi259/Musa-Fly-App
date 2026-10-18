import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../deals/data/models/deal_model.dart';
import '../../../deals/data/repositories/deal_repository.dart';
import '../../data/models/tour_model.dart';

class TourDetailScreen extends StatefulWidget {
  final TourModel tour;

  const TourDetailScreen({super.key, required this.tour});

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  void _openBookingSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _TourBookingSheet(tour: widget.tour),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Collapsible Image App Bar
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(120),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(120),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                ),
                onPressed: () {
                  final msg =
                      "Check out this tour package on MusaFly: ${widget.tour.destination} (${widget.tour.duration}) for ${CurrencyFormatter.formatSmart(widget.tour.price)}!";
                  UrlHelper.launchWhatsApp(customMessage: msg);
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AppNetworkImage(
                    imageUrl: widget.tour.image,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Color(0xCC0D1F3A)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.tour.duration,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.tour.destination,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Details Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primarySubtle,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primaryLight.withAlpha(50)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Package Price',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              CurrencyFormatter.formatSmart(widget.tour.price),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.success.withAlpha(25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'All Taxes Included',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Highlights / Inclusions
                  const Text(
                    "What's Included",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...widget.tour.inclusionList.map(
                    (inc) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, size: 12, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              inc,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Key Benefits Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _buildFeatureRow(Icons.hotel_rounded, 'Premium Accommodations', 'Handpicked 4-star and luxury hotels'),
                        const Divider(height: 20),
                        _buildFeatureRow(Icons.directions_bus_rounded, 'Airport & Sightseeing Transfers', 'Private air-conditioned vehicles'),
                        const Divider(height: 20),
                        _buildFeatureRow(Icons.support_agent_rounded, '24/7 Dedicated Concierge', 'Local on-ground assistance at destination'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'WhatsApp Inquiry',
                icon: Icons.chat_bubble_rounded,
                backgroundColor: AppColors.whatsapp,
                onPressed: () {
                  final msg =
                      "Hello MusaFly! I am interested in the ${widget.tour.destination} (${widget.tour.duration}) tour package priced at ${CurrencyFormatter.formatSmart(widget.tour.price)}. Could you please provide full itinerary details?";
                  UrlHelper.launchWhatsApp(customMessage: msg);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                text: 'Book Package',
                type: ButtonType.primary,
                onPressed: _openBookingSheet,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String title, String subtitle) {
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

class _TourBookingSheet extends StatefulWidget {
  final TourModel tour;
  const _TourBookingSheet({required this.tour});

  @override
  State<_TourBookingSheet> createState() => _TourBookingSheetState();
}

class _TourBookingSheetState extends State<_TourBookingSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  final DateTime _travelDate = DateTime.now().add(const Duration(days: 14));
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final deal = DealModel(
        customerName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        address: _notesController.text.trim().isEmpty ? 'Tour Booking Request' : _notesController.text.trim(),
        passportNumber: 'N/A',
        email: _emailController.text.trim(),
        serviceCategory: 'Holiday Tour',
        routeDestination: widget.tour.destination,
        travelDate: _travelDate,
        leadSource: 'Mobile App',
        dealPrice: widget.tour.price,
        currency: 'USD',
      );

      await DealRepository().createDeal(deal);
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 54),
              const SizedBox(height: 16),
              const Text('Tour Inquiry Received!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Our holiday planner will get in touch with you to customize your ${widget.tour.destination} trip.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Chat with Agent',
                backgroundColor: AppColors.whatsapp,
                onPressed: () {
                  Navigator.pop(ctx);
                  UrlHelper.launchWhatsApp(
                    customMessage:
                        "Hi MusaFly! I just submitted an inquiry for ${widget.tour.destination}. My name is ${_nameController.text.trim()}.",
                  );
                },
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Book ${widget.tour.destination}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Your Name *',
                controller: _nameController,
                hint: 'Full Name',
                prefixIcon: const Icon(Icons.person_outline),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Phone Number *',
                controller: _phoneController,
                hint: 'e.g. +968 95923226',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Email',
                controller: _emailController,
                hint: 'name@domain.com',
                prefixIcon: const Icon(Icons.mail_outline),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Special Requests / Number of Guests',
                controller: _notesController,
                hint: 'e.g. 2 Adults, 1 Child',
                maxLines: 2,
                prefixIcon: const Icon(Icons.group_outlined),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Send Booking Inquiry',
                isLoading: _isSubmitting,
                onPressed: _submit,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
