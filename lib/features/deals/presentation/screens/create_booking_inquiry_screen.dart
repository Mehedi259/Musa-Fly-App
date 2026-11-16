import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../../data/models/deal_model.dart';
import '../../data/repositories/deal_repository.dart';

/// Inquiry form: three grouped cards (category → traveller → trip) over a
/// sticky submit bar that lifts with the keyboard.
class CreateBookingInquiryScreen extends StatefulWidget {
  const CreateBookingInquiryScreen({super.key});

  @override
  State<CreateBookingInquiryScreen> createState() => _CreateBookingInquiryScreenState();
}

class _InquiryCategory {
  final String label;
  final IconData icon;
  final Color color;
  const _InquiryCategory(this.label, this.icon, this.color);
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

  static const List<_InquiryCategory> _categories = [
    _InquiryCategory('Flight Ticket', PhosphorIconsFill.airplaneTakeoff, AppColors.catFlight),
    _InquiryCategory('Holiday Tour', PhosphorIconsFill.umbrella, AppColors.catTour),
    _InquiryCategory('Umrah Package', PhosphorIconsFill.mosque, AppColors.catUmrah),
    _InquiryCategory('Visa Service', PhosphorIconsFill.identificationCard, AppColors.catVisa),
  ];

  _InquiryCategory get _activeCategory =>
      _categories.firstWhere((c) => c.label == _selectedCategory, orElse: () => _categories.first);

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
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final price = double.tryParse(_priceController.text.trim()) ?? 350.0;
      final deal = DealModel(
        customerName: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? 'Direct App Inquiry'
            : _addressController.text.trim(),
        passportNumber:
            _passportController.text.trim().isEmpty ? 'N/A' : _passportController.text.trim(),
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
        _snack(
          'Inquiry sent — our team will contact you shortly.',
          AppColors.success,
          PhosphorIconsFill.checkCircle,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        _snack('Failed to submit: $e', AppColors.error, PhosphorIconsFill.warningCircle),
      );
    }
  }

  SnackBar _snack(String message, Color color, IconData icon) {
    return SnackBar(
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
    );
  }

  Future<void> _pickDate() async {
    FocusScope.of(context).unfocus();
    final picked = await showDatePicker(
      context: context,
      initialDate: _travelDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) setState(() => _travelDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      appBar: const PremiumAppBar(
        title: 'New travel inquiry',
        subtitle: 'Takes less than a minute',
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.lg,
            AppSpacing.page,
            AppSpacing.xxl,
          ),
          children: [
            FadeSlideIn(
              index: 0,
              child: _FormGroup(
                step: '1',
                title: 'What can we arrange?',
                subtitle: 'Pick the service you need a quote for',
                accent: _activeCategory.color,
                children: [
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: _categories
                        .map(
                          (c) => _CategoryPill(
                            category: c,
                            selected: _selectedCategory == c.label,
                            onTap: () => setState(() => _selectedCategory = c.label),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FadeSlideIn(
              index: 1,
              child: _FormGroup(
                step: '2',
                title: 'Traveller details',
                subtitle: 'How our team reaches you',
                accent: AppColors.primary,
                children: [
                  PremiumField(
                    label: 'Full name',
                    controller: _nameController,
                    icon: PhosphorIconsRegular.user,
                    hint: 'e.g. John Doe',
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Please enter the traveller name' : null,
                  ),
                  PremiumField(
                    label: 'Phone / WhatsApp',
                    controller: _phoneController,
                    icon: PhosphorIconsRegular.phone,
                    hint: '+968 95923226',
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Please enter a phone number';
                      if (v.trim().replaceAll(RegExp(r'[^0-9]'), '').length < 7) {
                        return 'That number looks too short';
                      }
                      return null;
                    },
                  ),
                  PremiumField(
                    label: 'Email',
                    controller: _emailController,
                    icon: PhosphorIconsRegular.envelopeSimple,
                    hint: 'Optional — for your quote PDF',
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return null;
                      final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
                      return ok ? null : 'Enter a valid email address';
                    },
                  ),
                  PremiumField(
                    label: 'Passport number',
                    controller: _passportController,
                    icon: PhosphorIconsRegular.identificationCard,
                    hint: 'Optional',
                    textCapitalization: TextCapitalization.characters,
                  ),
                  PremiumField(
                    label: 'City / address',
                    controller: _addressController,
                    icon: PhosphorIconsRegular.buildings,
                    hint: 'Optional',
                    textCapitalization: TextCapitalization.words,
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FadeSlideIn(
              index: 2,
              child: _FormGroup(
                step: '3',
                title: 'Trip details',
                subtitle: 'The more you tell us, the sharper the quote',
                accent: AppColors.secondaryDark,
                children: [
                  PremiumField(
                    label: 'Route / destination',
                    controller: _destinationController,
                    icon: PhosphorIconsRegular.mapPin,
                    hint: 'e.g. Muscat to Dhaka',
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Please tell us where you are going' : null,
                  ),
                  PremiumField(
                    label: 'Preferred airline or hotel',
                    controller: _airlineController,
                    icon: PhosphorIconsRegular.airplaneTilt,
                    hint: 'e.g. Emirates, Qatar Airways',
                    textCapitalization: TextCapitalization.words,
                  ),
                  PremiumField(
                    label: 'Estimated budget (USD)',
                    controller: _priceController,
                    icon: PhosphorIconsRegular.currencyDollar,
                    hint: 'e.g. 450',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textInputAction: TextInputAction.done,
                    validator: (v) {
                      final value = v?.trim() ?? '';
                      if (value.isEmpty) return null;
                      final parsed = double.tryParse(value);
                      if (parsed == null) return 'Enter a number, e.g. 450';
                      if (parsed <= 0) return 'Budget must be greater than zero';
                      return null;
                    },
                  ),
                  _DateTile(date: _travelDate, onTap: _pickDate, isLast: true),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(PhosphorIconsRegular.shieldCheck, size: 15, color: AppColors.textMuted),
                const SizedBox(width: 7),
                const Expanded(
                  child: Text(
                    'Your details stay with the MusaFly booking desk and are never shared.',
                    style: TextStyle(fontSize: 11.5, color: AppColors.textMuted, height: 1.4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedPadding(
        duration: AppMotion.fast,
        curve: AppMotion.ease,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: StickyActionBar(
          priceLabel: 'Service',
          priceValue: _activeCategory.label.split(' ').first,
          priceNote: DateFormat('dd MMM, yyyy').format(_travelDate),
          action: PremiumButton(
            label: _isSubmitting ? 'Sending…' : 'Send inquiry',
            icon: PhosphorIconsBold.paperPlaneTilt,
            trailingIcon: true,
            loading: _isSubmitting,
            onPressed: _isSubmitting ? null : _submit,
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Group card ─────────────────────────

class _FormGroup extends StatelessWidget {
  final String step;
  final String title;
  final String subtitle;
  final Color accent;
  final List<Widget> children;

  const _FormGroup({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: AppMotion.base,
                curve: AppMotion.ease,
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Text(
                  step,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ...children,
        ],
      ),
    );
  }
}

// ───────────────────────── Category pill ─────────────────────────

class _CategoryPill extends StatelessWidget {
  final _InquiryCategory category;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryPill({required this.category, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.95,
      child: AnimatedContainer(
        duration: AppMotion.base,
        curve: AppMotion.emphasized,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? category.color : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: selected ? category.color : AppColors.border,
            width: selected ? 1.4 : 1,
          ),
          boxShadow: selected ? AppShadows.glow(category.color, opacity: 0.26) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 15,
              color: selected ? Colors.white : category.color,
            ),
            const SizedBox(width: 7),
            Text(
              category.label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Field ─────────────────────────

/// Floating-label text field with an animated focus ring and inline errors.
class PremiumField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? hint;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final bool isLast;

  const PremiumField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.hint,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.isLast = false,
  });

  @override
  State<PremiumField> createState() => _PremiumFieldState();
}

class _PremiumFieldState extends State<PremiumField> {
  final FocusNode _focus = FocusNode();
  bool _focused = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (mounted) setState(() => _focused = _focus.hasFocus);
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color color, [double width = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    final required = widget.validator != null;
    final accent = _hasError
        ? AppColors.error
        : _focused
            ? AppColors.primary
            : AppColors.textMuted;

    return Padding(
      padding: EdgeInsets.only(bottom: widget.isLast ? 0 : AppSpacing.md + 2),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focus,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        validator: (value) {
          final result = widget.validator?.call(value);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _hasError != (result != null)) {
              setState(() => _hasError = result != null);
            }
          });
          return result;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: required ? '${widget.label} *' : widget.label,
          hintText: _focused ? widget.hint : null,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
          floatingLabelStyle: TextStyle(
            color: accent,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 14, right: 10),
            child: Icon(widget.icon, size: 19, color: accent),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          filled: true,
          fillColor: _focused ? AppColors.primarySubtle.withValues(alpha: 0.5) : Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
          border: _border(AppColors.border),
          enabledBorder: _border(AppColors.border),
          focusedBorder: _border(AppColors.primary, 1.6),
          errorBorder: _border(AppColors.error, 1.2),
          focusedErrorBorder: _border(AppColors.error, 1.6),
          errorStyle: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AppColors.error,
          ),
          errorMaxLines: 2,
        ),
      ),
    );
  }
}

// ───────────────────────── Date tile ─────────────────────────

class _DateTile extends StatelessWidget {
  final DateTime date;
  final VoidCallback onTap;
  final bool isLast;

  const _DateTile({required this.date, required this.onTap, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final days = date.difference(DateTime.now()).inDays;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md + 2),
      child: Pressable(
        onTap: onTap,
        scale: 0.985,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(PhosphorIconsRegular.calendarBlank, size: 19, color: AppColors.textMuted),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Travel date',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('EEE, dd MMM yyyy').format(date),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        fontFeatures: AppText.tabular,
                      ),
                    ),
                  ],
                ),
              ),
              if (days >= 0) ...[
                ToneChip(
                  label: days == 0 ? 'Today' : 'in $days day${days == 1 ? '' : 's'}',
                  tone: ChipTone.brand,
                  dense: true,
                ),
                const SizedBox(width: 6),
              ],
              Icon(PhosphorIconsBold.caretDown, size: 13, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
