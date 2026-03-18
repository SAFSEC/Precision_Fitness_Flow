import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'data/models/workout_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(WorkoutSessionAdapter());
  
  // Open necessary boxes, e.g., 'history'
  await Hive.openBox<WorkoutSession>('history');

  runApp(
    const ProviderScope(
      child: PrecisionFitnessFlowApp(),
    ),
  );
}
