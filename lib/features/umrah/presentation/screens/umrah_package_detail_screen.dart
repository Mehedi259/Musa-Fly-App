import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/premium.dart';
import '../../../deals/data/models/deal_model.dart';
import '../../../deals/data/repositories/deal_repository.dart';
import '../../../tours/presentation/widgets/travel_ui.dart';
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
    final pkg = widget.package;
    final price = CurrencyFormatter.formatSmart(pkg.price);
    final inclusions = pkg.inclusionList;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          PhotoHeroSliver(
            title: pkg.cleanTitle,
            subtitle: 'Umrah package · ${pkg.duration}',
            imageUrl: pkg.displayImage,
            fallbackUrl: AppAssets.fallbackKaaba,
            chips: const [
              GoldBadge(label: 'Umrah special', icon: PhosphorIconsFill.crown),
            ],
            actions: [
              GlassIconButton(
                icon: PhosphorIconsBold.shareNetwork,
                onTap: () {
                  UrlHelper.launchWhatsApp(
                    customMessage:
                        'Have a look at this Umrah package on MusaFly: ${pkg.packageName} for $price.',
                  );
                },
              ),
            ],
          ),
          DetailSheet(
            children: [
              SoftPanel(
                tint: AppColors.secondary,
                padding: const EdgeInsets.all(AppSpacing.lg),
                radius: AppRadius.md,
                child: Row(
                  children: [
                    Icon(PhosphorIconsFill.sealCheck, size: 20, color: AppColors.secondaryDark),
                    const SizedBox(width: AppSpacing.md),
                    const Expanded(
                      child: Text(
                        'Operated by a Saudi Ministry-approved Umrah provider. Visa and ground service handled for you.',
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
                title: 'Package at a glance',
                padding: EdgeInsets.only(bottom: AppSpacing.md),
              ),
              GlanceStrip(
                tiles: [
                  InfoTile(
                    icon: PhosphorIconsRegular.calendarBlank,
                    label: 'Duration',
                    value: pkg.duration,
                    color: AppColors.catUmrah,
                  ),
                  const InfoTile(
                    icon: PhosphorIconsRegular.identificationCard,
                    label: 'Visa',
                    value: 'Included',
                    color: AppColors.catUmrah,
                  ),
                  const InfoTile(
                    icon: PhosphorIconsRegular.airplaneTilt,
                    label: 'Flights',
                    value: 'Return',
                    color: AppColors.catUmrah,
                  ),
                ],
              ),
              if (inclusions.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xl),
                const SectionHeader(
                  title: 'Package inclusions',
                  subtitle: 'Covered by the price shown below',
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                ),
                PremiumCard(
                  featured: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final item in inclusions)
                        CheckLine(
                          text: item,
                          color: AppColors.secondaryDark,
                          icon: PhosphorIconsFill.sealCheck,
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(
                title: 'Accommodation',
                subtitle: 'Where you stay in the two holy cities',
                padding: EdgeInsets.only(bottom: AppSpacing.md),
              ),
              const PremiumCard(
                child: Column(
                  children: [
                    FeatureRow(
                      icon: PhosphorIconsRegular.buildings,
                      title: 'Makkah Al-Mukarramah',
                      subtitle: 'Hotel a short walk from Masjid Al-Haram, with shuttle service.',
                      color: AppColors.catUmrah,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: DashedDivider(),
                    ),
                    FeatureRow(
                      icon: PhosphorIconsRegular.mosque,
                      title: 'Madinah Al-Munawwarah',
                      subtitle: 'Walking distance to Al-Masjid an-Nabawi, breakfast included.',
                      color: AppColors.catUmrah,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: DashedDivider(),
                    ),
                    FeatureRow(
                      icon: PhosphorIconsRegular.van,
                      title: 'Ground transport & Ziyarah',
                      subtitle: 'Airport pick-up, inter-city transfer and guided Ziyarah tours.',
                      color: AppColors.catUmrah,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(
                title: 'Good to know',
                padding: EdgeInsets.only(bottom: AppSpacing.md),
              ),
              const PremiumCard(
                child: Column(
                  children: [
                    FeatureRow(
                      icon: PhosphorIconsRegular.usersThree,
                      title: 'Family & group friendly',
                      subtitle: 'Double, triple and quad sharing rooms can be arranged on request.',
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                      child: DashedDivider(),
                    ),
                    FeatureRow(
                      icon: PhosphorIconsRegular.headset,
                      title: 'Advisor on call',
                      subtitle: 'A dedicated Umrah advisor stays reachable through your journey.',
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
        priceLabel: context.pick('Per pilgrim', 'প্রতি যাত্রী'),
        priceValue: price,
        priceNote: context.isBangla
            ? '≈ ${CurrencyFormatter.convertOmrToBdt(pkg.price, banglaDigits: true)}'
            : 'all-in',
        secondary: SoftIconButton(
          icon: PhosphorIconsFill.whatsappLogo,
          color: AppColors.whatsapp,
          size: 54,
          tooltip: 'Chat on WhatsApp',
          onTap: () {
            UrlHelper.launchWhatsApp(
              customMessage:
                  'Salam MusaFly! I am interested in the ${widget.package.packageName} priced at $price. Please share full Umrah details.',
            );
          },
        ),
        action: PremiumButton(
          label: 'Book Umrah',
          icon: PhosphorIconsBold.arrowRight,
          trailingIcon: true,
          onPressed: _openBookingSheet,
        ),
      ),
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
        address:
            _notesController.text.trim().isEmpty ? 'Umrah Request' : _notesController.text.trim(),
        passportNumber: 'N/A',
        email: _emailController.text.trim(),
        serviceCategory: 'Umrah Package',
        routeDestination: widget.package.packageName,
        travelDate: _preferredDate,
        leadSource: 'Mobile App',
        dealPrice: widget.package.price,
        currency: 'OMR',
      );

      await DealRepository().createDeal(deal);
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      final name = _nameController.text.trim();
      Navigator.pop(context);

      showSubmissionSuccess(
        context,
        title: 'Umrah application submitted',
        message:
            'May Allah accept your intention. Our Umrah advisor will call you to arrange visa and flight details.',
        chatLabel: 'Chat with advisor',
        onChat: () => UrlHelper.launchWhatsApp(
          customMessage:
              'Salam MusaFly! I submitted an application for ${widget.package.packageName}. My name is $name.',
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
                title: context.pick('Book ${widget.package.cleanTitle}', '${widget.package.cleanTitle} বুকিং'),
                subtitle: context.isBangla
                    ? '${widget.package.duration} · ${CurrencyFormatter.formatSmart(widget.package.price)} (≈ ${CurrencyFormatter.convertOmrToBdt(widget.package.price, banglaDigits: true)})'
                    : '${widget.package.duration} · ${CurrencyFormatter.formatSmart(widget.package.price)} per pilgrim',
              ),
              const SizedBox(height: AppSpacing.lg),
              CustomTextField(
                label: 'Pilgrim Full Name *',
                controller: _nameController,
                hint: 'Name as on passport',
                prefixIcon: Icon(PhosphorIconsRegular.user),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Phone Number (with country code) *',
                controller: _phoneController,
                hint: '+968 or +880 number',
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(PhosphorIconsRegular.phone),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Email',
                controller: _emailController,
                hint: 'email@domain.com',
                prefixIcon: Icon(PhosphorIconsRegular.envelopeSimple),
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Number of Pilgrims / Room Type',
                controller: _notesController,
                hint: 'e.g. 2 Adults (Double Sharing Room)',
                maxLines: 2,
                prefixIcon: Icon(PhosphorIconsRegular.usersThree),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PremiumButton(
                label: 'Submit Umrah booking',
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
                      'Your details are only used to prepare this booking.',
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
