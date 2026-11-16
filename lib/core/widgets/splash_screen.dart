import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../constants/app_design.dart';
import '../l10n/app_locale.dart';
import '../l10n/app_text.dart';
import 'language_screen.dart';
import '../../features/navigation/presentation/main_nav_screen.dart';

/// First thing the app shows: the mark draws itself in over a navy field,
/// then hands over to the language picker (first run) or straight to the app.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1900),
  );

  late final Animation<double> _markScale = Tween<double>(begin: 0.78, end: 1.0)
      .animate(CurvedAnimation(parent: _c, curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack)));
  late final Animation<double> _markFade = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.0, 0.32, curve: Curves.easeOut),
  );
  late final Animation<double> _wordFade = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
  );
  late final Animation<double> _glow = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
  );

  @override
  void initState() {
    super.initState();
    _c.forward();
    _c.addStatusListener(_onDone);
  }

  void _onDone(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) return;
    final locale = context.read<LocaleProvider>();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 520),
        pageBuilder: (_, _, _) =>
            locale.hasChosen ? const MainNavScreen() : const LanguageScreen(firstRun: true),
        transitionsBuilder: (_, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _c.removeStatusListener(_onDone);
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: AppDecor.hero,
        child: SizedBox.expand(
          child: AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Gold halo that breathes outward behind the mark.
                  Opacity(
                    opacity: 0.5 * _glow.value,
                    child: Container(
                      width: 240 + 90 * _glow.value,
                      height: 240 + 90 * _glow.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.secondary.withValues(alpha: 0.42),
                            AppColors.secondary.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: _markFade,
                        child: ScaleTransition(
                          scale: _markScale,
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppRadius.xl),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 36,
                                  offset: const Offset(0, 14),
                                ),
                              ],
                            ),
                            child: Image.asset(
                              AppAssets.logo,
                              width: 128,
                              fit: BoxFit.contain,
                              errorBuilder: (_, _, _) => const Icon(
                                Icons.flight_takeoff_rounded,
                                size: 64,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      FadeTransition(
                        opacity: _wordFade,
                        child: Column(
                          children: [
                            Container(
                              width: 44,
                              height: 3,
                              decoration: BoxDecoration(
                                gradient: AppColors.goldGradient,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              context.tr('splash.tagline'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.88),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Progress hairline pinned near the bottom.
                  Positioned(
                    bottom: 64,
                    child: FadeTransition(
                      opacity: _wordFade,
                      child: SizedBox(
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: _c.value,
                            minHeight: 3,
                            backgroundColor: Colors.white.withValues(alpha: 0.16),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
