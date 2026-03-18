import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/workout_plan.dart';
import '../../data/models/exercise.dart';

class ExerciseDetailPage extends StatelessWidget {
  final String exerciseId;
  const ExerciseDetailPage({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    // Find exercise by id
    final exercise = kExercises.firstWhere(
      (e) => e.id == exerciseId,
      orElse: () => kExercises.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image (if available)
            if (exercise.imageAssetPath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  exercise.imageAssetPath!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
            ],

            // English Name
            Text(
              exercise.nameEn,
              style: const TextStyle(
                color: kColorTextMuted,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),

            // Type and Muscle Focus Row
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTag(
                  _getTypeLabel(exercise.type),
                  _getTypeColor(exercise.type),
                ),
                ...exercise.focus.map((muscle) => _buildTag(
                  _getMuscleLabel(muscle),
                  kColorSurface,
                  borderColor: Colors.white24,
                  textColor: kColorText,
                )),
              ],
            ),
            const SizedBox(height: 32),

            // Execution hints
            const Text(
              'Ausführung',
              style: TextStyle(
                color: kColorText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kColorSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: Text(
                exercise.executionHint,
                style: const TextStyle(
                  color: kColorText,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),

            // Safety Hint (if any)
            if (exercise.safetyHint != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kColorSafetyHint.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kColorSafetyHint.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: kColorSafetyHint,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Gelenkschutz',
                            style: TextStyle(
                              color: kColorSafetyHint,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            exercise.safetyHint!,
                            style: const TextStyle(
                              color: kColorText,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color bgColor, {Color? borderColor, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(borderColor == null ? 0.2 : 1.0),
        borderRadius: BorderRadius.circular(20),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? bgColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  String _getTypeLabel(ExerciseType type) {
    switch (type) {
      case ExerciseType.strength: return 'Kraft';
      case ExerciseType.metabolic: return 'Metabolisch';
      case ExerciseType.hiit: return 'HIIT';
    }
  }

  Color _getTypeColor(ExerciseType type) {
    switch (type) {
      case ExerciseType.strength: return kColorWork;
      case ExerciseType.metabolic: return kColorTransition;
      case ExerciseType.hiit: return kColorAccent;
    }
  }

  String _getMuscleLabel(MuscleGroup group) {
    switch (group) {
      case MuscleGroup.chest: return 'Brust';
      case MuscleGroup.shoulders: return 'Schultern';
      case MuscleGroup.triceps: return 'Trizeps';
      case MuscleGroup.lowerBody: return 'Beine';
      case MuscleGroup.core: return 'Core';
      case MuscleGroup.fullBody: return 'Ganzkörper';
    }
  }
}
