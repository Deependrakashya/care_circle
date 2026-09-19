import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'data/api/care_circle_api.dart';
import 'data/api/mock_care_circle_api.dart';
import 'data/repositories/care_event_repository.dart';
import 'data/repositories/check_in_repository.dart';
import 'data/repositories/daily_summary_repository.dart';
import 'data/repositories/resident_repository.dart';
import 'data/repositories/staff_update_repository.dart';
import 'data/repositories/vital_repository.dart';
import 'view_models/residents_view_model.dart';

/// Composition root: only this layer wires the concrete dependencies together.
class AppProviders extends StatelessWidget {
  const AppProviders({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CareCircleApi>(create: (_) => MockCareCircleApi()),
        Provider<ResidentRepository>(
          create: (context) =>
              ApiResidentRepository(context.read<CareCircleApi>()),
        ),
        Provider<DailySummaryRepository>(
          create: (context) =>
              ApiDailySummaryRepository(context.read<CareCircleApi>()),
        ),
        Provider<CareEventRepository>(
          create: (context) =>
              ApiCareEventRepository(context.read<CareCircleApi>()),
        ),
        Provider<VitalRepository>(
          create: (context) =>
              ApiVitalRepository(context.read<CareCircleApi>()),
        ),
        Provider<StaffUpdateRepository>(
          create: (context) =>
              ApiStaffUpdateRepository(context.read<CareCircleApi>()),
        ),
        Provider<CheckInRepository>(
          create: (context) =>
              ApiCheckInRepository(context.read<CareCircleApi>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ResidentsViewModel(context.read<ResidentRepository>())
                ..loadResidents(),
        ),
      ],
      child: child,
    );
  }
}
