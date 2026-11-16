import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../data/models/faq_model.dart';
import '../../data/models/testimonial_model.dart';
import '../providers/support_provider.dart';

/// Customer care: gold-accented hero with instant contact actions, a
/// contact card, filterable FAQ accordions and client testimonials.
class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  int? _expandedFaqId;

  static const List<(String, String)> _filters = [
    ('all', 'All'),
    ('flights', 'Flights'),
    ('tours', 'Tours'),
    ('visa', 'Visa'),
    ('general', 'General'),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SupportProvider>(context, listen: false);
      if (provider.faqs.isEmpty) {
        provider.fetchSupportData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SupportProvider>(context);
    final faqs = provider.faqs
        .where((f) =>
            provider.selectedCategory == 'all' ||
            f.category.toLowerCase() == provider.selectedCategory.toLowerCase())
        .toList();
    final loadingFaqs = provider.isLoading && provider.faqs.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => provider.fetchSupportData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SupportHero(),
              const SizedBox(height: AppSpacing.xl),
              const FadeSlideIn(
                index: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.page),
                  child: _ContactCard(),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const SectionHeader(
                title: 'Frequently asked',
                subtitle: 'Bookings, visas, refunds and cancellations',
              ),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                  itemCount: _filters.length,
                  separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (_, i) {
                    final (value, label) = _filters[i];
                    return _FilterChip(
                      label: label,
                      selected: provider.selectedCategory == value,
                      onTap: () {
                        setState(() => _expandedFaqId = null);
                        provider.setSelectedCategory(value);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                child: loadingFaqs
                    ? const _FaqSkeleton()
                    : provider.errorMessage != null && provider.faqs.isEmpty
                        ? _FaqErrorState(onRetry: () => provider.fetchSupportData())
                        : faqs.isEmpty
                            ? const _FaqEmptyState()
                            : Column(
                                children: [
                                  for (int i = 0; i < faqs.length; i++)
                                    FadeSlideIn(
                                      key: ValueKey('faq-${faqs[i].id}'),
                                      index: i,
                                      child: _FaqTile(
                                        faq: faqs[i],
                                        expanded: _expandedFaqId == faqs[i].id,
                                        onTap: () => setState(
                                          () => _expandedFaqId =
                                              _expandedFaqId == faqs[i].id ? null : faqs[i].id,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
              ),
              if (provider.testimonials.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xxl),
                const SectionHeader(
                  title: 'Client experiences',
                  subtitle: 'Real stories from travellers we have flown',
                ),
                SizedBox(
                  height: 206,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
                    itemCount: provider.testimonials.length,
                    separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
                    itemBuilder: (_, i) => FadeSlideIn(
                      index: i,
                      child: _TestimonialCard(item: provider.testimonials[i]),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Hero ─────────────────────────

class _SupportHero extends StatelessWidget {
  const _SupportHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppRadius.xl)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.lg,
            AppSpacing.page,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // This screen has no tab of its own — it is pushed from the
                  // home trust block — so it needs its own way back.
                  if (Navigator.canPop(context)) ...[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                        ),
                        child: Icon(
                          PhosphorIconsBold.arrowLeft,
                          color: Colors.white,
                          size: 19,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                    ),
                    child: Icon(
                      PhosphorIconsFill.headset,
                      color: AppColors.primaryDark,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Need a hand?',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'A real travel concierge, around the clock',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.5, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: PremiumButton(
                      label: 'WhatsApp',
                      icon: PhosphorIconsFill.whatsappLogo,
                      height: 50,
                      style: PremiumButtonStyle.whatsapp,
                      onPressed: () => UrlHelper.launchWhatsApp(),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: PremiumButton(
                      label: 'Call us',
                      icon: PhosphorIconsFill.phoneCall,
                      height: 50,
                      onPressed: () => UrlHelper.makePhoneCall(AppStrings.phone),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Icon(
                    PhosphorIconsFill.sealCheck,
                    size: 14,
                    color: AppColors.secondaryLight,
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'Average reply in under 5 minutes · English, Arabic & Bangla',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11.5, color: Colors.white70, height: 1.35),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Contact card ─────────────────────────

class _ContactCard extends StatelessWidget {
  const _ContactCard();

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      child: Column(
        children: [
          _ContactRow(
            icon: PhosphorIconsFill.mapPin,
            title: 'Main office',
            subtitle: AppStrings.address,
            onTap: () => UrlHelper.openWeb(AppStrings.websiteUrl),
          ),
          const Divider(height: 1, color: AppColors.divider),
          _ContactRow(
            icon: PhosphorIconsFill.envelopeSimple,
            title: 'Email the desk',
            subtitle: AppStrings.email,
            onTap: () => UrlHelper.sendEmail(AppStrings.email),
          ),
          const Divider(height: 1, color: AppColors.divider),
          _ContactRow(
            icon: PhosphorIconsFill.globe,
            title: 'Official website',
            subtitle: 'www.musafly.com',
            onTap: () => UrlHelper.openWeb(AppStrings.websiteUrl),
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.985,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: AppDecor.soft(AppColors.primary, radius: AppRadius.sm + 2),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: AppSpacing.md + 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(PhosphorIconsBold.caretRight, size: 13, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Filter chip ─────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      scale: 0.95,
      child: AnimatedContainer(
        duration: AppMotion.base,
        curve: AppMotion.emphasized,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
          boxShadow: selected ? AppShadows.glow(AppColors.primary, opacity: 0.22) : AppShadows.soft,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── FAQ ─────────────────────────

class _FaqTile extends StatelessWidget {
  final FaqModel faq;
  final bool expanded;
  final VoidCallback onTap;

  const _FaqTile({required this.faq, required this.expanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md - 2),
      child: Pressable(
        onTap: onTap,
        scale: 0.99,
        child: AnimatedContainer(
          duration: AppMotion.base,
          curve: AppMotion.ease,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md + 2),
            border: Border.all(
              color: expanded ? AppColors.primary.withValues(alpha: 0.45) : AppColors.border,
              width: expanded ? 1.4 : 1,
            ),
            boxShadow: expanded ? AppShadows.medium : AppShadows.soft,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: AppMotion.base,
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: expanded ? AppColors.primary : AppColors.primarySubtle,
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                    child: Icon(
                      PhosphorIconsBold.question,
                      size: 15,
                      color: expanded ? AppColors.secondary : AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        faq.question,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                          color: expanded ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: AppMotion.base,
                    curve: AppMotion.emphasized,
                    child: Icon(
                      PhosphorIconsBold.caretDown,
                      size: 14,
                      color: expanded ? AppColors.primary : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              AnimatedSize(
                duration: AppMotion.base,
                curve: AppMotion.emphasized,
                alignment: Alignment.topCenter,
                child: expanded
                    ? Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.md, left: 40),
                        child: Text(
                          faq.answer,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.55,
                          ),
                        ),
                      )
                    : const SizedBox(width: double.infinity),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqSkeleton extends StatelessWidget {
  const _FaqSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (_) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md - 2),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: AppDecor.card(radius: AppRadius.md + 2),
          child: const Row(
            children: [
              ShimmerBox(
                width: 28,
                height: 28,
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.xs)),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(child: ShimmerBox(width: double.infinity, height: 13)),
              SizedBox(width: AppSpacing.md),
              ShimmerBox(width: 14, height: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqEmptyState extends StatelessWidget {
  const _FaqEmptyState();

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl, horizontal: AppSpacing.xl),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(color: AppColors.primarySubtle, shape: BoxShape.circle),
            child: Icon(PhosphorIconsDuotone.chatCircleDots, size: 30, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Nothing here yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'No questions in this category. Message us on WhatsApp and we will answer in minutes.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.45),
          ),
          const SizedBox(height: AppSpacing.lg),
          PremiumButton(
            label: 'Ask on WhatsApp',
            icon: PhosphorIconsFill.whatsappLogo,
            style: PremiumButtonStyle.whatsapp,
            height: 46,
            expand: false,
            onPressed: () => UrlHelper.launchWhatsApp(),
          ),
        ],
      ),
    );
  }
}

class _FaqErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _FaqErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxxl, horizontal: AppSpacing.xl),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(color: AppColors.errorSubtle, shape: BoxShape.circle),
            child: Icon(PhosphorIconsDuotone.cloudWarning, size: 30, color: AppColors.error),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            "Couldn't load the help centre",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Check your connection and pull to refresh, or reach us directly.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.45),
          ),
          const SizedBox(height: AppSpacing.lg),
          PremiumButton(
            label: 'Try again',
            icon: PhosphorIconsBold.arrowClockwise,
            style: PremiumButtonStyle.outline,
            height: 46,
            expand: false,
            onPressed: onRetry,
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Testimonials ─────────────────────────

class _TestimonialCard extends StatelessWidget {
  final TestimonialModel item;
  const _TestimonialCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final initials = item.name.trim().isEmpty
        ? 'MF'
        : item.name
            .trim()
            .split(RegExp(r'\s+'))
            .take(2)
            .map((w) => w[0].toUpperCase())
            .join();

    return Container(
      width: 290,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecor.card(shadow: AppShadows.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontSize: 13.5,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md - 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Row(
                      children: [
                        Icon(PhosphorIconsFill.mapPin, size: 10, color: AppColors.textMuted),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            item.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(PhosphorIconsFill.quotes, size: 22, color: AppColors.secondaryLight),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              ...List.generate(
                5,
                (i) => Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Icon(
                    i < item.rating ? PhosphorIconsFill.star : PhosphorIconsRegular.star,
                    size: 14,
                    color: i < item.rating ? AppColors.secondary : AppColors.borderStrong,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${item.rating}.0',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  fontFeatures: AppText.tabular,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: Text(
              item.text,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
