import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class AirportItem {
  final String code;
  final String city;
  final String name;

  const AirportItem({required this.code, required this.city, required this.name});
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
    AirportItem(code: 'DAC', city: 'Dhaka', name: 'Hazrat Shahjalal International Airport'),
    AirportItem(code: 'DXB', city: 'Dubai', name: 'Dubai International Airport'),
    AirportItem(code: 'MCT', city: 'Muscat', name: 'Muscat International Airport'),
    AirportItem(code: 'JED', city: 'Jeddah', name: 'King Abdulaziz International Airport'),
    AirportItem(code: 'CXB', city: "Cox's Bazar", name: "Cox's Bazar Airport"),
    AirportItem(code: 'CGP', city: 'Chittagong', name: 'Shah Amanat International Airport'),
    AirportItem(code: 'ZYL', city: 'Sylhet', name: 'Osmani International Airport'),
    AirportItem(code: 'SIN', city: 'Singapore', name: 'Changi Airport'),
    AirportItem(code: 'KUL', city: 'Kuala Lumpur', name: 'Kuala Lumpur International Airport'),
    AirportItem(code: 'BKK', city: 'Bangkok', name: 'Suvarnabhumi Airport'),
    AirportItem(code: 'DOH', city: 'Doha', name: 'Hamad International Airport'),
    AirportItem(code: 'LHR', city: 'London', name: 'Heathrow Airport'),
    AirportItem(code: 'IST', city: 'Istanbul', name: 'Istanbul Airport'),
    AirportItem(code: 'DEL', city: 'Delhi', name: 'Indira Gandhi International Airport'),
    AirportItem(code: 'MLE', city: 'Malé', name: 'Velana International Airport'),
  ];

  static void show(BuildContext context, {required String title, required Function(String, String) onSelect}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AirportSelectorSheet(title: title, onSelect: onSelect),
    );
  }

  @override
  State<AirportSelectorSheet> createState() => _AirportSelectorSheetState();
}

class _AirportSelectorSheetState extends State<AirportSelectorSheet> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = AirportSelectorSheet.airports.where((item) {
      final q = _searchQuery.toLowerCase();
      return item.code.toLowerCase().contains(q) ||
          item.city.toLowerCase().contains(q) ||
          item.name.toLowerCase().contains(q);
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search city, airport name, or code...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                fillColor: const Color(0xFFF8FAFC),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: filtered.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final airport = filtered[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  onTap: () {
                    widget.onSelect(airport.code, airport.city);
                    Navigator.pop(context);
                  },
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primarySubtle,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        airport.code,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    airport.city,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    airport.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
