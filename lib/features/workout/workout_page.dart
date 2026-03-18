import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../data/workout_plan.dart';
import '../../data/models/training_day.dart';
import 'hiit_view.dart';
import 'strength_view.dart';
import 'workout_controller.dart';

class WorkoutPage extends ConsumerStatefulWidget {
  final String dayId;
  const WorkoutPage({super.key, required this.dayId});

  @override
  ConsumerState<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends ConsumerState<WorkoutPage> {
  late TrainingDay _trainingDay;

  @override
  void initState() {
    super.initState();
    
    _trainingDay = kWorkoutPlan.firstWhere(
      (day) => day.id == widget.dayId,
      orElse: () => kWorkoutPlan.first,
    );

    // Auto-start workout safely after build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(workoutControllerProvider(_trainingDay).notifier).startWorkout();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen to workout conclusion (isFinished == true)
    ref.listen<bool>(workoutControllerProvider(_trainingDay), (previous, isFinished) {
      if (isFinished) {
        context.go('/workout/${widget.dayId}/complete');
      }
    });

    Widget activeView;
    if (_trainingDay.type == 'hiit') {
      activeView = HiitView(trainingDay: _trainingDay);
    } else if (_trainingDay.type == 'strengthA' || _trainingDay.type == 'strengthB') {
      activeView = StrengthView(trainingDay: _trainingDay);
    } else {
      // Rest day: Shouldn't conventionally reach WorkoutPage, but graceful fallback
      activeView = _buildRestDayView(context);
    }

    return Scaffold(
      backgroundColor: kColorBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: kColorTextMuted),
          onPressed: () {
            ref.read(workoutControllerProvider(_trainingDay).notifier).cancelWorkout();
            context.go('/');
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: activeView,
        ),
      ),
    );
  }
  
  Widget _buildRestDayView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Regeneration',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: kColorText),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        const Text(
          'Heute ist ein Ruhetag. Empfehlung: Stretching oder Tai-Chi.',
          style: TextStyle(fontSize: 16, color: kColorTextMuted),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: kColorAccent, foregroundColor: kColorText),
          onPressed: () => context.go('/'),
          child: const Text('Zurück', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
