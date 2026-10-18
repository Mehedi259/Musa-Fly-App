import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../core/widgets/section_title.dart';
import '../providers/support_provider.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  int? _expandedFaqId;

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Care & Support'),
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchSupportData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Channels Hero Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF204D90), Color(0xFF132E56)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
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
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.headset_mic_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Need Assistance?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '24/7 dedicated travel support concierge',
                                style: TextStyle(fontSize: 12, color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => UrlHelper.launchWhatsApp(),
                            icon: const Icon(Icons.chat_bubble_rounded, size: 18),
                            label: const Text('WhatsApp'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.whatsapp,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => UrlHelper.makePhoneCall(AppStrings.phone),
                            icon: const Icon(Icons.phone_rounded, size: 18),
                            label: const Text('Call Us'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Contact Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildContactItem(
                      Icons.location_on_rounded,
                      'Main Office',
                      AppStrings.address,
                      onTap: () {},
                    ),
                    const Divider(height: 20),
                    _buildContactItem(
                      Icons.mail_outline_rounded,
                      'Email Inquiry',
                      AppStrings.email,
                      onTap: () => UrlHelper.sendEmail(AppStrings.email),
                    ),
                    const Divider(height: 20),
                    _buildContactItem(
                      Icons.language_rounded,
                      'Official Website',
                      'www.musafly.com',
                      onTap: () => UrlHelper.openWeb(AppStrings.websiteUrl),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Frequently Asked Questions Section
              const SectionTitle(
                title: 'Frequently Asked Questions',
                subtitle: 'Find answers about bookings, visas and cancellations',
              ),

              const SizedBox(height: 8),

              // FAQs Category Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    _buildFaqCategoryChip('all', 'All FAQs', provider),
                    _buildFaqCategoryChip('flights', 'Flights', provider),
                    _buildFaqCategoryChip('tours', 'Tours', provider),
                    _buildFaqCategoryChip('visa', 'Visa', provider),
                    _buildFaqCategoryChip('general', 'General', provider),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // FAQs List
              if (provider.faqs.isEmpty && provider.isLoading) ...[
                const Center(child: CircularProgressIndicator()),
              ] else ...[
                ...provider.faqs
                    .where((faq) =>
                        provider.selectedCategory == 'all' ||
                        faq.category.toLowerCase() == provider.selectedCategory.toLowerCase())
                    .map((faq) => _buildFaqTile(faq)),
              ],

              const SizedBox(height: 28),

              // Customer Testimonials
              if (provider.testimonials.isNotEmpty) ...[
                const SectionTitle(
                  title: 'Client Experiences',
                  subtitle: 'Real stories from travelers around the globe',
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.testimonials.length,
                    itemBuilder: (ctx, i) {
                      final item = provider.testimonials[i];
                      return Container(
                        width: 280,
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppColors.primarySubtle,
                                  child: Text(
                                    item.name.isNotEmpty ? item.name[0] : 'U',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      Text(item.location, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: List.generate(
                                    item.rating,
                                    (_) => const Icon(Icons.star_rounded, size: 14, color: AppColors.secondary),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Text(
                                '"${item.text}"',
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String subtitle, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primarySubtle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqCategoryChip(String category, String label, SupportProvider provider) {
    final isSelected = provider.selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
        onSelected: (_) => provider.setSelectedCategory(category),
      ),
    );
  }

  Widget _buildFaqTile(dynamic faq) {
    final isExpanded = _expandedFaqId == faq.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isExpanded ? AppColors.primary : AppColors.border,
          width: isExpanded ? 1.4 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          setState(() {
            _expandedFaqId = isExpanded ? null : faq.id;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      faq.question,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isExpanded ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: isExpanded ? AppColors.primary : AppColors.textMuted,
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 10),
                Text(
                  faq.answer,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
