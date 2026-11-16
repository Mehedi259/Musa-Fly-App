import 'package:flutter/material.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_design.dart';
import '../../../../core/l10n/app_text.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/booking_ui.dart';
import '../../../../core/widgets/motion.dart';
import '../../../../core/widgets/premium.dart';
import '../../../flights/presentation/widgets/flight_header.dart';
import '../../../tours/presentation/widgets/travel_ui.dart';
import '../providers/umrah_provider.dart';
import '../widgets/umrah_card.dart';

/// Minimal, high-standard Umrah screen.
/// Clean white page, serene header with WhatsApp advisor action, and
/// uncluttered package cards.
class UmrahScreen extends StatefulWidget {
  const UmrahScreen({super.key});

  @override
  State<UmrahScreen> createState() => _UmrahScreenState();
}

class _UmrahScreenState extends State<UmrahScreen> {
  int _selectedFilter = 0; // 0: All, 1: Executive 5★, 2: Family, 3: Economy

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<UmrahProvider>(context, listen: false);
      if (provider.packages.isEmpty) {
        provider.fetchPackages();
      }
    });
  }

  void _chatWithUmrahGuide() {
    UrlHelper.launchWhatsApp(
      customMessage: 'Salam MusaFly! I am interested in your Umrah packages. Could you please share the latest available packages and pricing details?',
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UmrahProvider>(context);

    final filters = [
      context.pick('All Packages', 'সব প্যাকেজ'),
      context.pick('5★ Executive', '৫★ এক্সিকিউটিভ'),
      context.pick('Family & Group', 'ফ্যামিলি ও গ্রুপ'),
      context.pick('Economy', 'ইকোনমি'),
    ];

    final filteredPackages = provider.packages.where((pkg) {
      if (_selectedFilter == 0) return true;
      final name = pkg.packageName.toLowerCase();
      if (_selectedFilter == 1) return name.contains('vip') || name.contains('executive') || name.contains('5★');
      if (_selectedFilter == 2) return name.contains('family') || name.contains('group') || name.contains('14');
      if (_selectedFilter == 3) return name.contains('economy') || name.contains('standard');
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          FlightHeader(
            title: context.pick('Umrah Packages', 'উমরাহ প্যাকেজ'),
            subtitle: context.pick('Licensed Hajj & Umrah Agency', 'অনুমোদিত উমরাহ সেবা'),
            action: SoftIconButton(
              icon: PhosphorIconsFill.whatsappLogo,
              color: AppColors.whatsapp,
              size: 40,
              tooltip: 'Chat with Umrah Advisor',
              onTap: _chatWithUmrahGuide,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => provider.fetchPackages(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xs),
                      child: FilterChipRail(
                        labels: filters,
                        index: _selectedFilter,
                        onChanged: (i) => setState(() => _selectedFilter = i),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.page,
                      AppSpacing.sm,
                      AppSpacing.page,
                      AppSpacing.xxxl,
                    ),
                    sliver: _content(provider, filteredPackages),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(UmrahProvider provider, List dynamicList) {
    if (provider.isLoading && provider.packages.isEmpty) {
      return const SliverToBoxAdapter(
        child: Column(
          children: [
            PhotoCardSkeleton(imageHeight: 180),
            PhotoCardSkeleton(imageHeight: 180),
          ],
        ),
      );
    }

    if (provider.errorMessage != null && provider.packages.isEmpty) {
      return SliverToBoxAdapter(
        child: FeatureStatePanel(
          icon: PhosphorIconsRegular.warningCircle,
          title: context.pick("Couldn't load packages", "প্যাকেজ লোড করা যায়নি"),
          message: provider.errorMessage!,
          actionLabel: context.pick('Try again', 'আবার চেষ্টা করুন'),
          isError: true,
          onAction: () => provider.fetchPackages(),
        ),
      );
    }

    if (provider.packages.isEmpty) {
      return SliverToBoxAdapter(
        child: FeatureStatePanel(
          icon: PhosphorIconsRegular.mosque,
          title: context.pick('No packages available', 'বর্তমানে কোনো প্যাকেজ নেই'),
          message: context.pick(
            'Pull down to refresh, or message our Umrah concierge on WhatsApp.',
            'নতুন প্যাকেজের জন্য নিচে টেনে রিফ্রেশ করুন অথবা হোয়াটসঅ্যাপে যোগাযোগ করুন।',
          ),
          actionLabel: context.pick('Chat on WhatsApp', 'হোয়াটসঅ্যাপে জানুন'),
          onAction: _chatWithUmrahGuide,
        ),
      );
    }

    final packagesToShow = dynamicList.isNotEmpty ? dynamicList : provider.packages;

    return SliverList.builder(
      itemCount: packagesToShow.length,
      itemBuilder: (context, index) {
        return FadeSlideIn(
          key: ValueKey(packagesToShow[index].id),
          index: index,
          child: UmrahCard(package: packagesToShow[index]),
        );
      },
    );
  }
}
