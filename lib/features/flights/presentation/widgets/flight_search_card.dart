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
///
/// Nothing here is dense or dark on purpose — the whitespace and the large
/// city names are what make the form read as considered rather than cheap.
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
  /// Room under the card for the round action that hangs off its edge.
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
                      _toast(context, 'Added next flight segment');
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
                          const Text(
                            'ADD CITY',
                            style: TextStyle(
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
                onTap: () => _showPassengerPicker(context),
              ),
              right: _MiniField(
                icon: PhosphorIconsRegular.seat,
                label: context.tr('common.class'),
                value: _classLabel(context, provider.travelClass),
                onTap: () => _showClassPicker(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: _actionOverhang),
      ],
    );
  }

  // ───────────────────────── Route rows ─────────────────────────

  /// FROM and TO stacked, with the circular swap control sitting on the right
  /// edge of the hairline between them.
  Widget _routeRows(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BookingField(
              icon: PhosphorIconsRegular.airplaneTakeoff,
              label: context.tr('common.from'),
              value: provider.originCity,
              hint: _airportLine(provider.originCode),
              trailing: const SizedBox(width: 34),
              onTap: () => AirportSelectorSheet.show(
                context,
                title: context.trOnce('flights.fromTitle'),
                onSelect: provider.setOrigin,
              ),
            ),
            BookingField(
              icon: PhosphorIconsRegular.airplaneLanding,
              label: context.tr('common.to'),
              value: provider.destCity,
              hint: _airportLine(provider.destCode),
              trailing: const SizedBox(width: 34),
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

  /// "DAC, Hazrat Shahjalal International Airport" — the code plus the full
  /// airport name when we know it, otherwise just the code.
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
    final n = provider.passengers;
    return n.toString().padLeft(2, '0');
  }

  static String _classLabel(BuildContext context, String raw) {
    const keys = <String, String>{
      'Economy': 'flights.classEconomy',
      'Premium Economy': 'flights.classPremium',
      'Business': 'flights.classBusiness',
      'First Class': 'flights.classFirst',
    };
    final key = keys[raw];
    return key == null ? raw : context.tr(key);
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
    // Picking a return date is itself the switch to a round trip — the user
    // should not have to set the tab first.
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

  void _showPassengerPicker(BuildContext context) {
    _showSheet(
      context,
      title: context.trOnce('flights.whoTravels'),
      subtitle: context.trOnce('flights.whoTravelsNote'),
      builder: (ctx) => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(6, (index) {
          final count = index + 1;
          final selected = provider.passengers == count;
          final word = ctx.tr(count == 1 ? 'flights.traveler' : 'flights.travelers');
          return Pressable(
            onTap: () {
              provider.setPassengers(count);
              Navigator.pop(ctx);
            },
            child: AnimatedContainer(
              duration: AppMotion.fast,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Text(
                '$count $word',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _showClassPicker(BuildContext context) {
    const options = <String, IconData>{
      'Economy': PhosphorIconsRegular.seat,
      'Premium Economy': PhosphorIconsRegular.armchair,
      'Business': PhosphorIconsRegular.briefcase,
      'First Class': PhosphorIconsRegular.crownSimple,
    };

    _showSheet(
      context,
      title: context.trOnce('flights.classTitle'),
      subtitle: context.trOnce('flights.classNote'),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: options.entries.map((e) {
          final selected = provider.travelClass == e.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Pressable(
              onTap: () {
                provider.setTravelClass(e.key);
                Navigator.pop(ctx);
              },
              child: AnimatedContainer(
                duration: AppMotion.fast,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primarySubtle : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.border,
                    width: selected ? 1.4 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      e.value,
                      size: 21,
                      color: selected ? AppColors.primary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        _classLabel(ctx, e.key),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                          color: selected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (selected)
                      const Icon(
                        PhosphorIconsFill.checkCircle,
                        size: 20,
                        color: AppColors.primary,
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showSheet(
    BuildContext context, {
    required String title,
    String? subtitle,
    required WidgetBuilder builder,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
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
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                Builder(builder: builder),
              ],
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

/// Half-width sibling of [BookingField]: same label-over-value shape, tuned so
/// a long Bangla line still fits beside another field at 320pt.
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
