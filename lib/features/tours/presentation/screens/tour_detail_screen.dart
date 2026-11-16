import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/premium.dart';
import '../../../deals/data/models/deal_model.dart';
import '../../../deals/data/repositories/deal_repository.dart';
import '../../data/models/tour_model.dart';
import '../widgets/travel_ui.dart';

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
    final tour = widget.tour;
    final price = CurrencyFormatter.formatSmart(tour.price);
    final inclusions = tour.inclusionList;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          PhotoHeroSliver(
            title: tour.destination,
            subtitle: 'Holiday package · ${tour.duration}',
            imageUrl: tour.displayImage,
            fallbackUrl: AppAssets.fallbackTour,
            chips: [
              ToneChip(
                label: tour.duration,
                icon: PhosphorIconsFill.clock,
                tone: ChipTone.onImage,
              ),
              const ToneChip(
                label: '4.8 · 320 reviews',
                icon: PhosphorIconsFill.star,
                tone: ChipTone.onImage,
              ),
            ],
            actions: [
              GlassIconButton(
                icon: PhosphorIconsBold.shareNetwork,
                onTap: () {
                  UrlHelper.launchWhatsApp(
                    customMessage:
                        'Check out this tour package on MusaFly: ${tour.destination} (${tour.duration}) for $price!',
                  );
                },
              ),
            ],
          ),
          DetailSheet(
            children: [
              SoftPanel(
                tint: AppColors.catTour,
                padding: const EdgeInsets.all(AppSpacing.lg),
                radius: AppRadius.md,
                child: Row(
                  children: [
                    Icon(PhosphorIconsFill.tag, size: 20, color: AppColors.catTour),
                    const SizedBox(width: AppSpacing.md),
                    const Expanded(
                      child: Text(
                        'All taxes and service charges are already included in this price.',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(
                title: 'Trip at a glance',
                padding: EdgeInsets.only(bottom: AppSpacing.md),
              ),
              GlanceStrip(
                tiles: [
                  InfoTile(
                    icon: PhosphorIconsRegular.clock,
                    label: 'Duration',
                    value: tour.duration,
                  ),
                  const InfoTile(
                    icon: PhosphorIconsRegular.bed,
                    label: 'Stay',
                    value: '4★ hotels',
                  ),
                  const InfoTile(
                    icon: PhosphorIconsRegular.van,
                    label: 'Transfers',
                    value: 'Private',
                  ),
                ],
              ),
              if (inclusions.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xl),
                const SectionHeader(
                  title: "What's included",
                  subtitle: 'Everything covered by the package price',
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                ),
                PremiumCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [for (final item in inclusions) CheckLine(text: item)],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(
                title: 'Why book with MusaFly',
                padding: EdgeInsets.only(bottom: AppSpacing.md),
              ),
              PremiumCard(
                child: Column(
                  children: [
                    FeatureRow(
                      icon: PhosphorIconsRegular.buildings,
                      title: 'Premium accommodation',
                      subtitle: 'Handpicked 4-star and luxury properties, centrally located.',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: DashedDivider(),
                    ),
                    FeatureRow(
                      icon: PhosphorIconsRegular.mapTrifold,
                      title: 'Airport & sightseeing transfers',
                      subtitle: 'Private air-conditioned vehicles with an English-speaking driver.',
                      color: AppColors.catTour,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: DashedDivider(),
                    ),
                    FeatureRow(
                      icon: PhosphorIconsRegular.headset,
                      title: '24/7 dedicated concierge',
                      subtitle: 'On-ground assistance at your destination, any time of day.',
                      color: AppColors.success,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: StickyActionBar(
        priceLabel: 'Starting at',
        priceValue: price,
        priceNote: 'per person',
        secondary: SoftIconButton(
          icon: PhosphorIconsFill.whatsappLogo,
          color: AppColors.whatsapp,
          size: 54,
          tooltip: 'Chat on WhatsApp',
          onTap: () {
            UrlHelper.launchWhatsApp(
              customMessage:
                  'Hello MusaFly! I am interested in the ${widget.tour.destination} (${widget.tour.duration}) tour package priced at $price. Could you please provide full itinerary details?',
            );
          },
        ),
        action: PremiumButton(
          label: 'Book package',
          icon: PhosphorIconsBold.arrowRight,
          trailingIcon: true,
          onPressed: _openBookingSheet,
        ),
      ),
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
        address: _notesController.text.trim().isEmpty
            ? 'Tour Booking Request'
            : _notesController.text.trim(),
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
      final name = _nameController.text.trim();
      Navigator.pop(context);

      showSubmissionSuccess(
        context,
        title: 'Tour inquiry received',
        message:
            'Our holiday planner will get in touch with you to customize your ${widget.tour.destination} trip.',
        chatLabel: 'Chat with agent',
        onChat: () => UrlHelper.launchWhatsApp(
          customMessage:
              'Hi MusaFly! I just submitted an inquiry for ${widget.tour.destination}. My name is $name.',
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
      // Sized to its content, capped so a long form still scrolls. A fixed
      // height left a slab of empty white under short forms.
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.md,
        AppSpacing.page,
        MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xl,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SheetHeader(
                title: 'Book ${widget.tour.destination}',
                subtitle: '${widget.tour.duration} · ${CurrencyFormatter.formatSmart(widget.tour.price)} per person',
              ),
              const SizedBox(height: AppSpacing.lg),
              CustomTextField(
                label: 'Your Name *',
                controller: _nameController,
                hint: 'Full Name',
                prefixIcon: Icon(PhosphorIconsRegular.user),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Phone Number *',
                controller: _phoneController,
                hint: 'e.g. +968 95923226',
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(PhosphorIconsRegular.phone),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Email',
                controller: _emailController,
                hint: 'name@domain.com',
                prefixIcon: Icon(PhosphorIconsRegular.envelopeSimple),
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Special Requests / Number of Guests',
                controller: _notesController,
                hint: 'e.g. 2 Adults, 1 Child',
                maxLines: 2,
                prefixIcon: Icon(PhosphorIconsRegular.usersThree),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PremiumButton(
                label: 'Send booking inquiry',
                loading: _isSubmitting,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(PhosphorIconsFill.lockSimple, size: 12, color: AppColors.textMuted),
                  const SizedBox(width: 5),
                  const Flexible(
                    child: Text(
                      'Your details are only used to prepare this quote.',
                      maxLines: 2,
                      style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
