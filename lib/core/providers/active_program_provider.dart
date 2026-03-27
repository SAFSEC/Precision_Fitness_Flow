import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../data/models/workout_program.dart';
import '../../data/workout_plan.dart';

class ActiveProgramNotifier extends StateNotifier<WorkoutProgram> {
  final Box<String> _settingsBox;
  
  ActiveProgramNotifier(this._settingsBox) : super(_loadInitialProgram(_settingsBox));

  static WorkoutProgram _loadInitialProgram(Box<String> box) {
    final savedId = box.get('active_program_id');
    return kAllPrograms.firstWhere(
      (p) => p.id == savedId,
      orElse: () => kProgramHybrid,
    );
  }

  void setProgram(WorkoutProgram program) {
    state = program;
    _settingsBox.put('active_program_id', program.id);
  }
}

final settingsBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>('settings');
});

final activeProgramProvider = StateNotifierProvider<ActiveProgramNotifier, WorkoutProgram>((ref) {
  final box = ref.watch(settingsBoxProvider);
  return ActiveProgramNotifier(box);
});
