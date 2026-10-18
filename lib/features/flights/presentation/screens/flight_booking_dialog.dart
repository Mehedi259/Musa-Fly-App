import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
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
        address: _addressController.text.trim().isEmpty ? 'Online App Request' : _addressController.text.trim(),
        passportNumber: _passportController.text.trim().isEmpty ? 'N/A' : _passportController.text.trim(),
        email: _emailController.text.trim(),
        serviceCategory: 'Flight Ticket',
        routeDestination: '${widget.flight.origin} to ${widget.flight.destination}',
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

      // Show Success Dialog
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking error: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 48),
            ),
            const SizedBox(height: 16),
            const Text(
              'Booking Request Sent!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Our travel specialist will contact you shortly to confirm your seats and tickets.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Chat on WhatsApp',
              icon: Icons.chat_bubble_outline_rounded,
              backgroundColor: AppColors.whatsapp,
              onPressed: () {
                Navigator.pop(ctx);
                final msg =
                    "Hi MusaFly! I submitted a booking request for ${widget.flight.airline} (${widget.flight.origin} → ${widget.flight.destination}) on ${DateFormatter.formatFlightDate(widget.flight.departureTime)}. Name: ${_nameController.text.trim()}";
                UrlHelper.launchWhatsApp(customMessage: msg);
              },
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
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
                const Text(
                  'Book Flight Ticket',
                  style: TextStyle(
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
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Flight Summary Banner
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.primarySubtle,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.primaryLight.withAlpha(60)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.flight_takeoff_rounded, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.flight.airline} • ${widget.flight.originCode} → ${widget.flight.destinationCode}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                Text(
                                  '${DateFormatter.formatFlightDate(widget.flight.departureTime)} | ${CurrencyFormatter.formatSmart(widget.flight.price)}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Passenger Information',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Full Name *',
                      hint: 'Enter traveler name as in passport',
                      controller: _nameController,
                      prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Please enter name' : null,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'Phone Number *',
                      hint: '+968 or +880 number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primary),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Please enter phone number' : null,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'Passport Number',
                      hint: 'e.g. A01234567',
                      controller: _passportController,
                      prefixIcon: const Icon(Icons.credit_card_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'Email Address',
                      hint: 'name@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.mail_outline_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'Address / Special Requests',
                      hint: 'e.g. Muscat, Oman / Meal preference',
                      controller: _addressController,
                      maxLines: 2,
                      prefixIcon: const Icon(Icons.notes_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Confirm & Submit Booking',
                      isLoading: _isSubmitting,
                      onPressed: _submitBooking,
                      width: double.infinity,
                      height: 52,
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          final msg =
                              "Hi MusaFly! I'd like to book flight ${widget.flight.airline} from ${widget.flight.origin} to ${widget.flight.destination} on ${DateFormatter.formatFlightDate(widget.flight.departureTime)}.";
                          UrlHelper.launchWhatsApp(customMessage: msg);
                        },
                        icon: const Icon(Icons.chat_rounded, color: AppColors.whatsapp, size: 18),
                        label: const Text(
                          'Direct WhatsApp Booking',
                          style: TextStyle(color: AppColors.whatsapp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
