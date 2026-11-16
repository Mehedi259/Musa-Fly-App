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
import '../../../tours/presentation/widgets/travel_ui.dart';
import '../../data/models/visa_model.dart';

class VisaDetailScreen extends StatefulWidget {
  final VisaModel visa;

  const VisaDetailScreen({super.key, required this.visa});

  @override
  State<VisaDetailScreen> createState() => _VisaDetailScreenState();
}

class _VisaDetailScreenState extends State<VisaDetailScreen> {
  static const List<({String title, String detail, IconData icon})> _steps = [
    (
      title: 'Apply online',
      detail: 'Fill in the short form here, or send your details to us on WhatsApp.',
      icon: PhosphorIconsFill.fileText,
    ),
    (
      title: 'Document review',
      detail: 'Our visa consultant checks every paper and prepares your dossier.',
      icon: PhosphorIconsFill.magnifyingGlass,
    ),
    (
      title: 'Embassy submission',
      detail: 'We submit directly to the embassy or the official online portal.',
      icon: PhosphorIconsFill.stamp,
    ),
    (
      title: 'Receive your visa',
      detail: 'The approved visa reaches you by email and WhatsApp as soon as it is issued.',
      icon: PhosphorIconsFill.paperPlaneTilt,
    ),
  ];

  void _openApplicationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _VisaApplicationSheet(visa: widget.visa),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visa = widget.visa;
    final price = CurrencyFormatter.formatSmart(visa.price);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          PhotoHeroSliver(
            title: '${visa.country} Visa',
            subtitle: visa.visaType,
            imageUrl: visa.displayImage,
            fallbackUrl: AppAssets.fallbackVisa,
            chips: [
              ToneChip(
                label: visa.visaType.toUpperCase(),
                icon: PhosphorIconsFill.identificationCard,
                tone: ChipTone.onImage,
              ),
              ToneChip(
                label: visa.formattedProcessingTime,
                icon: PhosphorIconsFill.lightning,
                tone: ChipTone.onImage,
              ),
            ],
            actions: [
              GlassIconButton(
                icon: PhosphorIconsBold.shareNetwork,
                onTap: () {
                  UrlHelper.launchWhatsApp(
                    customMessage:
                        'Need assistance for ${visa.country} ${visa.visaType} visa processing with MusaFly.',
                  );
                },
              ),
            ],
          ),
          DetailSheet(
            children: [
              SoftPanel(
                tint: AppColors.catVisa,
                padding: const EdgeInsets.all(AppSpacing.lg),
                radius: AppRadius.md,
                child: Row(
                  children: [
                    Icon(PhosphorIconsFill.shieldCheck, size: 20, color: AppColors.catVisa),
                    const SizedBox(width: AppSpacing.md),
                    const Expanded(
                      child: Text(
                        'Full document support, and we keep you updated at every stage of the application.',
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
                title: 'At a glance',
                padding: EdgeInsets.only(bottom: AppSpacing.md),
              ),
              GlanceStrip(
                tiles: [
                  InfoTile(
                    icon: PhosphorIconsRegular.lightning,
                    label: 'Processing',
                    value: visa.formattedProcessingTime,
                    color: AppColors.catVisa,
                  ),
                  InfoTile(
                    icon: PhosphorIconsRegular.identificationCard,
                    label: 'Visa type',
                    value: visa.visaType,
                    color: AppColors.catVisa,
                  ),
                  const InfoTile(
                    icon: PhosphorIconsRegular.globeHemisphereEast,
                    label: 'Submission',
                    value: 'Handled',
                    color: AppColors.catVisa,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(
                title: 'Required documents',
                subtitle: 'Keep these ready before you apply',
                padding: EdgeInsets.only(bottom: AppSpacing.md),
              ),
              PremiumCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final req in visa.requirementList) CheckLine(text: req),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(
                title: 'How it works',
                subtitle: 'Four steps from application to approval',
                padding: EdgeInsets.only(bottom: AppSpacing.md),
              ),
              const PremiumCard(
                child: StepTimeline(steps: _steps, color: AppColors.catVisa),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: StickyActionBar(
        priceLabel: 'Total visa fee',
        priceValue: price,
        priceNote: 'per applicant',
        secondary: SoftIconButton(
          icon: PhosphorIconsFill.whatsappLogo,
          color: AppColors.whatsapp,
          size: 54,
          tooltip: 'Chat on WhatsApp',
          onTap: () {
            UrlHelper.launchWhatsApp(
              customMessage:
                  'Hello MusaFly! I am applying for the ${widget.visa.country} ${widget.visa.visaType} visa. Could you assist me with document requirements?',
            );
          },
        ),
        action: PremiumButton(
          label: 'Apply now',
          icon: PhosphorIconsBold.arrowRight,
          trailingIcon: true,
          onPressed: _openApplicationSheet,
        ),
      ),
    );
  }
}

class _VisaApplicationSheet extends StatefulWidget {
  final VisaModel visa;
  const _VisaApplicationSheet({required this.visa});

  @override
  State<_VisaApplicationSheet> createState() => _VisaApplicationSheetState();
}

class _VisaApplicationSheetState extends State<_VisaApplicationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passportController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passportController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final deal = DealModel(
        customerName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? 'Visa Application'
            : _addressController.text.trim(),
        passportNumber:
            _passportController.text.trim().isEmpty ? 'N/A' : _passportController.text.trim(),
        email: _emailController.text.trim(),
        serviceCategory: 'Visa Service',
        routeDestination: '${widget.visa.country} (${widget.visa.visaType})',
        travelDate: DateTime.now().add(const Duration(days: 15)),
        leadSource: 'Mobile App',
        dealPrice: widget.visa.price,
        currency: 'USD',
      );

      await DealRepository().createDeal(deal);
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      final name = _nameController.text.trim();
      Navigator.pop(context);

      showSubmissionSuccess(
        context,
        title: 'Visa request submitted',
        message:
            'Our visa expert will contact you to collect the required papers for ${widget.visa.country}.',
        chatLabel: 'Connect on WhatsApp',
        onChat: () => UrlHelper.launchWhatsApp(
          customMessage:
              'Hi MusaFly! I just submitted an application for ${widget.visa.country} visa. Name: $name.',
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
                title: 'Apply for ${widget.visa.country} visa',
                subtitle:
                    '${widget.visa.visaType} · ${CurrencyFormatter.formatSmart(widget.visa.price)}',
              ),
              const SizedBox(height: AppSpacing.lg),
              CustomTextField(
                label: 'Applicant Full Name *',
                controller: _nameController,
                hint: 'Name as on passport',
                prefixIcon: Icon(PhosphorIconsRegular.user),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Phone Number (with WhatsApp) *',
                controller: _phoneController,
                hint: '+968 or +880 number',
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(PhosphorIconsRegular.phone),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Passport Number',
                controller: _passportController,
                hint: 'e.g. A01234567',
                prefixIcon: Icon(PhosphorIconsRegular.identificationCard),
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Email Address',
                controller: _emailController,
                hint: 'applicant@domain.com',
                prefixIcon: Icon(PhosphorIconsRegular.envelopeSimple),
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Current Residence City / Country',
                controller: _addressController,
                hint: 'e.g. Muscat, Oman / Dhaka, Bangladesh',
                prefixIcon: Icon(PhosphorIconsRegular.mapPin),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PremiumButton(
                label: 'Submit visa application',
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
                      'Your documents and details stay confidential.',
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
