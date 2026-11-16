import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../../../deals/data/models/deal_model.dart';
import '../../../deals/data/repositories/deal_repository.dart';
import '../../data/models/flight_model.dart';

class FlightBookingDialog extends StatefulWidget {
  final FlightModel flight;

  const FlightBookingDialog({super.key, required this.flight});

  static void show(BuildContext context, FlightModel flight) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FlightBookingDialog(flight: flight),
    );
  }

  @override
  State<FlightBookingDialog> createState() => _FlightBookingDialogState();
}

class _FlightBookingDialogState extends State<FlightBookingDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passportController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isSubmitting = false;
  final DealRepository _dealRepository = DealRepository();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passportController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final deal = DealModel(
        customerName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? 'Online App Request'
            : _addressController.text.trim(),
        passportNumber: _passportController.text.trim().isEmpty
            ? 'N/A'
            : _passportController.text.trim(),
        email: _emailController.text.trim(),
        serviceCategory: 'Flight Ticket',
        routeDestination:
            '${widget.flight.origin} to ${widget.flight.destination}',
        travelDate: widget.flight.departureTime,
        airlineName: widget.flight.airline,
        leadSource: 'Mobile App',
        dealPrice: widget.flight.price,
        currency: 'USD',
      );

      await _dealRepository.createDeal(deal);

      if (!mounted) return;
      setState(() => _isSubmitting = false);
      Navigator.pop(context);

      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking error: $e'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            AppSpacing.xxl,
            AppSpacing.xxl,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.successSubtle,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.glow(AppColors.success, opacity: 0.18),
                ),
                child: Icon(
                  PhosphorIconsFill.checkCircle,
                  color: AppColors.success,
                  size: 44,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Booking request sent',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Our travel specialist will contact you shortly to confirm your seats and tickets.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              PremiumButton(
                label: 'Chat on WhatsApp',
                icon: PhosphorIconsFill.whatsappLogo,
                style: PremiumButtonStyle.whatsapp,
                onPressed: () {
                  Navigator.pop(ctx);
                  final msg =
                      "Hi MusaFly! I submitted a booking request for ${widget.flight.airline} (${widget.flight.origin} → ${widget.flight.destination}) on ${DateFormatter.formatFlightDate(widget.flight.departureTime)}. Name: ${_nameController.text.trim()}";
                  UrlHelper.launchWhatsApp(customMessage: msg);
                },
              ),
              const SizedBox(height: AppSpacing.xs),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _whatsappDirect() {
    Navigator.pop(context);
    final msg =
        "Hi MusaFly! I'd like to book flight ${widget.flight.airline} from ${widget.flight.origin} to ${widget.flight.destination} on ${DateFormatter.formatFlightDate(widget.flight.departureTime)}.";
    UrlHelper.launchWhatsApp(customMessage: msg);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxHeight =
        (media.size.height - media.viewInsets.bottom - 40).clamp(
          240.0,
          media.size.height,
        );

    return AnimatedPadding(
      duration: AppMotion.fast,
      curve: AppMotion.ease,
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Container(
        height: (media.size.height * 0.92).clamp(240.0, maxHeight).toDouble(),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            _sheetHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.lg,
                  AppSpacing.page,
                  AppSpacing.xxl,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeSlideIn(child: _summaryBanner()),
                      const SizedBox(height: AppSpacing.xl),
                      FadeSlideIn(index: 1, child: _formCard()),
                      const SizedBox(height: AppSpacing.md),
                      FadeSlideIn(
                        index: 2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              PhosphorIconsRegular.shieldCheck,
                              size: 15,
                              color: AppColors.textMuted,
                            ),
                            const SizedBox(width: 7),
                            const Expanded(
                              child: Text(
                                'No payment is taken here. We hold your fare and confirm by phone before ticketing.',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.textMuted,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            StickyActionBar(
              priceLabel: 'Total fare',
              priceValue: CurrencyFormatter.formatSmart(widget.flight.price),
              priceNote: 'per traveler',
              secondary: SoftIconButton(
                icon: PhosphorIconsFill.whatsappLogo,
                color: AppColors.whatsapp,
                size: 52,
                tooltip: 'Book on WhatsApp',
                onTap: _whatsappDirect,
              ),
              action: PremiumButton(
                label: _isSubmitting ? 'Sending…' : 'Confirm booking',
                loading: _isSubmitting,
                icon: PhosphorIconsBold.arrowRight,
                trailingIcon: true,
                onPressed: _isSubmitting ? null : _submitBooking,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetHeader() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderStrong,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.page, 12, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Book flight ticket',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.flight.originCode} → ${widget.flight.destinationCode} · ${DateFormatter.formatShortDate(widget.flight.departureTime)}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Pressable(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.divider,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      PhosphorIconsBold.x,
                      size: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────── Summary banner ─────────────────────────

  Widget _summaryBanner() {
    final flight = widget.flight;
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.medium,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -30,
            bottom: -40,
            child: Icon(
              PhosphorIconsFill.airplaneTilt,
              size: 130,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        flight.airline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormatter.formatFlightDate(flight.departureTime),
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    _bannerEndpoint(
                      code: flight.originCode,
                      city: flight.originCity,
                      time: DateFormatter.formatFlightTime(
                        flight.departureTime,
                      ),
                      alignEnd: false,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Icon(
                                PhosphorIconsFill.airplaneTilt,
                                color: AppColors.secondary,
                                size: 17,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _bannerEndpoint(
                      code: flight.destinationCode,
                      city: flight.destinationCity,
                      time: DateFormatter.formatFlightTime(flight.arrivalTime),
                      alignEnd: true,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.goldCta,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        CurrencyFormatter.formatSmart(flight.price),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                          fontFeatures: AppText.tabular,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      DateFormatter.calculateDuration(
                        flight.departureTime,
                        flight.arrivalTime,
                      ),
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.75),
                        fontFeatures: AppText.tabular,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bannerEndpoint({
    required String code,
    required String city,
    required String time,
    required bool alignEnd,
  }) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          code,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.4,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 2),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 88),
          child: Text(
            city,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: alignEnd ? TextAlign.end : TextAlign.start,
            style: TextStyle(
              fontSize: 11.5,
              color: Colors.white.withValues(alpha: 0.72),
            ),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          time,
          maxLines: 1,
          softWrap: false,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: AppColors.secondaryLight,
            fontFeatures: AppText.tabular,
          ),
        ),
      ],
    );
  }

  // ───────────────────────── Form ─────────────────────────

  Widget _formCard() {
    return PremiumCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Passenger information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            label: 'Full name *',
            hint: 'Enter traveler name as in passport',
            controller: _nameController,
            prefixIcon: Icon(
              PhosphorIconsRegular.user,
              size: 18,
              color: AppColors.primary,
            ),
            validator: (val) => val == null || val.trim().isEmpty
                ? 'Please enter name'
                : null,
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            label: 'Phone number *',
            hint: '+968 or +880 number',
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            prefixIcon: Icon(
              PhosphorIconsRegular.phone,
              size: 18,
              color: AppColors.primary,
            ),
            validator: (val) => val == null || val.trim().isEmpty
                ? 'Please enter phone number'
                : null,
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            label: 'Passport number',
            hint: 'e.g. A01234567',
            controller: _passportController,
            prefixIcon: Icon(
              PhosphorIconsRegular.identificationCard,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            label: 'Email address',
            hint: 'name@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(
              PhosphorIconsRegular.envelopeSimple,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            label: 'Address / special requests',
            hint: 'e.g. Muscat, Oman / Meal preference',
            controller: _addressController,
            maxLines: 2,
            prefixIcon: Icon(
              PhosphorIconsRegular.note,
              size: 18,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
