import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../deals/data/models/deal_model.dart';
import '../../../deals/data/repositories/deal_repository.dart';
import '../../data/models/visa_model.dart';

class VisaDetailScreen extends StatefulWidget {
  final VisaModel visa;

  const VisaDetailScreen({super.key, required this.visa});

  @override
  State<VisaDetailScreen> createState() => _VisaDetailScreenState();
}

class _VisaDetailScreenState extends State<VisaDetailScreen> {
  void _openApplicationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _VisaApplicationSheet(visa: widget.visa),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.visa.country} Visa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              UrlHelper.launchWhatsApp(
                customMessage:
                    "Need assistance for ${widget.visa.country} ${widget.visa.visaType} visa processing with MusaFly.",
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country Hero Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF204D90), Color(0xFF132E56)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(40),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.visa.visaType.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.schedule_rounded, color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              widget.visa.formattedProcessingTime,
                              style: const TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${widget.visa.country} Visa Assistance',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fast and reliable visa processing support with 99% document approval rate.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withAlpha(200),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Visa Fee:',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      Text(
                        CurrencyFormatter.formatSmart(widget.visa.price),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Requirements Checklist
            const Text(
              'Required Documents Checklist',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: widget.visa.requirementList
                    .map(
                      (req) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.success,
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                req,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 24),

            // 4-Step Process Guide
            const Text(
              'How It Works',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildStep('1', 'Apply Online', 'Fill out our quick form or message on WhatsApp.'),
                  const Divider(height: 20),
                  _buildStep('2', 'Document Review', 'Our visa consultant checks and prepares your dossier.'),
                  const Divider(height: 20),
                  _buildStep('3', 'Embassy Submission', 'We submit directly to the embassy or portal.'),
                  const Divider(height: 20),
                  _buildStep('4', 'Receive Visa', 'Your approved visa delivered to your email / phone.'),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'WhatsApp Help',
                icon: Icons.chat_bubble_rounded,
                backgroundColor: AppColors.whatsapp,
                onPressed: () {
                  final msg =
                      "Hello MusaFly! I am applying for the ${widget.visa.country} ${widget.visa.visaType} visa. Could you assist me with document requirements?";
                  UrlHelper.launchWhatsApp(customMessage: msg);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                text: 'Apply Now',
                type: ButtonType.primary,
                onPressed: _openApplicationSheet,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: AppColors.primarySubtle,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VisaApplicationSheet extends StatefulWidget {
  final VisaModel visa;
  const _VisaApplicationSheet({required this.visa});

  @override
  State<_VisaApplicationSheet> createState() => _VisaApplicationSheetState();
}

class _VisaApplicationSheetState extends State<_VisaApplicationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passportController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passportController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final deal = DealModel(
        customerName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty ? 'Visa Application' : _addressController.text.trim(),
        passportNumber: _passportController.text.trim().isEmpty ? 'N/A' : _passportController.text.trim(),
        email: _emailController.text.trim(),
        serviceCategory: 'Visa Service',
        routeDestination: '${widget.visa.country} (${widget.visa.visaType})',
        travelDate: DateTime.now().add(const Duration(days: 15)),
        leadSource: 'Mobile App',
        dealPrice: widget.visa.price,
        currency: 'USD',
      );

      await DealRepository().createDeal(deal);
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 54),
              const SizedBox(height: 16),
              const Text('Visa Request Submitted!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Our visa expert will contact you to collect the required papers for ${widget.visa.country}.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Connect on WhatsApp',
                backgroundColor: AppColors.whatsapp,
                onPressed: () {
                  Navigator.pop(ctx);
                  UrlHelper.launchWhatsApp(
                    customMessage:
                        "Hi MusaFly! I just submitted an application for ${widget.visa.country} visa. Name: ${_nameController.text.trim()}.",
                  );
                },
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Apply for ${widget.visa.country} Visa',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Applicant Full Name *',
                controller: _nameController,
                hint: 'Name as on passport',
                prefixIcon: const Icon(Icons.person_outline),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Phone Number (with WhatsApp) *',
                controller: _phoneController,
                hint: '+968 or +880 number',
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Passport Number',
                controller: _passportController,
                hint: 'e.g. A01234567',
                prefixIcon: const Icon(Icons.credit_card_outlined),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Email Address',
                controller: _emailController,
                hint: 'applicant@domain.com',
                prefixIcon: const Icon(Icons.mail_outline),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Current Residence City / Country',
                controller: _addressController,
                hint: 'e.g. Muscat, Oman / Dhaka, Bangladesh',
                prefixIcon: const Icon(Icons.location_on_outlined),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Submit Visa Application',
                isLoading: _isSubmitting,
                onPressed: _submit,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
