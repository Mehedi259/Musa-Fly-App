import 'package:flutter/material.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../deals/data/models/deal_model.dart';
import '../../../deals/data/repositories/deal_repository.dart';
import '../../data/models/umrah_model.dart';

class UmrahPackageDetailScreen extends StatefulWidget {
  final UmrahModel package;

  const UmrahPackageDetailScreen({super.key, required this.package});

  @override
  State<UmrahPackageDetailScreen> createState() => _UmrahPackageDetailScreenState();
}

class _UmrahPackageDetailScreenState extends State<UmrahPackageDetailScreen> {
  void _openBookingSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _UmrahBookingSheet(package: widget.package),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
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
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  AppNetworkImage(
                    imageUrl: widget.package.image ?? AppAssets.fallbackKaaba,
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
                            widget.package.duration,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.package.packageName,
                          style: const TextStyle(
                            fontSize: 22,
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
                              'Package Price / Person',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              CurrencyFormatter.formatSmart(widget.package.price),
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
                            'Verified Package',
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

                  // Inclusions
                  const Text(
                    'Package Inclusions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ...widget.package.inclusionList.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check, size: 12, color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item,
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

                  // Accommodations Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Pilgrimage Accommodations',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(height: 12),
                        _HotelTile(
                          city: 'Makkah Al-Mukarramah',
                          distance: 'Steps from Masjid Al-Haram',
                          icon: Icons.hotel_rounded,
                        ),
                        Divider(height: 16),
                        _HotelTile(
                          city: 'Madinah Al-Munawwarah',
                          distance: 'Walking distance to Al-Masjid an-Nabawi',
                          icon: Icons.mosque_rounded,
                        ),
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
                text: 'WhatsApp Guide',
                icon: Icons.chat_bubble_rounded,
                backgroundColor: AppColors.whatsapp,
                onPressed: () {
                  final msg =
                      "Salam MusaFly! I am interested in the ${widget.package.packageName} priced at ${CurrencyFormatter.formatSmart(widget.package.price)}. Please share full Umrah details.";
                  UrlHelper.launchWhatsApp(customMessage: msg);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                text: 'Book Umrah',
                type: ButtonType.primary,
                onPressed: _openBookingSheet,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HotelTile extends StatelessWidget {
  final String city;
  final String distance;
  final IconData icon;

  const _HotelTile({
    required this.city,
    required this.distance,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
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
              Text(city, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(distance, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}

class _UmrahBookingSheet extends StatefulWidget {
  final UmrahModel package;
  const _UmrahBookingSheet({required this.package});

  @override
  State<_UmrahBookingSheet> createState() => _UmrahBookingSheetState();
}

class _UmrahBookingSheetState extends State<_UmrahBookingSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  final DateTime _preferredDate = DateTime.now().add(const Duration(days: 30));
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
        address: _notesController.text.trim().isEmpty ? 'Umrah Request' : _notesController.text.trim(),
        passportNumber: 'N/A',
        email: _emailController.text.trim(),
        serviceCategory: 'Umrah Package',
        routeDestination: widget.package.packageName,
        travelDate: _preferredDate,
        leadSource: 'Mobile App',
        dealPrice: widget.package.price,
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
              const Text('Umrah Application Submitted!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'May Allah accept your pilgrimage intention. Our Umrah advisor will call you to arrange visa and flight details.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Chat with Umrah Advisor',
                backgroundColor: AppColors.whatsapp,
                onPressed: () {
                  Navigator.pop(ctx);
                  UrlHelper.launchWhatsApp(
                    customMessage:
                        "Salam MusaFly! I submitted an application for ${widget.package.packageName}. My name is ${_nameController.text.trim()}.",
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
                    'Book ${widget.package.cleanTitle}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Pilgrim Full Name *',
                controller: _nameController,
                hint: 'Name as on passport',
                prefixIcon: const Icon(Icons.person_outline),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Phone Number (with country code) *',
                controller: _phoneController,
                hint: '+968 or +880 number',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Email',
                controller: _emailController,
                hint: 'email@domain.com',
                prefixIcon: const Icon(Icons.mail_outline),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Number of Pilgrims / Room Type',
                controller: _notesController,
                hint: 'e.g. 2 Adults (Double Sharing Room)',
                maxLines: 2,
                prefixIcon: const Icon(Icons.groups_outlined),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Submit Umrah Booking',
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
