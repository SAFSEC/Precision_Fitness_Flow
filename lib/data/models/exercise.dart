enum ExerciseType { strength, metabolic, hiit }
enum MuscleGroup { chest, shoulders, triceps, lowerBody, core, fullBody }

class Exercise {
  final String id;
  final String name;
  final String nameEn;
  final ExerciseType type;
  final List<MuscleGroup> focus;
  final String executionHint;
  final String? safetyHint;
  final bool isPlyometric;
  final String? imageAssetPath;

  const Exercise({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.type,
    required this.focus,
    required this.executionHint,
    this.safetyHint,
    required this.isPlyometric,
    this.imageAssetPath,
  });
}
