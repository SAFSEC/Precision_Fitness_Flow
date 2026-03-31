import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_durations.dart';
import '../../core/services/timer_service.dart';
import '../../data/models/timer_state.dart';
import '../../widgets/chronos_timer_widget.dart';
import '../../widgets/phase_indicator.dart';
import '../../widgets/safety_hint_banner.dart';
import '../../data/models/training_day.dart';
import 'workout_controller.dart';

class HiitView extends ConsumerWidget {
  final TrainingDay trainingDay;

  const HiitView({super.key, required this.trainingDay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerServiceProvider);
    final workoutController = ref.read(workoutControllerProvider(trainingDay).notifier);

    // Runde abgeschlossen → Overlay zeigen
    if (timerState.phase == TimerPhase.roundCompleted) {
      return _buildRoundCompletedOverlay(context, workoutController);
    }

    // Determine max seconds for the current phase for proper progress ring
    int maxSeconds = 0;
    if (timerState.phase == TimerPhase.work) {
      maxSeconds = kHiitWorkSeconds;
    } else if (timerState.phase == TimerPhase.rest) {
      maxSeconds = kHiitRestSeconds;
    } else if (timerState.phase == TimerPhase.transition) {
      maxSeconds = kHiitTransSeconds;
      if (timerState.currentRound == 1 && timerState.remainingSeconds <= kTransitionSeconds) {
         maxSeconds = kTransitionSeconds; // Initial prep delay
      }
    }

    return Column(
      children: [
        const SizedBox(height: 24),
        
        // Header info
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PhaseIndicator(phase: timerState.phase),
            Text(
              'Runde ${timerState.currentRound} / ${timerState.totalRounds}',
              style: const TextStyle(
                color: kColorTextMuted,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        
        const Spacer(),
        
        // Large Chronos Timer Ring
        ChronosTimerWidget(
          timerState: timerState, 
          maxSeconds: maxSeconds,
        ),
        
        const Spacer(),
        
        // Current Exercise
        if (timerState.currentExercise != null) ...[
          if (timerState.currentExercise!.imageAssetPath != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                timerState.currentExercise!.imageAssetPath!,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            timerState.currentExercise!.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: kColorText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            timerState.currentExercise!.executionHint,
            style: const TextStyle(color: kColorTextMuted, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (timerState.currentExercise!.isPlyometric && timerState.currentExercise!.safetyHint != null)
            SafetyHintBanner(safetyHint: timerState.currentExercise!.safetyHint!),
        ] else if (timerState.phase == TimerPhase.transition) ...[
           const Text(
            'Bereit machen!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: kColorText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
        
        const SizedBox(height: 32),
        
        // Next Exercise Preview
        if (timerState.nextExercise != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kColorSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.fitness_center, color: kColorTextMuted, size: 20),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Als nächstes', style: TextStyle(color: kColorTextMuted, fontSize: 12)),
                    Text(
                      timerState.nextExercise!.name,
                      style: const TextStyle(color: kColorText, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
        const SizedBox(height: 24),
        
        // Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(timerState.isRunning ? Icons.pause : Icons.play_arrow),
              color: kColorText,
              iconSize: 32,
              onPressed: () {
                if (timerState.isRunning) {
                  workoutController.pauseWorkout();
                } else {
                  workoutController.resumeWorkout();
                }
              },
            ),
            const SizedBox(width: 32),
            IconButton(
              icon: const Icon(Icons.skip_next),
              color: kColorTextMuted,
              iconSize: 32,
              onPressed: () {
                 workoutController.skipPhase();
              },
            ),
          ],
        ),
        
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRoundCompletedOverlay(BuildContext context, WorkoutController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.emoji_events,
          color: kColorAccent,
          size: 72,
        ),
        const SizedBox(height: 24),
        const Text(
          'Runde abgeschlossen!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: kColorText,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Text(
          'Super Arbeit! Was möchtest du tun?',
          style: TextStyle(fontSize: 16, color: kColorTextMuted),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        ElevatedButton.icon(
          icon: const Icon(Icons.refresh),
          label: const Text(
            'Neustart',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorAccent,
            foregroundColor: kColorText,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => controller.restartRound(),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          icon: const Icon(Icons.check_circle_outline),
          label: const Text(
            'Training beenden',
            style: TextStyle(fontSize: 18),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: kColorTextMuted,
            side: const BorderSide(color: kColorTextMuted),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => controller.completeWorkout(),
        ),
      ],
    );
  }
}
