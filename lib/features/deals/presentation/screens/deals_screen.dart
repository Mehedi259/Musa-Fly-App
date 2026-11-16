import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/booking_ui.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../data/models/deal_model.dart';
import '../providers/deal_provider.dart';
import '../services_ui.dart';
import 'create_booking_inquiry_screen.dart';

/// Bookings list. A white page with a centred title, a light summary strip
/// and filter chips over a stack of ticket cards.
class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

enum _DealFilter { all, upcoming, completed }

class _DealsScreenState extends State<DealsScreen> {
  _DealFilter _filter = _DealFilter.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DealProvider>(context, listen: false).fetchDeals();
    });
  }

  void _openCreate() => context.pushPremium(const CreateBookingInquiryScreen());

  static DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static bool _isUpcoming(DealModel d) => !d.travelDate.isBefore(_today);

  List<DealModel> _apply(List<DealModel> deals) {
    switch (_filter) {
      case _DealFilter.upcoming:
        return deals.where(_isUpcoming).toList();
      case _DealFilter.completed:
        return deals.where((d) => !_isUpcoming(d)).toList();
      case _DealFilter.all:
        return deals;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DealProvider>(context);
    final deals = provider.deals;
    final visible = _apply(deals);
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
      body: Column(
        children: [
          ServicePageHeader(
            title: context.tr('services.bookings.title'),
            subtitle: context.tr('services.bookings.subtitle'),
            trailing: _RefreshButton(
              spinning: provider.isLoading,
              onTap: () => provider.fetchDeals(),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => provider.fetchDeals(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  if (deals.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: FadeSlideIn(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.page,
                            AppSpacing.lg,
                            AppSpacing.page,
                            AppSpacing.lg,
                          ),
                          child: _SummaryStrip(deals: deals),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: FilterChipRail(
                        labels: [
                          context.tr('services.bookings.filter.all'),
                          context.tr('services.bookings.filter.upcoming'),
                          context.tr('services.bookings.filter.completed'),
                        ],
                        index: _DealFilter.values.indexOf(_filter),
                        onChanged: (i) => setState(() => _filter = _DealFilter.values[i]),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
                  ],
                  if (showSkeleton)
                    const SliverToBoxAdapter(child: _TicketSkeletonList())
                  else if (showError)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: ServiceMessageState(
                        icon: PhosphorIconsDuotone.cloudWarning,
                        tint: AppColors.error,
                        title: context.tr('services.bookings.error.title'),
                        body: provider.errorMessage!,
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.xxxl,
                          AppSpacing.xxxl,
                          AppSpacing.xxxl,
                          110,
                        ),
                        action: PremiumButton(
                          label: context.tr('action.retry'),
                          icon: PhosphorIconsBold.arrowClockwise,
                          style: PremiumButtonStyle.outline,
                          expand: false,
                          height: 48,
                          onPressed: () => provider.fetchDeals(),
                        ),
                      ),
                    )
                  else if (deals.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: ServiceMessageState(
                        icon: PhosphorIconsDuotone.ticket,
                        title: context.tr('services.bookings.empty.title'),
                        body: context.tr('services.bookings.empty.body'),
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.xxxl,
                          AppSpacing.xxxl,
                          AppSpacing.xxxl,
                          110,
                        ),
                        action: PremiumButton(
                          label: context.tr('services.bookings.empty.action'),
                          icon: PhosphorIconsBold.plus,
                          expand: false,
                          height: 50,
                          onPressed: _openCreate,
                        ),
                      ),
                    )
                  else if (visible.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: ServiceMessageState(
                        icon: PhosphorIconsDuotone.funnelSimple,
                        title: context.tr('services.bookings.filterEmpty.title'),
                        body: context.tr('services.bookings.filterEmpty.body'),
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.xxxl,
                          AppSpacing.lg,
                          AppSpacing.xxxl,
                          110,
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.page, 0, AppSpacing.page, 120),
                      sliver: SliverList.separated(
                        itemCount: visible.length,
                        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, i) => FadeSlideIn(
                          key: ValueKey('deal-${visible[i].id ?? i}-$_filter'),
                          index: i,
                          child: _TicketCard(deal: visible[i]),
                        ),
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
}

// ───────────────────────── Summary ─────────────────────────

class _SummaryStrip extends StatelessWidget {
  final List<DealModel> deals;

  const _SummaryStrip({required this.deals});

  @override
  Widget build(BuildContext context) {
    final upcoming = deals.where(_DealsScreenState._isUpcoming).length;
    final completed = deals.length - upcoming;
    final value = deals.fold<double>(0, (sum, d) => sum + d.dealPrice);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      decoration: AppDecor.card(),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _Stat(
                label: context.tr('services.bookings.upcoming'),
                value: '$upcoming',
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1, color: AppColors.divider),
            Expanded(
              child: _Stat(
                label: context.tr('services.bookings.completed'),
                value: '$completed',
              ),
            ),
            const VerticalDivider(width: 1, thickness: 1, color: AppColors.divider),
            Expanded(
              child: _Stat(
                label: context.tr('services.bookings.totalValue'),
                value: deals.isEmpty ? '—' : CurrencyFormatter.formatSmart(value),
                gold: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final bool gold;

  const _Stat({required this.label, required this.value, this.gold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
                color: gold ? AppColors.secondaryDark : AppColors.textPrimary,
                fontFeatures: AppText.tabular,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool spinning;

  const _RefreshButton({required this.onTap, this.spinning = false});

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
        ),
        child: spinning
            ? const Center(
                child: SizedBox(
                  width: 15,
                  height: 15,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              )
            : Icon(
                PhosphorIconsBold.arrowClockwise,
                size: 16,
                color: AppColors.textPrimary,
              ),
      ),
    );
  }
}

// ───────────────────────── Ticket card ─────────────────────────

class _CategoryStyle {
  final IconData icon;
  final Color color;
  const _CategoryStyle(this.icon, this.color);
}

_CategoryStyle _categoryStyleFor(String category) {
  final c = category.toLowerCase();
  if (c.contains('flight')) {
    return _CategoryStyle(PhosphorIconsFill.airplaneTakeoff, AppColors.catFlight);
  }
  if (c.contains('tour') || c.contains('holiday')) {
    return _CategoryStyle(PhosphorIconsFill.umbrella, AppColors.catTour);
  }
  if (c.contains('umrah') || c.contains('hajj')) {
    return _CategoryStyle(PhosphorIconsFill.mosque, AppColors.catUmrah);
  }
  if (c.contains('visa')) {
    return _CategoryStyle(PhosphorIconsFill.identificationCard, AppColors.catVisa);
  }
  return _CategoryStyle(PhosphorIconsFill.tagSimple, AppColors.catDeal);
}

class _TicketCard extends StatelessWidget {
  final DealModel deal;
  const _TicketCard({required this.deal});

  @override
  Widget build(BuildContext context) {
    final style = _categoryStyleFor(deal.serviceCategory);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final past = deal.travelDate.isBefore(today);
    final days = deal.travelDate.difference(today).inDays;

    final (statusKey, statusTone) = past
        ? ('services.bookings.status.completed', ChipTone.neutral)
        : days <= 3
            ? ('services.bookings.status.soon', ChipTone.gold)
            : ('services.bookings.status.confirmed', ChipTone.success);

    return Container(
      decoration: AppDecor.card(),
      clipBehavior: Clip.antiAlias,
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
                  width: 40,
                  height: 40,
                  decoration: AppDecor.soft(style.color, radius: AppRadius.sm),
                  child: Icon(style.icon, color: style.color, size: 19),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        deal.serviceCategory.isEmpty
                            ? context.tr('service.deals')
                            : deal.serviceCategory,
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
                                  ? context.tr('services.bookings.destinationTbc')
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
                Flexible(
                  child: ToneChip(label: context.tr(statusKey), tone: statusTone, dense: true),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: DashedDivider(color: AppColors.border),
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
                    label: context.tr('services.bookings.passenger'),
                    value: deal.customerName.isEmpty
                        ? context.tr('services.bookings.guest')
                        : deal.customerName,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: _PassField(
                    label: context.tr('services.bookings.travelDate'),
                    value: DateFormat('dd MMM, yyyy').format(deal.travelDate),
                    tabular: true,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _PassField(
                    label: context.tr('services.bookings.price'),
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
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
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
            color: emphasis ? AppColors.secondaryDark : AppColors.textPrimary,
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
        constraints: const BoxConstraints(maxWidth: 240),
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
            Flexible(
              child: Text(
                context.tr('services.bookings.newInquiry'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── Skeleton ─────────────────────────

class _TicketSkeletonList extends StatelessWidget {
  const _TicketSkeletonList();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.lg, AppSpacing.page, 40),
      child: Column(
        children: List.generate(
          3,
          (_) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: AppDecor.card(),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerBox(
                      width: 40,
                      height: 40,
                      borderRadius: BorderRadius.all(Radius.circular(AppRadius.sm)),
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
