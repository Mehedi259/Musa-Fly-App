import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../models/notification_model.dart';
import '../providers/notification_provider.dart';

/// Notification centre: date-grouped feed where unread items sit on a
/// tinted surface with a dot and heavier type.
class NotificationsScreen extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const NotificationsScreen({super.key, required this.onNavigateTab});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(context, listen: false).fetchNotifications();
    });
  }

  void _handleNotificationClick(NotificationModel notification) {
    Provider.of<NotificationProvider>(context, listen: false).markAsRead(notification.id);

    if (notification.targetType == 'external_url' && notification.externalLink != null) {
      UrlHelper.openWeb(notification.externalLink!);
      return;
    }

    if (widget.onNavigateTab != null) {
      int tabIndex = 0;
      switch (notification.targetType) {
        case 'flight':
          tabIndex = 1;
          break;
        case 'umrah':
          tabIndex = 2;
          break;
        case 'visa':
          tabIndex = 3;
          break;
        case 'deal':
        case 'tour':
          tabIndex = 4;
          break;
        default:
          tabIndex = 0;
      }
      Navigator.pop(context);
      widget.onNavigateTab!(tabIndex);
    }
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes == 0 ? 1 : difference.inMinutes} মিনিট আগে';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ঘণ্টা আগে';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} দিন আগে';
    } else {
      return DateFormat('dd MMM yyyy', 'en_US').format(dt);
    }
  }

  String _groupLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(day).inDays;
    if (diff <= 0) return 'আজ';
    if (diff == 1) return 'গতকাল';
    if (diff < 7) return 'এই সপ্তাহ';
    return 'আগের নোটিফিকেশন';
  }

  List<Object> _buildRows(List<NotificationModel> items) {
    final rows = <Object>[];
    String? last;
    for (final n in items) {
      final g = _groupLabel(n.createdAt);
      if (g != last) {
        rows.add(g);
        last = g;
      }
      rows.add(n);
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);
    final rows = _buildRows(provider.notifications);
    final showSkeleton = provider.isLoading && provider.notifications.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _NotificationsHeader(
            unreadCount: provider.unreadCount,
            onMarkAll: provider.markAllAsRead,
          ),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async => await provider.fetchNotifications(),
              child: showSkeleton
                  ? const _NotificationSkeleton()
                  : provider.notifications.isEmpty
                      ? _EmptyState(error: provider.error)
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.page,
                            AppSpacing.sm,
                            AppSpacing.page,
                            AppSpacing.xxxl,
                          ),
                          itemCount: rows.length,
                          itemBuilder: (context, index) {
                            final row = rows[index];
                            if (row is String) {
                              return _GroupHeader(label: row, first: index == 0);
                            }
                            final item = row as NotificationModel;
                            return FadeSlideIn(
                              key: ValueKey('notif-${item.id}'),
                              index: index,
                              child: _NotificationCard(
                                item: item,
                                timeLabel: _formatDate(item.createdAt),
                                onTap: () => _handleNotificationClick(item),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Header ─────────────────────────

class _NotificationsHeader extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onMarkAll;

  const _NotificationsHeader({required this.unreadCount, required this.onMarkAll});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: AppShadows.soft),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
          child: Row(
            children: [
              SoftIconButton(
                icon: PhosphorIconsBold.arrowLeft,
                size: 42,
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Flexible(
                          child: Text(
                            'নোটিফিকেশন',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        if (unreadCount > 0) ...[
                          const SizedBox(width: 7),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: AppColors.goldCta,
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                            ),
                            child: Text(
                              '$unreadCount',
                              style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                fontFeatures: AppText.tabular,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      unreadCount > 0
                          ? '$unreadCount টি নতুন আপডেট অপেক্ষা করছে'
                          : 'মুসাফ্লাই স্পেশাল ডিলস ও আপডেট',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 11.5),
                    ),
                  ],
                ),
              ),
              if (unreadCount > 0) ...[
                const SizedBox(width: AppSpacing.sm),
                Pressable(
                  onTap: onMarkAll,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppColors.primarySubtle,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(PhosphorIconsBold.checks, size: 14, color: AppColors.primary),
                        const SizedBox(width: 5),
                        const Text(
                          'সব পড়া',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
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

class _GroupHeader extends StatelessWidget {
  final String label;
  final bool first;

  const _GroupHeader({required this.label, required this.first});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(2, first ? AppSpacing.md : AppSpacing.xl, 2, AppSpacing.md),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          const Expanded(child: Divider(height: 1, color: AppColors.border)),
        ],
      ),
    );
  }
}

// ───────────────────────── Card ─────────────────────────

IconData _iconFor(String? type) {
  switch (type) {
    case 'flight':
      return PhosphorIconsFill.airplaneTakeoff;
    case 'umrah':
      return PhosphorIconsFill.mosque;
    case 'visa':
      return PhosphorIconsFill.identificationCard;
    case 'tour':
      return PhosphorIconsFill.umbrella;
    case 'deal':
      return PhosphorIconsFill.tagSimple;
    case 'external_url':
      return PhosphorIconsFill.arrowSquareOut;
    default:
      return PhosphorIconsFill.bellSimple;
  }
}

Color _accentFor(String? type) {
  switch (type) {
    case 'flight':
      return AppColors.catFlight;
    case 'umrah':
      return AppColors.catUmrah;
    case 'visa':
      return AppColors.catVisa;
    case 'tour':
      return AppColors.catTour;
    case 'deal':
      return AppColors.catDeal;
    default:
      return AppColors.primary;
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel item;
  final String timeLabel;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.item,
    required this.timeLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = item.image != null && item.image!.isNotEmpty;
    final unread = !item.isRead;
    final accent = _accentFor(item.targetType);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Pressable(
        onTap: onTap,
        scale: 0.985,
        child: AnimatedContainer(
          duration: AppMotion.base,
          curve: AppMotion.ease,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: unread ? AppColors.primarySubtle : Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: unread ? AppColors.primary.withValues(alpha: 0.28) : AppColors.border,
              width: unread ? 1.3 : 1,
            ),
            boxShadow: unread ? AppShadows.medium : AppShadows.soft,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasImage)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: AppNetworkImage(imageUrl: item.image!, fit: BoxFit.cover),
                ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!hasImage) ...[
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: unread ? accent : accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          boxShadow: unread ? AppShadows.glow(accent, opacity: 0.26) : null,
                        ),
                        child: Icon(
                          _iconFor(item.targetType),
                          size: 20,
                          color: unread ? Colors.white : accent,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: ToneChip(
                                  label: item.badgeText,
                                  tone: ChipTone.gold,
                                  dense: true,
                                ),
                              ),
                              const Spacer(),
                              if (unread) ...[
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                              ],
                              Text(
                                timeLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.3,
                              letterSpacing: -0.2,
                              fontWeight: unread ? FontWeight.w800 : FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.message,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                item.targetType == 'external_url' ? 'লিংক খুলুন' : 'অফারটি দেখুন',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                PhosphorIconsBold.arrowRight,
                                size: 12,
                                color: AppColors.primary,
                              ),
                            ],
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
      ),
    );
  }
}

// ───────────────────────── States ─────────────────────────

class _NotificationSkeleton extends StatelessWidget {
  const _NotificationSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.lg,
        AppSpacing.page,
        AppSpacing.xxxl,
      ),
      children: List.generate(
        4,
        (_) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: AppDecor.card(),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(
                width: 44,
                height: 44,
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      width: 80,
                      height: 16,
                      borderRadius: BorderRadius.all(Radius.circular(AppRadius.pill)),
                    ),
                    SizedBox(height: 10),
                    ShimmerBox(width: double.infinity, height: 13),
                    SizedBox(height: 8),
                    ShimmerBox(width: double.infinity, height: 11),
                    SizedBox(height: 6),
                    ShimmerBox(width: 190, height: 11),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String? error;
  const _EmptyState({this.error});

  @override
  Widget build(BuildContext context) {
    final isError = error != null;

    return LayoutBuilder(
      builder: (context, constraints) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxxl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        color: isError ? AppColors.errorSubtle : AppColors.primarySubtle,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isError
                              ? AppColors.error.withValues(alpha: 0.25)
                              : AppColors.secondary.withValues(alpha: 0.45),
                          width: 1.4,
                        ),
                      ),
                      child: Icon(
                        isError
                            ? PhosphorIconsDuotone.cloudWarning
                            : PhosphorIconsDuotone.bellSimple,
                        size: 44,
                        color: isError ? AppColors.error : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      isError ? 'নোটিফিকেশন লোড করা যায়নি' : 'কোনো নোটিফিকেশন নেই',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      isError
                          ? 'ইন্টারনেট সংযোগ দেখে নিচে টেনে আবার চেষ্টা করুন।'
                          : 'নতুন কোনো অফার বা ক্যাম্পেইন আসলে আপনি সাথে সাথে নোটিফিকেশন পাবেন।',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          PhosphorIconsRegular.arrowClockwise,
                          size: 13,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'রিফ্রেশ করতে নিচে টানুন',
                          style: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
                        ),
                      ],
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
