import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/widgets/motion.dart';

class AirportItem {
  final String code;
  final String city;
  final String name;

  /// Grouping bucket shown as a sticky-ish section label.
  final String region;

  const AirportItem({
    required this.code,
    required this.city,
    required this.name,
    this.region = 'International',
  });
}

class AirportSelectorSheet extends StatefulWidget {
  final String title;
  final Function(String code, String city) onSelect;

  const AirportSelectorSheet({
    super.key,
    required this.title,
    required this.onSelect,
  });

  static const List<AirportItem> airports = [
    AirportItem(
      code: 'DAC',
      city: 'Dhaka',
      name: 'Hazrat Shahjalal International Airport',
      region: 'Bangladesh',
    ),
    AirportItem(
      code: 'CGP',
      city: 'Chittagong',
      name: 'Shah Amanat International Airport',
      region: 'Bangladesh',
    ),
    AirportItem(
      code: 'ZYL',
      city: 'Sylhet',
      name: 'Osmani International Airport',
      region: 'Bangladesh',
    ),
    AirportItem(
      code: 'CXB',
      city: "Cox's Bazar",
      name: "Cox's Bazar Airport",
      region: 'Bangladesh',
    ),
    AirportItem(
      code: 'DXB',
      city: 'Dubai',
      name: 'Dubai International Airport',
      region: 'Middle East',
    ),
    AirportItem(
      code: 'MCT',
      city: 'Muscat',
      name: 'Muscat International Airport',
      region: 'Middle East',
    ),
    AirportItem(
      code: 'JED',
      city: 'Jeddah',
      name: 'King Abdulaziz International Airport',
      region: 'Middle East',
    ),
    AirportItem(
      code: 'DOH',
      city: 'Doha',
      name: 'Hamad International Airport',
      region: 'Middle East',
    ),
    AirportItem(
      code: 'SIN',
      city: 'Singapore',
      name: 'Changi Airport',
      region: 'Asia',
    ),
    AirportItem(
      code: 'KUL',
      city: 'Kuala Lumpur',
      name: 'Kuala Lumpur International Airport',
      region: 'Asia',
    ),
    AirportItem(
      code: 'BKK',
      city: 'Bangkok',
      name: 'Suvarnabhumi Airport',
      region: 'Asia',
    ),
    AirportItem(
      code: 'DEL',
      city: 'Delhi',
      name: 'Indira Gandhi International Airport',
      region: 'Asia',
    ),
    AirportItem(
      code: 'MLE',
      city: 'Malé',
      name: 'Velana International Airport',
      region: 'Asia',
    ),
    AirportItem(
      code: 'IST',
      city: 'Istanbul',
      name: 'Istanbul Airport',
      region: 'Europe',
    ),
    AirportItem(
      code: 'LHR',
      city: 'London',
      name: 'Heathrow Airport',
      region: 'Europe',
    ),
  ];

  static void show(
    BuildContext context, {
    required String title,
    required Function(String, String) onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          AirportSelectorSheet(title: title, onSelect: onSelect),
    );
  }

  @override
  State<AirportSelectorSheet> createState() => _AirportSelectorSheetState();
}

class _AirportSelectorSheetState extends State<AirportSelectorSheet> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<AirportItem> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return AirportSelectorSheet.airports;
    return AirportSelectorSheet.airports.where((item) {
      return item.code.toLowerCase().contains(q) ||
          item.city.toLowerCase().contains(q) ||
          item.name.toLowerCase().contains(q);
    }).toList();
  }

  /// Flattens the filtered airports into header + row entries so one
  /// ListView can render the grouped layout.
  List<Object> get _entries {
    final out = <Object>[];
    String? current;
    for (final a in _filtered) {
      if (a.region != current) {
        current = a.region;
        out.add(current);
      }
      out.add(a);
    }
    return out;
  }

  void _pick(AirportItem airport) {
    widget.onSelect(airport.code, airport.city);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final entries = _entries;

    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Container(
        height: media.size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        clipBehavior: Clip.antiAlias,
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
              padding: const EdgeInsets.fromLTRB(AppSpacing.page, 14, 12, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Search by city, airport or IATA code',
                          style: TextStyle(
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
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.md,
                AppSpacing.page,
                AppSpacing.sm,
              ),
              child: TextField(
                controller: _controller,
                onChanged: (val) => setState(() => _query = val),
                textInputAction: TextInputAction.search,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Dhaka, DAC, Heathrow…',
                  hintStyle: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: Icon(
                    PhosphorIconsRegular.magnifyingGlass,
                    size: 19,
                    color: AppColors.primary,
                  ),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: Icon(
                            PhosphorIconsFill.xCircle,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                          onPressed: () {
                            _controller.clear();
                            setState(() => _query = '');
                          },
                        ),
                  fillColor: AppColors.background,
                  filled: true,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.4,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: entries.isEmpty
                  ? _emptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.page,
                        AppSpacing.xs,
                        AppSpacing.page,
                        AppSpacing.xxl,
                      ),
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        if (entry is String) {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: index == 0 ? 6 : AppSpacing.lg,
                              bottom: AppSpacing.sm,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 3,
                                  height: 13,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.goldGradient,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  entry.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.1,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        final airport = entry as AirportItem;
                        return _AirportRow(
                          airport: airport,
                          onTap: () => _pick(airport),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.primarySubtle,
                shape: BoxShape.circle,
              ),
              child: Icon(
                PhosphorIconsDuotone.globeHemisphereWest,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'No airports match that',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Try a city name like Dubai, or a three letter code like DXB.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AirportRow extends StatelessWidget {
  final AirportItem airport;
  final VoidCallback onTap;

  const _AirportRow({required this.airport, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.98,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primarySubtle,
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              child: Text(
                airport.code,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    airport.city,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    airport.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              PhosphorIconsBold.caretRight,
              size: 13,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
