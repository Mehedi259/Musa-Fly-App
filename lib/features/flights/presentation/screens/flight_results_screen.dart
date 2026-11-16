import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/url_helper.dart';
import '../providers/flight_provider.dart';
import '../widgets/flight_header.dart';

/// Minimal, clean flight booking confirmation screen.
/// Displays ONLY a compact itinerary card of the user's selected search
/// and a prominent direct WhatsApp booking button.
class FlightResultsScreen extends StatelessWidget {
  const FlightResultsScreen({super.key});

  double _calculateEstimatedOmr(FlightProvider provider) {
    final isRound = provider.tripType == FlightSearchTripType.roundTrip;
    final isDomestic = ['DAC', 'CGP', 'CXB', 'ZYL'].contains(provider.originCode) &&
        ['DAC', 'CGP', 'CXB', 'ZYL'].contains(provider.destCode);

    double baseOmrPerAdult = isDomestic ? 28.0 : 115.0;
    if (isRound) baseOmrPerAdult *= 1.85;

    final adultsFare = provider.adults * baseOmrPerAdult;
    final childrenFare = provider.children * (baseOmrPerAdult * 0.75);
    final infantsFare = provider.infants * (baseOmrPerAdult * 0.20);

    return adultsFare + childrenFare + infantsFare;
  }

  String _formatDate(DateTime date, bool isBn) {
    if (isBn) {
      const bnMonths = [
        '',
        'জানুয়ারি',
        'ফেব্রুয়ারি',
        'মার্চ',
        'এপ্রিল',
        'মে',
        'জুন',
        'জুলাই',
        'আগস্ট',
        'সেপ্টেম্বর',
        'অক্টোবর',
        'নভেম্বর',
        'ডিসেম্বর',
      ];
      final day = CurrencyFormatter.toBanglaDigits(date.day.toString());
      final year = CurrencyFormatter.toBanglaDigits(date.year.toString());
      return '$day ${bnMonths[date.month]} $year';
    }
    return DateFormat('d MMM yyyy, EEEE').format(date);
  }

  void _onBookWhatsApp(BuildContext context, FlightProvider provider, double estimatedOmr, bool isBn) {
    final fareStr = isBn
        ? '${CurrencyFormatter.formatOmr(estimatedOmr, banglaDigits: true)} (≈ ${CurrencyFormatter.convertOmrToBdt(estimatedOmr, banglaDigits: true)})'
        : '${CurrencyFormatter.formatOmr(estimatedOmr)} (≈ ${CurrencyFormatter.convertOmrToBdt(estimatedOmr)})';

    final msg = provider.buildWhatsAppMessage(
      price: fareStr,
      isBangla: isBn,
    );
    UrlHelper.launchWhatsApp(customMessage: msg);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FlightProvider>();
    final isRound = provider.tripType == FlightSearchTripType.roundTrip;
    final estimatedOmr = _calculateEstimatedOmr(provider);
    final isBn = context.isBangla;

    final depDateStr = _formatDate(provider.departureDate, isBn);
    final retDateStr = provider.returnDate != null ? _formatDate(provider.returnDate!, isBn) : null;

    final tripTypeStr = isRound
        ? context.pick('Round Trip', 'রাউন্ড ট্রিপ (যাওয়া-আসা)')
        : context.pick('One Way', 'ওয়ান ওয়ে (একমুখী)');

    final travelersStr = isBn
        ? '${CurrencyFormatter.toBanglaDigits(provider.passengers.toString())} জন (${CurrencyFormatter.toBanglaDigits(provider.adults.toString())} প্রাপ্তবয়স্ক${provider.children > 0 ? ', ${CurrencyFormatter.toBanglaDigits(provider.children.toString())} শিশু' : ''}${provider.infants > 0 ? ', ${CurrencyFormatter.toBanglaDigits(provider.infants.toString())} নবজাতক' : ''})'
        : '${provider.passengers} Traveler(s) (${provider.adults} Adult${provider.children > 0 ? ', ${provider.children} Child' : ''}${provider.infants > 0 ? ', ${provider.infants} Infant' : ''})';

    final baggageStr = isBn
        ? CurrencyFormatter.toBanglaDigits(provider.baggage).replaceAll('KG', 'কেজি').replaceAll('kg', 'কেজি')
        : provider.baggage;

    final classStr = isBn
        ? (provider.travelClass.toLowerCase() == 'business' ? 'বিজনেস ক্লাস' : 'ইকোনমি ক্লাস')
        : '${provider.travelClass} Class';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          FlightHeader(
            title: context.pick('Flight Booking Details', 'ফ্লাইট বুকিং বিবরণ'),
            subtitle: '${provider.originCity} ➔ ${provider.destCity}',
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.lg,
                AppSpacing.page,
                AppSpacing.xxxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Compact Itinerary Card ──
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.border),
                      boxShadow: AppShadows.soft,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Route & Trip Badge Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${provider.originCity} ➔ ${provider.destCity}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primarySubtle,
                                borderRadius: BorderRadius.circular(AppRadius.pill),
                              ),
                              child: Text(
                                tripTypeStr,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${provider.originCode} ➔ ${provider.destCode}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Divider(height: 1, thickness: 1, color: AppColors.divider),
                        ),

                        // Key Information Rows
                        _buildInfoRow(
                          icon: PhosphorIconsRegular.calendarBlank,
                          label: context.pick('Departure', 'যাত্রার তারিখ'),
                          value: depDateStr,
                        ),

                        if (isRound && retDateStr != null) ...[
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            icon: PhosphorIconsRegular.calendarCheck,
                            label: context.pick('Return', 'ফেরার তারিখ'),
                            value: retDateStr,
                          ),
                        ],

                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: PhosphorIconsRegular.users,
                          label: context.pick('Travelers', 'যাত্রী সংখ্যা'),
                          value: travelersStr,
                        ),

                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: PhosphorIconsRegular.suitcaseSimple,
                          label: context.pick('Baggage', 'লাগেজের ওজন'),
                          value: baggageStr,
                        ),

                        const SizedBox(height: 12),
                        _buildInfoRow(
                          icon: PhosphorIconsRegular.armchair,
                          label: context.pick('Cabin Class', 'কেবিন ক্লাস'),
                          value: classStr,
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Divider(height: 1, thickness: 1, color: AppColors.divider),
                        ),

                        // Estimated Fare
                        Text(
                          context.pick('ESTIMATED STARTING FARE', 'আনুমানিক সর্বনিম্ন ভাড়া'),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Text(
                              CurrencyFormatter.formatOmr(estimatedOmr, banglaDigits: isBn),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              isBn
                                  ? '(≈ ${CurrencyFormatter.convertOmrToBdt(estimatedOmr, banglaDigits: true)} থেকে)'
                                  : '(≈ ${CurrencyFormatter.convertOmrToBdt(estimatedOmr)} est.)',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── Direct WhatsApp Action Button ──
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E), // WhatsApp vibrant green
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: const Color(0xFF22C55E).withValues(alpha: 0.4),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    icon: const Icon(PhosphorIconsFill.whatsappLogo, size: 24),
                    label: Text(
                      context.pick('Book via WhatsApp', 'হোয়াটসঅ্যাপে সরাসরি বুকিং করুন'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.2,
                      ),
                    ),
                    onPressed: () => _onBookWhatsApp(context, provider, estimatedOmr, isBn),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // ── Modify Search Details ──
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    icon: const Icon(PhosphorIconsRegular.pencilSimple, size: 15),
                    label: Text(
                      context.pick('Modify Search Details', 'ফ্লাইটের তথ্য পরিবর্তন করুন'),
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, size: 15, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
