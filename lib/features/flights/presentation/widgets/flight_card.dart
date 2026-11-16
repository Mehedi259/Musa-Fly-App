import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../../data/models/flight_model.dart';

/// A flight rendered as a real ticket: airline chip on the stub, a duration
/// rail between the two endpoints, a perforated tear line with notched
/// edges, and the fare row below it.
class FlightCard extends StatelessWidget {
  final FlightModel flight;
  final VoidCallback? onBook;

  /// Colour behind the card — the notches are punched in this colour so the
  /// page shows through the cut-outs.
  final Color backdrop;

  const FlightCard({
    super.key,
    required this.flight,
    this.onBook,
    this.backdrop = AppColors.background,
  });

  String get _initials {
    final parts = flight.airline.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) {
      final p = parts.first;
      return p.substring(0, p.length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final duration = DateFormatter.calculateDuration(
      flight.departureTime,
      flight.arrivalTime,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Pressable(
        onTap: onBook,
        scale: 0.985,
        child: Container(
          decoration: AppDecor.card(radius: AppRadius.lg),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _header(context),
              _route(duration),
              _tearLine(),
              _fareRow(context),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────────────── Stub header ─────────────────────────

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primarySubtle,
                  AppColors.primaryLight.withValues(alpha: 0.18),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppRadius.xs),
              border: Border.all(
                color: AppColors.primaryLight.withValues(alpha: 0.28),
              ),
            ),
            child: Text(
              _initials,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  flight.airline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 1),
                Row(
                  children: [
                    Icon(
                      PhosphorIconsRegular.calendarBlank,
                      size: 11,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        DateFormatter.formatFlightDate(flight.departureTime),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ToneChip(
            label: context.pick('Available', 'উপলব্ধ'),
            icon: PhosphorIconsFill.sealCheck,
            tone: ChipTone.success,
            dense: true,
          ),
        ],
      ),
    );
  }

  // ───────────────────────── Route block ─────────────────────────

  Widget _route(String duration) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 2, 14, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 32,
            child: _Endpoint(
              code: flight.originCode,
              time: DateFormatter.formatFlightTime(flight.departureTime),
              city: flight.originCity,
              alignEnd: false,
            ),
          ),
          Expanded(flex: 36, child: _DurationRail(duration: duration)),
          Expanded(
            flex: 32,
            child: _Endpoint(
              code: flight.destinationCode,
              time: DateFormatter.formatFlightTime(flight.arrivalTime),
              city: flight.destinationCity,
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────── Perforation ─────────────────────────

  Widget _tearLine() {
    return SizedBox(
      height: 18,
      child: Row(
        children: [
          TicketNotch(left: true, color: backdrop),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: DashedDivider(),
            ),
          ),
          TicketNotch(left: false, color: backdrop),
        ],
      ),
    );
  }

  // ───────────────────────── Fare row ─────────────────────────

  Widget _fareRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  CurrencyFormatter.formatSmart(flight.price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                    letterSpacing: -0.6,
                    height: 1.1,
                    fontFeatures: AppText.tabular,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  context.isBangla
                      ? '≈ ${CurrencyFormatter.convertOmrToBdt(flight.price, banglaDigits: true)} · প্রতি যাত্রী'
                      : 'per traveler',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontFeatures: AppText.tabular,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Pressable(
            onTap: onBook,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                gradient: AppColors.goldCta,
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: AppShadows.glow(AppColors.secondary, opacity: 0.3),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.pick('Book Now', 'বুক করুন'),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13.5,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    PhosphorIconsBold.arrowRight,
                    size: 14,
                    color: AppColors.primaryDark,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Departure / arrival block. The time always stays on one line: the
/// meridiem is a smaller span inside the same rich text, and the whole
/// line scales down rather than wrapping if space runs short.
class _Endpoint extends StatelessWidget {
  final String code;
  final String time;
  final String city;
  final bool alignEnd;

  const _Endpoint({
    required this.code,
    required this.time,
    required this.city,
    required this.alignEnd,
  });

  @override
  Widget build(BuildContext context) {
    final parts = time.trim().split(' ');
    final clock = parts.isNotEmpty ? parts.first : time;
    final meridiem = parts.length > 1 ? parts.last : null;

    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: alignEnd
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: clock,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                      height: 1.1,
                      fontFeatures: AppText.tabular,
                    ),
                  ),
                  if (meridiem != null)
                    TextSpan(
                      text: ' $meridiem',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.2,
                      ),
                    ),
                ],
              ),
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.visible,
              textAlign: alignEnd ? TextAlign.end : TextAlign.start,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          code,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: 0.8,
          ),
        ),
        Text(
          city,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

/// Duration above a rail of: origin dot — line — plane glyph — line —
/// destination dot, with the stop count underneath.
class _DurationRail extends StatelessWidget {
  final String duration;

  const _DurationRail({required this.duration});

  @override
  Widget build(BuildContext context) {
    final line = AppColors.primaryLight.withValues(alpha: 0.35);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                PhosphorIconsRegular.clock,
                size: 11,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  duration.isNotEmpty ? duration : '—',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                    fontFeatures: AppText.tabular,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              _dot(filled: false),
              Expanded(child: Container(height: 1.5, color: line)),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: AppColors.goldCta,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.glow(
                    AppColors.secondary,
                    opacity: 0.25,
                  ),
                ),
                child: Icon(
                  PhosphorIconsFill.airplaneTilt,
                  size: 11,
                  color: AppColors.primaryDark,
                ),
              ),
              Expanded(child: Container(height: 1.5, color: line)),
              _dot(filled: true),
            ],
          ),
          const SizedBox(height: 7),
          const Text(
            'Non-stop',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot({required bool filled}) => Container(
    width: 7,
    height: 7,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: filled ? AppColors.primary : Colors.white,
      border: Border.all(color: AppColors.primary, width: 1.6),
    ),
  );
}
