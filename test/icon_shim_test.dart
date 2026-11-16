import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musa_fly_app/core/constants/app_icons.dart';
import 'package:musa_fly_app/core/widgets/premium.dart';

void main() {
  testWidgets('phosphor shim icons render', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              Icon(PhosphorIconsRegular.airplaneTilt),
              Icon(PhosphorIconsFill.house),
              Icon(PhosphorIconsDuotone.mosque),
              Icon(PhosphorIconsBold.caretRight),
              const ToneChip(label: 'Non-stop', tone: ChipTone.success),
              PremiumButton(label: 'Search', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
    expect(find.byType(Icon), findsAtLeast(4));
    expect(find.text('Search'), findsOneWidget);
  });
}
