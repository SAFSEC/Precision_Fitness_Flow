import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/active_program_provider.dart';
import '../../core/services/history_service.dart';
import '../../data/models/workout_session.dart';

class WorkoutCompletePage extends ConsumerStatefulWidget {
  final String dayId;
  const WorkoutCompletePage({super.key, required this.dayId});

  @override
  ConsumerState<WorkoutCompletePage> createState() => _WorkoutCompletePageState();
}

class _WorkoutCompletePageState extends ConsumerState<WorkoutCompletePage> {
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    // Save the session automatically on entry
    _saveWorkout();
  }

  Future<void> _saveWorkout() async {
    if (_isSaved) return;

    final activeProgram = ref.read(activeProgramProvider);
    final trainingDay = activeProgram.days.firstWhere(
      (d) => d.id == widget.dayId,
      orElse: () => activeProgram.days.first,
    );

    // Create a new session object
    final session = WorkoutSession(
      workoutId: widget.dayId,
      completedAt: DateTime.now(),
      durationSeconds: 15 * 60, // Default to 15 mins for now, could be dynamic
      completed: true,
      week: trainingDay.week,
      dayOfWeek: trainingDay.dayOfWeek ?? 1,
    );

    await ref.read(historyServiceProvider.notifier).saveSession(session);
    
    if (mounted) {
      setState(() {
        _isSaved = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                color: kColorWork,
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
