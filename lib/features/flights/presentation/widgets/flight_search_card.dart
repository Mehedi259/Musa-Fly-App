import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/widgets/motion.dart';
import '../providers/flight_provider.dart';
import 'airport_selector_sheet.dart';

/// The signature widget of the app: a navy "boarding console" that floats
/// over the hero. Segmented trip type, a white route panel with a rotating
/// swap control, compact detail tiles and a gold CTA.
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
  /// Half-turns accumulated by the swap button, so each tap spins it 180°.
  double _swapTurns = 0;

  FlightProvider get provider => widget.provider;

  @override
  Widget build(BuildContext context) {
    final isRound = provider.tripType == FlightSearchTripType.roundTrip;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.elevated,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Soft gold bloom in the top-right corner — keeps the navy from
          // reading as a flat block.
          Positioned(
            right: -40,
            top: -46,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.26),
                    AppColors.secondary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TripTypeSwitch(
                  isRound: isRound,
                  onChanged: provider.setTripType,
                ),
                const SizedBox(height: AppSpacing.lg),
                _routePanel(context),
                const SizedBox(height: AppSpacing.md),
                AnimatedSize(
                  duration: AppMotion.base,
                  curve: AppMotion.emphasized,
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: [
                      Expanded(
                        child: _DetailTile(
                          label: 'DEPARTURE',
                          value: DateFormat(
                            'EEE, dd MMM',
                          ).format(provider.departureDate),
                          icon: PhosphorIconsRegular.calendarBlank,
                          onTap: () => _pickDepartureDate(context),
                        ),
                      ),
                      if (isRound) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _DetailTile(
                            label: 'RETURN',
                            value: provider.returnDate != null
                                ? DateFormat(
                                    'EEE, dd MMM',
                                  ).format(provider.returnDate!)
                                : 'Add date',
                            icon: PhosphorIconsRegular.calendarCheck,
                            muted: provider.returnDate == null,
                            onTap: () => _pickReturnDate(context),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _DetailTile(
                        label: 'TRAVELLERS',
                        value:
                            '${provider.passengers} Traveller${provider.passengers > 1 ? 's' : ''}',
                        icon: PhosphorIconsRegular.users,
                        onTap: () => _showPassengerPicker(context),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _DetailTile(
                        label: 'CLASS',
                        value: provider.travelClass,
                        icon: PhosphorIconsRegular.seat,
                        onTap: () => _showClassPicker(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                _searchButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────── Route panel ─────────────────────────

  Widget _routePanel(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.soft,
      ),
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Column(
            children: [
              _AirportRow(
                label: 'FROM',
                code: provider.originCode,
                city: provider.originCity,
                icon: PhosphorIconsDuotone.airplaneTakeoff,
                onTap: () => AirportSelectorSheet.show(
                  context,
                  title: 'Departure city',
                  onSelect: provider.setOrigin,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60, right: 70),
                child: Container(height: 1, color: AppColors.divider),
              ),
              _AirportRow(
                label: 'TO',
                code: provider.destCode,
                city: provider.destCity,
                icon: PhosphorIconsDuotone.airplaneLanding,
                onTap: () => AirportSelectorSheet.show(
                  context,
                  title: 'Destination city',
                  onSelect: provider.setDestination,
                ),
              ),
            ],
          ),
          Positioned(
            right: 14,
            child: Pressable(
              onTap: () {
                setState(() => _swapTurns += 0.5);
                provider.swapAirports();
              },
              scale: 0.88,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.secondary, width: 1.5),
                  boxShadow: AppShadows.glow(
                    AppColors.secondary,
                    opacity: 0.22,
                  ),
                ),
                child: AnimatedRotation(
                  turns: _swapTurns,
                  duration: AppMotion.base,
                  curve: AppMotion.emphasized,
                  child: Icon(
                    PhosphorIconsBold.arrowsDownUp,
                    size: 18,
                    color: AppColors.secondaryDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchButton() {
    return Pressable(
      onTap: widget.onSearch,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.goldCta,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: AppShadows.glow(AppColors.secondary, opacity: 0.42),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIconsBold.magnifyingGlass,
              size: 19,
              color: AppColors.primaryDark,
            ),
            const SizedBox(width: 9),
            const Text(
              'Search Flights',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
                color: AppColors.primaryDark,
              ),
            ),
          ],
        ),
      ),
    );
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
          provider.returnDate ??
          provider.departureDate.add(const Duration(days: 7)),
      firstDate: provider.departureDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: _datePickerTheme,
    );
    if (picked != null) provider.setReturnDate(picked);
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
      title: 'Who is travelling?',
      subtitle: 'Adults aged 12 and over',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(6, (index) {
          final count = index + 1;
          final selected = provider.passengers == count;
          return Pressable(
            onTap: () {
              provider.setPassengers(count);
              Navigator.pop(context);
            },
            child: AnimatedContainer(
              duration: AppMotion.fast,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.background,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border,
                ),
                boxShadow: selected
                    ? AppShadows.glow(AppColors.primary, opacity: 0.2)
                    : null,
              ),
              child: Text(
                '$count Adult${count > 1 ? 's' : ''}',
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
    final options = <String, IconData>{
      'Economy': PhosphorIconsDuotone.seat,
      'Premium Economy': PhosphorIconsDuotone.armchair,
      'Business': PhosphorIconsDuotone.briefcase,
      'First Class': PhosphorIconsDuotone.crownSimple,
    };

    _showSheet(
      context,
      title: 'Travel class',
      subtitle: 'Cabin preference for every traveller',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: options.entries.map((e) {
          final selected = provider.travelClass == e.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Pressable(
              onTap: () {
                provider.setTravelClass(e.key);
                Navigator.pop(context);
              },
              child: AnimatedContainer(
                duration: AppMotion.fast,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
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
                      size: 22,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        e.key,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: selected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          color: selected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (selected)
                      Icon(
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
    required Widget child,
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
                const Center(child: _SheetHandle()),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  title,
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
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.borderStrong,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// ───────────────────────── Segmented control ─────────────────────────

/// Two-up segmented control with a white indicator that slides between
/// the segments rather than popping from one to the other.
class _TripTypeSwitch extends StatelessWidget {
  final bool isRound;
  final ValueChanged<FlightSearchTripType> onChanged;

  const _TripTypeSwitch({required this.isRound, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const pad = 4.0;
    return Container(
      padding: const EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segment = constraints.maxWidth / 2;
          return SizedBox(
            height: 38,
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: AppMotion.base,
                  curve: AppMotion.emphasized,
                  left: isRound ? segment : 0,
                  top: 0,
                  bottom: 0,
                  width: segment,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      boxShadow: AppShadows.soft,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: _segment(
                        'One-way',
                        PhosphorIconsBold.arrowRight,
                        !isRound,
                        () => onChanged(FlightSearchTripType.oneWay),
                      ),
                    ),
                    Expanded(
                      child: _segment(
                        'Round-trip',
                        PhosphorIconsBold.arrowsLeftRight,
                        isRound,
                        () => onChanged(FlightSearchTripType.roundTrip),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _segment(
    String label,
    IconData icon,
    bool selected,
    VoidCallback onTap,
  ) {
    final color = selected
        ? AppColors.primaryDark
        : Colors.white.withValues(alpha: 0.82);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 6),
            Flexible(
              child: AnimatedDefaultTextStyle(
                duration: AppMotion.fast,
                style: TextStyle(
                  color: color,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 13,
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Rows & tiles ─────────────────────────

class _AirportRow extends StatelessWidget {
  final String label;
  final String code;
  final String city;
  final IconData icon;
  final VoidCallback onTap;

  const _AirportRow({
    required this.label,
    required this.code,
    required this.city,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.99,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 13, 66, 13),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primarySubtle,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textMuted,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          city,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primarySubtle,
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: Text(
                          code,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ],
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

class _DetailTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final bool muted;

  const _DetailTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.secondaryLight, size: 16),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.9,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: muted
                          ? Colors.white.withValues(alpha: 0.65)
                          : Colors.white,
                      fontFeatures: AppText.tabular,
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
