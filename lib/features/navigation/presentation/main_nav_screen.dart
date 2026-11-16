import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/app_text.dart';
import '../../auth/presentation/screens/profile_screen.dart';
import '../../deals/presentation/screens/deals_screen.dart';
import '../../home/presentation/screens/home_screen.dart';
import '../../notifications/presentation/screens/notifications_screen.dart';
import '../../support/presentation/screens/support_screen.dart';
import 'premium_nav_bar.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _switching = false;

  // Drives the fade-through between tabs: the outgoing screen dips away,
  // the incoming one rises into place. The screens themselves stay mounted
  // in the IndexedStack, so scroll positions and loaded data survive.
  late final AnimationController _fade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 210),
    value: 1,
  );

  late final Animation<double> _curve = CurvedAnimation(
    parent: _fade,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );

  @override
  void dispose() {
    _fade.dispose();
    super.dispose();
  }

  Future<void> _onTabTapped(int index) async {
    if (index == _currentIndex || _switching) return;
    _switching = true;
    HapticFeedback.selectionClick();

    await _fade.reverse();
    if (!mounted) return;
    setState(() => _currentIndex = index);
    await _fade.forward();
    _switching = false;
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onTabChange: _onTabTapped),
      const DealsScreen(),
      const SupportScreen(),
      NotificationsScreen(onNavigateTab: _onTabTapped),
      const ProfileScreen(),
    ];

    // Home opens on a photographic hero, while all other pages are white.
    final lightStatusBar = _currentIndex == 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: lightStatusBar ? Brightness.light : Brightness.dark,
        statusBarBrightness: lightStatusBar ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: FadeTransition(
          opacity: _curve,
          child: AnimatedBuilder(
            animation: _curve,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, 10 * (1 - _curve.value)),
              child: child,
            ),
            child: IndexedStack(index: _currentIndex, children: screens),
          ),
        ),
        bottomNavigationBar: PremiumNavBar(
          currentIndex: _currentIndex >= kNavDestinations.length ? 4 : _currentIndex,
          onTap: _onTabTapped,
          destinations: kNavDestinations,
          label: context.tr,
        ),
      ),
    );
  }
}
