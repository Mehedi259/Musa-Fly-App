import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/deal_model.dart';
import '../../data/repositories/deal_repository.dart';

class CreateBookingInquiryScreen extends StatefulWidget {
  const CreateBookingInquiryScreen({super.key});

  @override
  State<CreateBookingInquiryScreen> createState() => _CreateBookingInquiryScreenState();
}

class _CreateBookingInquiryScreenState extends State<CreateBookingInquiryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passportController = TextEditingController();
  final _destinationController = TextEditingController();
  final _airlineController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedCategory = 'Flight Ticket';
  DateTime _travelDate = DateTime.now().add(const Duration(days: 7));
  bool _isSubmitting = false;

  final List<String> _categories = [
    'Flight Ticket',
    'Holiday Tour',
    'Umrah Package',
    'Visa Service',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passportController.dispose();
    _destinationController.dispose();
    _airlineController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final price = double.tryParse(_priceController.text.trim()) ?? 350.0;
      final deal = DealModel(
        customerName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty ? 'Direct App Inquiry' : _addressController.text.trim(),
        passportNumber: _passportController.text.trim().isEmpty ? 'N/A' : _passportController.text.trim(),
        email: _emailController.text.trim(),
        serviceCategory: _selectedCategory,
        routeDestination: _destinationController.text.trim(),
        travelDate: _travelDate,
        airlineName: _airlineController.text.trim(),
        leadSource: 'Mobile App Form',
        dealPrice: price,
        currency: 'USD',
      );

      await DealRepository().createDeal(deal);
      if (!mounted) return;
      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inquiry successfully created & synced with backend!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit: $e'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Travel Inquiry'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Service Category',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Customer Full Name *',
                controller: _nameController,
                hint: 'e.g. John Doe',
                prefixIcon: const Icon(Icons.person_outline),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                label: 'Phone / WhatsApp Number *',
                controller: _phoneController,
                hint: '+968 95923226',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter phone' : null,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                label: 'Route / Destination *',
                controller: _destinationController,
                hint: 'e.g. Dhaka to Dubai / Malaysia Tour',
                prefixIcon: const Icon(Icons.location_on_outlined),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please specify destination' : null,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                label: 'Passport Number',
                controller: _passportController,
                hint: 'Passport number (optional)',
                prefixIcon: const Icon(Icons.credit_card_outlined),
              ),
              const SizedBox(height: 14),
              CustomTextField(
                label: 'Preferred Airline / Specific Hotel',
                controller: _airlineController,
                hint: 'e.g. Emirates, Qatar Airways',
                prefixIcon: const Icon(Icons.flight_outlined),
              ),
              const SizedBox(height: 14),
              CustomTextField(
                label: 'Estimated Budget / Price (USD)',
                controller: _priceController,
                hint: 'e.g. 450.00',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.attach_money_rounded),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _travelDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() => _travelDate = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primary),
                          const SizedBox(width: 10),
                          Text(
                            'Travel Date: ${DateFormat('dd MMM, yyyy').format(_travelDate)}',
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_drop_down, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              CustomButton(
                text: 'Create Booking & Sync with Server',
                isLoading: _isSubmitting,
                onPressed: _submit,
                width: double.infinity,
                height: 52,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
