import 'package:flutter/material.dart';

import 'app_providers.dart';
import 'theme/app_theme.dart';
import 'views/residents_view.dart';

class CareCircleApp extends StatelessWidget {
  const CareCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp(
        title: 'CareCircle',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        home: const ResidentsView(),
      ),
    );
  }
}
