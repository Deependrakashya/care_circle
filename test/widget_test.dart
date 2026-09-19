import 'package:care_circle/app.dart';
import 'package:care_circle/data/repositories/resident_repository.dart';
import 'package:care_circle/view_models/residents_view_model.dart';
import 'package:care_circle/views/residents_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'support/fixtures.dart';

void main() {
  testWidgets(
    'real Provider wiring loads fixtures and updates resident selection',
    (tester) async {
      await tester.pumpWidget(const CareCircleApp());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.text('Meera Kapoor'), findsOneWidget);
      expect(find.text('Devendra Kapoor'), findsOneWidget);
      expect(find.text('Selected: Meera Kapoor'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('resident-devendra')));
      await tester.pumpAndSettle();
      
      // We are now on the Resident Detail screen. It should show the title.
      expect(find.descendant(of: find.byType(AppBar), matching: find.text('Devendra Kapoor')), findsOneWidget);
      
      // Go back to the residents list
      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Refresh relatives'));
      await tester.pumpAndSettle(const Duration(seconds: 1));
      
      // The selection is remembered in the view model, and the text might still be there.
      expect(find.text('Selected: Devendra Kapoor'), findsOneWidget);
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
          child: const MaterialApp(home: ResidentsView()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Try again'), findsOneWidget);
      expect(find.textContaining('private payload'), findsNothing);
      fail = false;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(find.text('No relatives are available yet.'), findsOneWidget);
      expect(find.text('Try again'), findsNothing);
    },
  );
}
