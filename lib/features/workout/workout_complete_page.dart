import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class WorkoutCompletePage extends StatelessWidget {
  final String dayId;
  const WorkoutCompletePage({super.key, required this.dayId});

  @override
  Widget build(BuildContext context) {
    // Scaffold without AppBar according to PRD layout rules
    return Scaffold(
      backgroundColor: kColorBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              
              const Icon(
                Icons.check_circle_outline,
                color: kColorAccent,
                size: 120,
              ),
              
              const SizedBox(height: 32),
              
              const Text(
                'Training\nabgeschlossen!',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: kColorText,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                'Hervorragende Arbeit. Erholung ist jetzt wichtig.',
                style: TextStyle(
                  fontSize: 16,
                  color: kColorTextMuted,
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
              
              // Action Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kColorAccent,
                  foregroundColor: kColorText,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: in Phase 6 we will save via Hive HistoryService here
                  // Navigate back to Home
                  context.go('/');
                },
                child: const Text(
                  'Zurück zur Übersicht',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
