import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

import '../../deals/presentation/screens/deals_screen.dart';
import '../../flights/presentation/screens/flights_screen.dart';
import '../../home/presentation/screens/home_screen.dart';
import '../../support/presentation/screens/support_screen.dart';
import '../../umrah/presentation/screens/umrah_screen.dart';
import '../../visas/presentation/screens/visa_screen.dart';
import 'premium_nav_bar.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onTabChange: _onTabTapped),
      const FlightsScreen(),
      const UmrahScreen(),
      const VisaScreen(),
      const DealsScreen(),
      const SupportScreen(),
    ];

    // Every tab but Flights opens on a navy hero, so the status bar needs
    // light glyphs there and dark ones over the Flights screen's white bar.
    // Setting it here keeps the clock readable no matter which tab is shown;
    // pushed screens override it with their own AnnotatedRegion.
    final lightStatusBar = _currentIndex != 1;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: lightStatusBar ? Brightness.light : Brightness.dark,
        statusBarBrightness: lightStatusBar ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        extendBody: true,
        // IndexedStack keeps each tab's scroll position and loaded data.
        body: IndexedStack(index: _currentIndex, children: screens),
        bottomNavigationBar: PremiumNavBar(
          currentIndex: _currentIndex >= kNavDestinations.length ? 4 : _currentIndex,
          onTap: _onTabTapped,
          destinations: kNavDestinations,
        ),
      ),
    );
  }
}
