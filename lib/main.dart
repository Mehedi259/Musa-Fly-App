import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_theme.dart';
import 'features/deals/presentation/providers/deal_provider.dart';
import 'features/flights/presentation/providers/flight_provider.dart';
import 'features/navigation/presentation/main_nav_screen.dart';
import 'features/support/presentation/providers/support_provider.dart';
import 'features/tours/presentation/providers/tour_provider.dart';
import 'features/umrah/presentation/providers/umrah_provider.dart';
import 'features/visas/presentation/providers/visa_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MusaFlyApp());
}

class MusaFlyApp extends StatelessWidget {
  const MusaFlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlightProvider()),
        ChangeNotifierProvider(create: (_) => TourProvider()),
        ChangeNotifierProvider(create: (_) => UmrahProvider()),
        ChangeNotifierProvider(create: (_) => VisaProvider()),
        ChangeNotifierProvider(create: (_) => DealProvider()),
        ChangeNotifierProvider(create: (_) => SupportProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavScreen(),
      ),
    );
  }
}
