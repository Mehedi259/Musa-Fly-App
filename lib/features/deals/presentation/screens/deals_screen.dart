import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../data/models/deal_model.dart';
import '../providers/deal_provider.dart';
import 'create_booking_inquiry_screen.dart';

/// Booking / deals list. Navy summary header with live counts, then a
/// stack of boarding-pass style cards.
class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DealProvider>(context, listen: false).fetchDeals();
    });
  }

  void _openCreate() => context.pushPremium(const CreateBookingInquiryScreen());

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DealProvider>(context);
    final deals = provider.deals;
    final showSkeleton = provider.isLoading && deals.isEmpty;
    final showError = !provider.isLoading && provider.errorMessage != null && deals.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      // This screen is a tab inside the shell's Scaffold, which draws the
      // floating nav bar over the body. Without this inset the FAB sits
      // underneath the nav bar and cannot be tapped.
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 84),
        child: _NewInquiryFab(onTap: _openCreate),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => provider.fetchDeals(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _SummaryHeader(
                deals: deals,
                loading: provider.isLoading,
                onRefresh: () => provider.fetchDeals(),
              ),
            ),
            if (showSkeleton)
              const SliverToBoxAdapter(child: _TicketSkeletonList())
            else if (showError)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _DealsErrorState(
                  message: provider.errorMessage!,
                  onRetry: () => provider.fetchDeals(),
                ),
              )
            else if (deals.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _DealsEmptyState(onCreate: _openCreate),
              )
            else ...[
              const SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Your trips',
                  subtitle: 'Tap a ticket to see what we filed for you',
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.page,
                    AppSpacing.xl,
                    AppSpacing.page,
                    AppSpacing.md,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.page, 0, AppSpacing.page, 110),
                sliver: SliverList.separated(
                  itemCount: deals.length,
                  separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md + 2),
                  itemBuilder: (context, i) => FadeSlideIn(
                    index: i,
                    child: _BoardingPassCard(deal: deals[i]),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Header ─────────────────────────

class _SummaryHeader extends StatelessWidget {
  final List<DealModel> deals;
  final bool loading;
  final VoidCallback onRefresh;

  const _SummaryHeader({required this.deals, required this.loading, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final upcoming = deals.where((d) => !d.travelDate.isBefore(DateTime(now.year, now.month, now.day))).length;
    final completed = deals.length - upcoming;
    final value = deals.fold<double>(0, (sum, d) => sum + d.dealPrice);

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
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(AppRadius.sm + 2),
                    ),
                    child: Icon(
                      PhosphorIconsFill.ticket,
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
                          'My bookings',
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
                          'Every inquiry you filed with MusaFly',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.5, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  _GlassIconButton(
                    icon: PhosphorIconsBold.arrowClockwise,
                    spinning: loading,
                    onTap: onRefresh,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(child: _HeaderStat(label: 'Upcoming', value: '$upcoming')),
                  const _HeaderDivider(),
                  Expanded(child: _HeaderStat(label: 'Completed', value: '$completed')),
                  const _HeaderDivider(),
                  Expanded(
                    child: _HeaderStat(
                      label: 'Total value',
                      value: deals.isEmpty ? '—' : CurrencyFormatter.formatSmart(value),
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

class _HeaderDivider extends StatelessWidget {
  const _HeaderDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      color: Colors.white.withValues(alpha: 0.16),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;

  const _HeaderStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
            fontFeatures: AppText.tabular,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool spinning;

  const _GlassIconButton({required this.icon, required this.onTap, this.spinning = false});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: spinning
            ? const Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

// ───────────────────────── Ticket card ─────────────────────────

class _CategoryStyle {
  final IconData icon;
  final Color color;
  final String tag;
  const _CategoryStyle(this.icon, this.color, this.tag);
}

_CategoryStyle _categoryStyleFor(String category) {
  final c = category.toLowerCase();
  if (c.contains('flight')) {
    return _CategoryStyle(PhosphorIconsFill.airplaneTakeoff, AppColors.catFlight, 'Flight');
  }
  if (c.contains('tour') || c.contains('holiday')) {
    return _CategoryStyle(PhosphorIconsFill.umbrella, AppColors.catTour, 'Tour');
  }
  if (c.contains('umrah') || c.contains('hajj')) {
    return _CategoryStyle(PhosphorIconsFill.mosque, AppColors.catUmrah, 'Umrah');
  }
  if (c.contains('visa')) {
    return _CategoryStyle(PhosphorIconsFill.identificationCard, AppColors.catVisa, 'Visa');
  }
  return _CategoryStyle(PhosphorIconsFill.tagSimple, AppColors.catDeal, 'Deal');
}

class _BoardingPassCard extends StatelessWidget {
  final DealModel deal;
  const _BoardingPassCard({required this.deal});

  @override
  Widget build(BuildContext context) {
    final style = _categoryStyleFor(deal.serviceCategory);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final past = deal.travelDate.isBefore(today);
    final days = deal.travelDate.difference(today).inDays;

    final (statusLabel, statusTone) = past
        ? ('Completed', ChipTone.neutral)
        : days <= 3
            ? ('Departing soon', ChipTone.gold)
            : ('Confirmed', ChipTone.success);

    return Container(
      decoration: AppDecor.card(shadow: AppShadows.medium),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 5, color: style.color),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: AppDecor.soft(style.color, radius: AppRadius.sm + 2),
                          child: Icon(style.icon, color: style.color, size: 20),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                deal.serviceCategory.isEmpty ? style.tag : deal.serviceCategory,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14.5,
                                  letterSpacing: -0.2,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Icon(PhosphorIconsRegular.mapPin, size: 12, color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      deal.routeDestination.isEmpty
                                          ? 'Destination to be confirmed'
                                          : deal.routeDestination,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 12.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        ToneChip(label: statusLabel, tone: statusTone, dense: true),
                      ],
                    ),
                  ),
                  // Tear line with notches cut into both edges.
                  Row(
                    children: [
                      const TicketNotch(left: true),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                          child: DashedDivider(color: AppColors.borderStrong),
                        ),
                      ),
                      const TicketNotch(left: false),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: _PassField(
                            label: 'Passenger',
                            value: deal.customerName.isEmpty ? 'Guest' : deal.customerName,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: _PassField(
                            label: 'Travel date',
                            value: DateFormat('dd MMM, yyyy').format(deal.travelDate),
                            tabular: true,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: _PassField(
                            label: 'Price',
                            value: CurrencyFormatter.formatSmart(
                              deal.dealPrice,
                              defaultCurrency: deal.currency,
                            ),
                            alignEnd: true,
                            emphasis: true,
                            tabular: true,
                          ),
                        ),
                      ],
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

class _PassField extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;
  final bool emphasis;
  final bool tabular;

  const _PassField({
    required this.label,
    required this.value,
    this.alignEnd = false,
    this.emphasis = false,
    this.tabular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 9.5,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: TextStyle(
            fontWeight: emphasis ? FontWeight.w800 : FontWeight.w700,
            fontSize: emphasis ? 15 : 13,
            letterSpacing: emphasis ? -0.4 : 0,
            color: emphasis ? AppColors.primary : AppColors.textPrimary,
            fontFeatures: tabular ? AppText.tabular : null,
          ),
        ),
      ],
    );
  }
}

// ───────────────────────── FAB ─────────────────────────

class _NewInquiryFab extends StatelessWidget {
  final VoidCallback onTap;
  const _NewInquiryFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: AppColors.goldCta,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: AppShadows.glow(AppColors.secondary, opacity: 0.42),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIconsBold.plus, size: 18, color: AppColors.primaryDark),
            const SizedBox(width: 8),
            const Text(
              'New inquiry',
              style: TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w800,
                fontSize: 14.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── States ─────────────────────────

class _TicketSkeletonList extends StatelessWidget {
  const _TicketSkeletonList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.xxl, AppSpacing.page, 40),
      child: Column(
        children: List.generate(
          3,
          (_) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md + 2),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: AppDecor.card(),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerBox(
                      width: 42,
                      height: 42,
                      borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm + 2)),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(width: 120, height: 13),
                          SizedBox(height: 8),
                          ShimmerBox(width: 170, height: 11),
                        ],
                      ),
                    ),
                    ShimmerBox(
                      width: 68,
                      height: 20,
                      borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.lg),
                ShimmerBox(width: double.infinity, height: 1),
                SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(child: ShimmerBox(width: double.infinity, height: 30)),
                    SizedBox(width: AppSpacing.md),
                    Expanded(child: ShimmerBox(width: double.infinity, height: 30)),
                    SizedBox(width: AppSpacing.md),
                    Expanded(child: ShimmerBox(width: double.infinity, height: 30)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DealsEmptyState extends StatelessWidget {
  final VoidCallback onCreate;
  const _DealsEmptyState({required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xxxl, AppSpacing.xxxl, AppSpacing.xxxl, 110),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: AppColors.primarySubtle,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.secondary.withValues(alpha: 0.45), width: 1.4),
              ),
              child: Icon(PhosphorIconsDuotone.ticket, size: 46, color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              'No bookings yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Send us a flight, tour, Umrah or visa inquiry and our team will come back to you with a quote.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: AppSpacing.xxl),
            PremiumButton(
              label: 'Start an inquiry',
              icon: PhosphorIconsBold.plus,
              expand: false,
              height: 50,
              onPressed: onCreate,
            ),
          ],
        ),
      ),
    );
  }
}

class _DealsErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _DealsErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return FadeSlideIn(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.xxxl, AppSpacing.xxxl, AppSpacing.xxxl, 110),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: const BoxDecoration(color: AppColors.errorSubtle, shape: BoxShape.circle),
              child: Icon(PhosphorIconsDuotone.cloudWarning, size: 40, color: AppColors.error),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              "We couldn't load your bookings",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: AppSpacing.xxl),
            PremiumButton(
              label: 'Try again',
              icon: PhosphorIconsBold.arrowClockwise,
              style: PremiumButtonStyle.outline,
              expand: false,
              height: 48,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
