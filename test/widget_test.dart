import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:care_circle/app.dart';
import 'package:care_circle/views/root_view.dart';
import 'package:care_circle/widgets/resident_header.dart';
import 'package:care_circle/data/repositories/resident_repository.dart';
import 'package:care_circle/view_models/residents_view_model.dart';
import 'package:provider/provider.dart';

import 'support/fixtures.dart';

void main() {
  testWidgets(
    'real Provider wiring loads fixtures and updates resident selection',
    (tester) async {
      await tester.pumpWidget(const CareCircleApp());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      
      // Initially, Meera Kapoor is selected and shown in ResidentDetailView
      expect(find.descendant(of: find.byType(ResidentHeader), matching: find.text('Meera Kapoor')), findsWidgets);
      
      // Tap the header to open the picker sheet
      await tester.tap(find.byType(ResidentHeader).first);
      await tester.pumpAndSettle();
      
      // In the picker sheet, we should see Devendra Kapoor
      expect(find.text('Devendra Kapoor'), findsOneWidget);
      
      // Tap Devendra Kapoor to select
      await tester.tap(find.byKey(const ValueKey('resident-devendra')));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      
      // The sheet should close, and we are back on ResidentDetailView for Devendra
      expect(find.descendant(of: find.byType(ResidentHeader), matching: find.text('Devendra Kapoor')), findsWidgets);
      
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'view displays safe error, retry and empty state from view model',
    (tester) async {
      var fail = true;
      final repository = ApiResidentRepository(
        StubApi(() async {
          if (fail) throw Exception('private payload');
          return residentResponse()..['data'] = [];
        }),
      );
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => ResidentsViewModel(repository)..loadResidents(),
          child: const MaterialApp(home: RootView()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Try again'), findsOneWidget);
      expect(find.textContaining('private payload'), findsNothing);
      fail = false;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.text('No relatives are available in CareCircle right now.'), findsOneWidget);
      expect(find.text('Try again'), findsNothing);
    },
  );
}
