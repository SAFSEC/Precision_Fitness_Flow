import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/constants/app_colors.dart';

class PrecisionFitnessFlowApp extends StatelessWidget {
  const PrecisionFitnessFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Precision Fitness & Flow',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kColorBackground,
        colorScheme: const ColorScheme.dark(
          primary: kColorAccent,
          surface: kColorSurface,
        ),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
