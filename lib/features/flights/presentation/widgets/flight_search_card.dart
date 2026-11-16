import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/widgets/booking_ui.dart';
import '../../../../core/widgets/motion.dart';
import '../providers/flight_provider.dart';
import 'airport_selector_sheet.dart';
import 'flight_header.dart';

/// The flight search form, in the airy style the big travel apps use: a gold
/// pill segmented control over a white card of full-width rows, with one big
/// round gold action straddling the card's bottom edge.
class FlightSearchCard extends StatefulWidget {
  final FlightProvider provider;
  final VoidCallback onSearch;

  const FlightSearchCard({
    super.key,
    required this.provider,
    required this.onSearch,
  });

  @override
  State<FlightSearchCard> createState() => _FlightSearchCardState();
}

class _FlightSearchCardState extends State<FlightSearchCard> {
  static const double _actionOverhang = 40;

  int _tabIndex = 0; // 0: One Way, 1: Round Way, 2: Multi City

  FlightProvider get provider => widget.provider;
  bool get _isRound => _tabIndex == 1;
  bool get _isMultiCity => _tabIndex == 2;

  @override
  void initState() {
    super.initState();
    _tabIndex = provider.tripType == FlightSearchTripType.roundTrip ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedTabs(
          labels: [
            context.tr('common.oneWay'),
            context.tr('common.roundTrip'),
            context.tr('flights.multiCity'),
          ],
          index: _tabIndex,
          onChanged: (i) {
            setState(() => _tabIndex = i);
            if (i == 0) {
              provider.setTripType(FlightSearchTripType.oneWay);
            } else if (i == 1) {
              provider.setTripType(FlightSearchTripType.roundTrip);
            }
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        BookingCard(
          action: RoundAction(
            label: context.tr('flights.searchCta'),
            onTap: widget.onSearch,
          ),
          children: [
            _routeRows(context),
            if (!_isMultiCity) ...[
              BookingFieldPair(
                left: _dateField(context),
                right: _returnField(context),
              ),
            ] else ...[
              BookingField(
                icon: PhosphorIconsRegular.calendarBlank,
                label: context.tr('common.departure'),
                value: DateFormat('d MMM').format(provider.departureDate),
                hint: DateFormat('EEEE').format(provider.departureDate),
                onTap: () => _pickDepartureDate(context),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Center(
                  child: Pressable(
                    onTap: () {
                      _toast(context, context.pick('Added next flight segment', 'পরবর্তী ফ্লাইট সেগমেন্ট যোগ করা হয়েছে'));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            child: const Icon(PhosphorIconsBold.plus, color: Colors.white, size: 10),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.pick('ADD CITY', 'শহর যোগ করুন'),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            BookingFieldPair(
              divider: false,
              left: _MiniField(
                icon: PhosphorIconsRegular.users,
                label: context.tr('common.travelers'),
                value: _travelerLabel(context),
                hint: context.pick('Tap to select', 'নির্বাচন করুন'),
                onTap: () => _showTravelersSheet(context),
              ),
              right: _MiniField(
                icon: PhosphorIconsRegular.suitcaseSimple,
                label: context.pick('BAGGAGE', 'ব্যাগেজ'),
                value: provider.baggage,
                hint: context.pick('Tap to select', 'নির্বাচন করুন'),
                onTap: () => _showBaggageSheet(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: _actionOverhang),
      ],
    );
  }

  // ───────────────────────── Route rows ─────────────────────────

  Widget _routeRows(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CitySelectTile(
              label: context.tr('common.from'),
              city: provider.originCity,
              code: provider.originCode,
              airport: _airportLine(provider.originCode),
              icon: PhosphorIconsRegular.airplaneTakeoff,
              onTap: () => AirportSelectorSheet.show(
                context,
                title: context.trOnce('flights.fromTitle'),
                onSelect: provider.setOrigin,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Divider(height: 1, thickness: 1, color: AppColors.divider),
            ),
            _CitySelectTile(
              label: context.tr('common.to'),
              city: provider.destCity,
              code: provider.destCode,
              airport: _airportLine(provider.destCode),
              icon: PhosphorIconsRegular.airplaneLanding,
              onTap: () => AirportSelectorSheet.show(
                context,
                title: context.trOnce('flights.toTitle'),
                onSelect: provider.setDestination,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.lg),
          child: SwapButton(onTap: provider.swapAirports),
        ),
      ],
    );
  }

  String _airportLine(String code) {
    for (final a in AirportSelectorSheet.airports) {
      if (a.code == code) return '$code, ${a.name}';
    }
    return code;
  }

  // ───────────────────────── Date fields ─────────────────────────

  Widget _dateField(BuildContext context) {
    return _MiniField(
      icon: PhosphorIconsRegular.calendarBlank,
      label: context.tr('common.departure'),
      value: DateFormat('d MMM').format(provider.departureDate),
      hint: DateFormat('EEEE').format(provider.departureDate),
      onTap: () => _pickDepartureDate(context),
    );
  }

  Widget _returnField(BuildContext context) {
    final hasReturn = _isRound && provider.returnDate != null;
    return _MiniField(
      icon: PhosphorIconsRegular.calendarCheck,
      label: hasReturn ? context.tr('common.return') : '',
      value: hasReturn
          ? DateFormat('d MMM').format(provider.returnDate!)
          : context.tr('flights.addReturn'),
      hint: hasReturn
          ? DateFormat('EEEE').format(provider.returnDate!)
          : context.tr('flights.returnNudge'),
      hintTone: hasReturn ? null : AppColors.primaryLight,
      muted: !hasReturn,
      onTap: () => _pickReturnDate(context),
    );
  }

  String _travelerLabel(BuildContext context) {
    final total = provider.passengers;
    return total < 10 ? '0$total' : '$total';
  }

  // ───────────────────────── Pickers ─────────────────────────

  Future<void> _pickDepartureDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: provider.departureDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: _datePickerTheme,
    );
    if (picked != null) provider.setDepartureDate(picked);
  }

  Future<void> _pickReturnDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          provider.returnDate ?? provider.departureDate.add(const Duration(days: 7)),
      firstDate: provider.departureDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: _datePickerTheme,
    );
    if (picked == null) return;
    provider.setReturnDate(picked);
    provider.setTripType(FlightSearchTripType.roundTrip);
  }

  static Widget _datePickerTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: AppColors.textPrimary,
        ),
        datePickerTheme: DatePickerThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          headerBackgroundColor: AppColors.primary,
          headerForegroundColor: Colors.white,
        ),
      ),
      child: child ?? const SizedBox.shrink(),
    );
  }

  void _showTravelersSheet(BuildContext context) {
    int adults = provider.adults;
    int children = provider.children;
    int infants = provider.infants;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final total = adults + children + infants;
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.md,
                  AppSpacing.page,
                  AppSpacing.xl,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: SheetHandle()),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ctx.pick('Select Travelers', 'যাত্রী সংখ্যা নির্বাচন করুন'),
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.4,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primarySubtle,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            ctx.pick('$total Traveler(s)', '$total জন যাত্রী'),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _CounterRow(
                      title: ctx.pick('Adults', 'প্রাপ্তবয়স্ক'),
                      subtitle: ctx.pick('12+ years on travel date', '১২ বছরের বেশি'),
                      count: adults,
                      min: 1,
                      max: 9,
                      onChanged: (val) => setModalState(() => adults = val),
                    ),
                    const Divider(height: 24, thickness: 1, color: AppColors.divider),
                    _CounterRow(
                      title: ctx.pick('Children', 'শিশু'),
                      subtitle: ctx.pick('2 - 11 years with seat', '২ - ১১ বছর (আলাদা সিট)'),
                      count: children,
                      min: 0,
                      max: 8,
                      onChanged: (val) => setModalState(() => children = val),
                    ),
                    const Divider(height: 24, thickness: 1, color: AppColors.divider),
                    _CounterRow(
                      title: ctx.pick('Infants', 'নবজাতক'),
                      subtitle: ctx.pick('Under 2 years (on lap)', '২ বছরের নিচে (কোলে)'),
                      count: infants,
                      min: 0,
                      max: 4,
                      onChanged: (val) => setModalState(() => infants = val),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        onPressed: () {
                          provider.setTravelers(
                            adults: adults,
                            children: children,
                            infants: infants,
                          );
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          ctx.pick('Apply Travelers', 'নিশ্চিত করুন'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBaggageSheet(BuildContext context) {
    final customController = TextEditingController();
    final options = [
      {'title': '7 KG', 'desc': context.pickOnce('Cabin / Hand Baggage only', 'শুধু কেবিন ব্যাগ')},
      {'title': '20 KG', 'desc': context.pickOnce('Standard Checked Baggage (1 Piece)', 'স্ট্যান্ডার্ড চেক-ইন ব্যাগ')},
      {'title': '30 KG', 'desc': context.pickOnce('Popular Allowance (Gulf & Asia Routes)', 'জনপ্রিয় ৩০ কেজি সুবিধা')},
      {'title': '40 KG', 'desc': context.pickOnce('Extended Baggage Allowance (2 Pieces)', 'বর্ধিত ৪০ কেজি সুবিধা')},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.md,
                AppSpacing.page,
                AppSpacing.xl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: SheetHandle()),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    ctx.pick('Select Baggage Allowance', 'ব্যাগেজের ওজন নির্বাচন করুন'),
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // ── Custom KG Input Box ──
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primarySubtle.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.pick('CUSTOM BAGGAGE WEIGHT', 'কাস্টম ব্যাগেজ ওজন'),
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 44,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: TextField(
                                  controller: customController,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: context.pick('e.g. 25, 35, 50', 'যেমন: ২৫, ৩৫, ৫০'),
                                    hintStyle: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    suffixText: 'KG',
                                    suffixStyle: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppRadius.sm),
                                ),
                              ),
                              onPressed: () {
                                final text = customController.text.trim();
                                if (text.isNotEmpty) {
                                  final numOnly = text.replaceAll(RegExp(r'[^0-9.]'), '');
                                  if (numOnly.isNotEmpty) {
                                    provider.setBaggage('$numOnly KG');
                                    Navigator.pop(ctx);
                                  }
                                }
                              },
                              child: Text(
                                ctx.pick('Set', 'সেট করুন'),
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    ctx.pick('OR SELECT POPULAR ALLOWANCES', 'অথবা নির্দিষ্ট ওজন বেছে নিন'),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  for (final opt in options) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Pressable(
                        onTap: () {
                          provider.setBaggage(opt['title']!);
                          Navigator.pop(ctx);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: provider.baggage == opt['title']
                                ? AppColors.primarySubtle
                                : AppColors.background,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: provider.baggage == opt['title']
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: provider.baggage == opt['title'] ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                PhosphorIconsFill.suitcaseSimple,
                                size: 20,
                                color: provider.baggage == opt['title']
                                    ? AppColors.primary
                                    : AppColors.textMuted,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      opt['title']!,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: provider.baggage == opt['title']
                                            ? AppColors.primary
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Text(
                                      opt['desc']!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (provider.baggage == opt['title'])
                                const Icon(
                                  PhosphorIconsFill.checkCircle,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: AppColors.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _CitySelectTile extends StatelessWidget {
  final String label;
  final String city;
  final String code;
  final String airport;
  final IconData icon;
  final VoidCallback onTap;

  const _CitySelectTile({
    required this.label,
    required this.city,
    required this.code,
    required this.airport,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.xl + 40,
          AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.primarySubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        label.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.9,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          code,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          city,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        PhosphorIconsBold.caretDown,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    airport,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final int count;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _CounterRow({
    required this.title,
    required this.subtitle,
    required this.count,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            _StepBtn(
              icon: PhosphorIconsBold.minus,
              enabled: count > min,
              onTap: () => onChanged(count - 1),
            ),
            Container(
              width: 36,
              alignment: Alignment.center,
              child: Text(
                count.toString().padLeft(2, '0'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            _StepBtn(
              icon: PhosphorIconsBold.plus,
              enabled: count < max,
              onTap: () => onChanged(count + 1),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _StepBtn({required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppRadius.xs),
      child: Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primarySubtle : AppColors.divider,
          borderRadius: BorderRadius.circular(AppRadius.xs),
          border: Border.all(
            color: enabled ? AppColors.primary.withValues(alpha: 0.2) : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          size: 14,
          color: enabled ? AppColors.primary : AppColors.textMuted,
        ),
      ),
    );
  }
}

class _MiniField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? hint;
  final Color? hintTone;
  final bool muted;
  final VoidCallback onTap;

  const _MiniField({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.hint,
    this.hintTone,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
                height: 1.2,
                color: muted ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
            if (hint != null && hint!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                hint!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: hintTone == null ? FontWeight.w500 : FontWeight.w700,
                  color: hintTone ?? AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
