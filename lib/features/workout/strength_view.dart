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

    if (timerState.phase == TimerPhase.idle || timerState.phase == TimerPhase.rest) {
      return _buildActiveStrengthSet(context, timerState, workoutController);
    } 

    return const Center(child: Text("Strength Training"));
  }

  Widget _buildActiveStrengthSet(BuildContext context, TimerState timerState, WorkoutController workoutController) {
    if (trainingDay.steps.isEmpty) {
        return const Center(
          child: Text('Keine Übungen an diesem Tag!', style: TextStyle(color: kColorTextMuted, fontSize: 18)),
        );
    }

    final steps = trainingDay.steps;
    int currentStepIndex = 0;
    int currentSetInStep = 1;
    int totalSets = 0;
    
    // Calculate global total sets
    for (var step in steps) {
      totalSets += (step.sets ?? 3);
    }

    // Calculate which step and which set we are currently on based on global currentSetIndex
    int setsPassed = 0;
    for (int i = 0; i < steps.length; i++) {
      int setsForThisStep = steps[i].sets ?? 3;
      if (timerState.currentSetIndex <= setsPassed + setsForThisStep) {
        currentStepIndex = i;
        currentSetInStep = timerState.currentSetIndex - setsPassed;
        break;
      }
      setsPassed += setsForThisStep;
    }

    if (timerState.currentSetIndex > totalSets) {
       return const Center(
          child: Text('Training abgeschlossen!', style: TextStyle(color: kColorText, fontSize: 24)),
       );
    }
    
    final currentStep = steps[currentStepIndex];
    final currentExercise = currentStep.exercise;
    final isResting = timerState.phase == TimerPhase.rest;
    
    // Metadata display strings
    final setsStr = currentStep.sets ?? 3;
    final repsStr = currentStep.reps != null ? "${currentStep.reps} Wiederholungen" : "";
    final durationStr = currentStep.durationSeconds != null ? "${currentStep.durationSeconds} Sekunden halten" : "";
    final metadataDisplay = [repsStr, durationStr].where((s) => s.isNotEmpty).join(' | ');

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

        const SizedBox(height: 24),
        
        if (metadataDisplay.isNotEmpty)
           Text(
             metadataDisplay,
             style: const TextStyle(fontSize: 18, color: kColorAccent, fontWeight: FontWeight.bold),
           ),

        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: kColorSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kColorRest, width: 2),
          ),
          child: Text(
            'Satz $currentSetInStep von $setsStr',
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
              Text(
                currentStep.durationSeconds != null 
                    ? 'Halte die Übung für ${currentStep.durationSeconds} Sekunden.'
                    : 'Führe die Übung sauber aus.\nKlicke hier, wenn du fertig bist.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: kColorTextMuted, fontSize: 12),
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
                   final isLastSet = timerState.currentSetIndex == totalSets;
                   
                   if (isLastSet) {
                     workoutController.cancelWorkout();
                   } else {
                     final defaultRest = trainingDay.week == 3 ? kStrengthRestWeek3 : kStrengthRestSeconds;
                     final restDuration = currentStep.restSeconds ?? defaultRest;
                     workoutController.startStrengthRest(restDuration, timerState.currentSetIndex + 1, totalSets);
                   }
                },
                child: const Text('Satz abgeschlossen – Pause starten', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          
        const SizedBox(height: 24),
      ],
    );
  }
}
