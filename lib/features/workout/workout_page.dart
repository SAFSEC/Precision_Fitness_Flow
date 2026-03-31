import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/timer_state.dart';
import '../../data/models/training_day.dart';
import '../../core/providers/active_program_provider.dart';
import '../../core/services/timer_service.dart';
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
    
    final activeProgram = ref.read(activeProgramProvider);
    
    _trainingDay = activeProgram.days.firstWhere(
      (day) => day.id == widget.dayId,
      orElse: () => activeProgram.days.first,
    );

    // Auto-start workout safely after build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(workoutControllerProvider(_trainingDay).notifier).startWorkout();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Direkt auf Timer-Completion hören – zuverlässiger als die 2-Stufen-Kette
    ref.listen<TimerState>(timerServiceProvider, (previous, next) {
      if (next.phase == TimerPhase.completed &&
          previous?.phase != TimerPhase.completed) {
        context.go('/workout/${widget.dayId}/complete');
      }
    });

    Widget activeView;
    if (_trainingDay.type == 'hiit') {
      activeView = HiitView(trainingDay: _trainingDay);
    } else if (_trainingDay.type == 'strength' || _trainingDay.type == 'strengthA' || _trainingDay.type == 'strengthB') {
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
