import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_durations.dart';
import '../../data/models/timer_state.dart';
import '../../data/models/training_day.dart';
import '../../widgets/safety_hint_banner.dart';
import 'workout_controller.dart';
import '../../core/services/timer_service.dart';

class StrengthView extends ConsumerWidget {
  final TrainingDay trainingDay;

  const StrengthView({super.key, required this.trainingDay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerServiceProvider);
    final workoutController = ref.read(workoutControllerProvider(trainingDay).notifier);

    // Initial state handling or Rest state
    if (timerState.phase == TimerPhase.idle || timerState.phase == TimerPhase.rest) {
      // In strength training, the active phase is un-timed (user doing reps).
      return _buildActiveStrengthSet(context, timerState, workoutController);
    } 

    return const Center(child: Text("Strength Training"));
  }

  Widget _buildActiveStrengthSet(BuildContext context, TimerState timerState, WorkoutController workoutController) {
    final currentExerciseIndex = (timerState.currentSetIndex - 1) ~/ 3; // Integer division: assuming 3 sets per exercise based on PRD plan.
    if (currentExerciseIndex >= trainingDay.exercises.length) {
       // Completed all exercises
       return const Center(
          child: Text('Training abgeschlossen!', style: TextStyle(color: kColorText, fontSize: 24)),
       );
    }
    
    final currentExercise = trainingDay.exercises[currentExerciseIndex];
    final currentSetInExercise = ((timerState.currentSetIndex - 1) % 3) + 1;

    final isResting = timerState.phase == TimerPhase.rest;

    return Column(
      children: [
        const SizedBox(height: 24),
        
        if (currentExercise.imageAssetPath != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              currentExercise.imageAssetPath!,
              height: 140,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
        ],

        Text(
          currentExercise.name,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: kColorText),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          currentExercise.focus.map((e) => e.name).join(', ').toUpperCase(),
          style: const TextStyle(color: kColorTextMuted, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 32),
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: kColorSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kColorRest, width: 2),
          ),
          child: Text(
            'Satz $currentSetInExercise von 3',
            style: const TextStyle(fontSize: 20, color: kColorText),
          ),
        ),

        const SizedBox(height: 24),

        if (isResting) ...[
          const Text('Pause', style: TextStyle(fontSize: 24, color: kColorTextMuted)),
          const SizedBox(height: 8),
          Text(
            '${timerState.remainingSeconds}',
            style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: kColorRest),
          ),
        ] else ...[
          // Show execution hints when active
          Text(
            currentExercise.executionHint,
            style: const TextStyle(fontSize: 16, color: kColorTextMuted),
            textAlign: TextAlign.center,
          ),
          
          if (currentExercise.isPlyometric && currentExercise.safetyHint != null) ...[
            const SizedBox(height: 16),
            SafetyHintBanner(safetyHint: currentExercise.safetyHint!),
          ],
        ],

        const Spacer(),

        if (isResting)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kColorSurface,
              foregroundColor: kColorText,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => workoutController.skipPhase(),
            child: const Text('Pause überspringen'),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Führe die Übung ohne Zeitdruck aus.\nKlicke hier, wenn du fertig bist.',
                textAlign: TextAlign.center,
                style: TextStyle(color: kColorTextMuted, fontSize: 12),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kColorAccent,
                  foregroundColor: kColorText,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                   // Assuming 3 sets * exercise length sets total
                   final totalSets = trainingDay.exercises.length * 3;
                   final isLastSet = timerState.currentSetIndex == totalSets;
                   
                   if (isLastSet) {
                     workoutController.cancelWorkout(); // Finishes workout
                   } else {
                     final restDuration = trainingDay.week == 3 ? kStrengthRestWeek3 : kStrengthRestSeconds;
                     workoutController.startStrengthRest(restDuration, timerState.currentSetIndex + 1, totalSets);
                   }
                },
                child: const Text('Satz abgeschlossen – Pause starten', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          
        const SizedBox(height: 24),
      ],
    );
  }
}
