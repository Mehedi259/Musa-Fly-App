import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/flight_provider.dart';
import 'airport_selector_sheet.dart';

class FlightSearchCard extends StatelessWidget {
  final FlightProvider provider;
  final VoidCallback onSearch;

  const FlightSearchCard({
    super.key,
    required this.provider,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF204D90), Color(0xFF132E56)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(60),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trip Type Toggle (One-way / Round-trip)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _TripTypeTab(
                    title: 'One-way',
                    isSelected: provider.tripType == FlightSearchTripType.oneWay,
                    onTap: () => provider.setTripType(FlightSearchTripType.oneWay),
                  ),
                ),
                Expanded(
                  child: _TripTypeTab(
                    title: 'Round-trip',
                    isSelected: provider.tripType == FlightSearchTripType.roundTrip,
                    onTap: () => provider.setTripType(FlightSearchTripType.roundTrip),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Airport Selector: From & To with Swap Button
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Column(
                children: [
                  _AirportBox(
                    label: 'FROM',
                    code: provider.originCode,
                    city: provider.originCity,
                    icon: Icons.flight_takeoff_rounded,
                    onTap: () {
                      AirportSelectorSheet.show(
                        context,
                        title: 'Select Departure City',
                        onSelect: (code, city) => provider.setOrigin(code, city),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _AirportBox(
                    label: 'TO',
                    code: provider.destCode,
                    city: provider.destCity,
                    icon: Icons.flight_land_rounded,
                    onTap: () {
                      AirportSelectorSheet.show(
                        context,
                        title: 'Select Destination City',
                        onSelect: (code, city) => provider.setDestination(code, city),
                      );
                    },
                  ),
                ],
              ),
              Positioned(
                right: 24,
                child: GestureDetector(
                  onTap: () => provider.swapAirports(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(40),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.swap_vert_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Dates Row
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'DEPARTURE',
                  value: DateFormat('dd MMM, yyyy').format(provider.departureDate),
                  icon: Icons.calendar_today_rounded,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: provider.departureDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      provider.setDepartureDate(picked);
                    }
                  },
                ),
              ),
              if (provider.tripType == FlightSearchTripType.roundTrip) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: _InfoTile(
                    label: 'RETURN',
                    value: provider.returnDate != null
                        ? DateFormat('dd MMM, yyyy').format(provider.returnDate!)
                        : 'Select Date',
                    icon: Icons.event_repeat_rounded,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: provider.returnDate ??
                            provider.departureDate.add(const Duration(days: 7)),
                        firstDate: provider.departureDate,
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        provider.setReturnDate(picked);
                      }
                    },
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 12),

          // Passengers & Class
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'PASSENGERS',
                  value: '${provider.passengers} Traveler${provider.passengers > 1 ? 's' : ''}',
                  icon: Icons.people_outline_rounded,
                  onTap: () => _showPassengerPicker(context),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _InfoTile(
                  label: 'CLASS',
                  value: provider.travelClass,
                  icon: Icons.airline_seat_recline_extra_rounded,
                  onTap: () => _showClassPicker(context),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Search Flights Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
                shadowColor: AppColors.secondary.withAlpha(120),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_rounded, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Search Flights',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPassengerPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Passengers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              children: List.generate(6, (index) {
                final count = index + 1;
                final isSelected = provider.passengers == count;
                return ChoiceChip(
                  label: Text('$count Adult${count > 1 ? 's' : ''}'),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  onSelected: (_) {
                    provider.setPassengers(count);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showClassPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Travel Class',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...['Economy', 'Premium Economy', 'Business', 'First Class'].map(
              (cls) => ListTile(
                title: Text(cls, style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: provider.travelClass == cls
                    ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                    : null,
                onTap: () {
                  provider.setTravelClass(cls);
                  Navigator.pop(ctx);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripTypeTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TripTypeTab({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _AirportBox extends StatelessWidget {
  final String label;
  final String code;
  final String city;
  final IconData icon;
  final VoidCallback onTap;

  const _AirportBox({
    required this.label,
    required this.code,
    required this.city,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withAlpha(35)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.secondary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withAlpha(180),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$city ($code)',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down_rounded, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withAlpha(35)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.secondary, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withAlpha(180),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
