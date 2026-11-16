import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_design.dart';
import '../constants/app_icons.dart';
import '../l10n/app_locale.dart';
import '../l10n/app_text.dart';
import 'motion.dart';
import 'premium.dart';
import '../../features/navigation/presentation/main_nav_screen.dart';

/// Language picker. Shown once on first launch, and reachable later from the
/// help centre — [firstRun] decides whether it continues into the app or pops.
class LanguageScreen extends StatefulWidget {
  final bool firstRun;

  const LanguageScreen({super.key, this.firstRun = false});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  AppLanguage? _pending;

  @override
  void initState() {
    super.initState();
    _pending = context.read<LocaleProvider>().language;
  }

  void _apply() {
    final choice = _pending ?? AppLanguage.english;
    context.read<LocaleProvider>().select(choice);

    if (widget.firstRun) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 460),
          pageBuilder: (_, _, _) => const MainNavScreen(),
          transitionsBuilder: (_, animation, _, child) {
            final curved = CurvedAnimation(parent: animation, curve: AppMotion.emphasized);
            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween(begin: const Offset(0, 0.04), end: Offset.zero).animate(curved),
                child: child,
              ),
            );
          },
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
              if (!widget.firstRun)
                Align(
                  alignment: Alignment.centerLeft,
                  child: SoftIconButton(
                    icon: PhosphorIconsBold.arrowLeft,
                    size: 42,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              const SizedBox(height: AppSpacing.xxl),
              FadeSlideIn(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    PhosphorIconsFill.translate,
                    color: AppColors.primaryDark,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              FadeSlideIn(
                index: 1,
                child: Text(
                  context.tr('lang.title'),
                  style: const TextStyle(
                    fontSize: 28,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              FadeSlideIn(
                index: 2,
                child: Text(
                  context.tr('lang.subtitle'),
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.45,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              for (var i = 0; i < AppLanguage.values.length; i++)
                FadeSlideIn(
                  index: 3 + i,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _LanguageTile(
                      language: AppLanguage.values[i],
                      selected: _pending == AppLanguage.values[i],
                      onTap: () => setState(() => _pending = AppLanguage.values[i]),
                    ),
                  ),
                ),
              const Spacer(),
              FadeSlideIn(
                index: 5,
                child: PremiumButton(
                  label: context.tr('lang.continue'),
                  icon: PhosphorIconsBold.arrowRight,
                  trailingIcon: true,
                  onPressed: _apply,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final AppLanguage language;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.base,
        curve: AppMotion.emphasized,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected ? AppShadows.medium : AppShadows.soft,
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.primarySubtle,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Center(
                child: Text(
                  language == AppLanguage.bangla ? 'অ' : 'A',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: selected ? Colors.white : AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.nativeName,
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    language.englishName,
                    style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            AnimatedScale(
              duration: AppMotion.fast,
              scale: selected ? 1 : 0.6,
              child: AnimatedOpacity(
                duration: AppMotion.fast,
                opacity: selected ? 1 : 0,
                child: Icon(
                  PhosphorIconsFill.checkCircle,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
