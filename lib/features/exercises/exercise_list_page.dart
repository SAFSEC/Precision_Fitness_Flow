import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../data/workout_plan.dart';
import '../../data/models/exercise.dart';

class ExerciseListPage extends StatelessWidget {
  const ExerciseListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Übungsbibliothek', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: kExercises.length,
        itemBuilder: (context, index) {
          final exercise = kExercises[index];
          
          Color typeColor = kColorWork;
          IconData iconData = Icons.fitness_center;
          String typeLabel = '';
          
          switch (exercise.type) {
            case ExerciseType.strength:
              typeColor = kColorWork;
              iconData = Icons.fitness_center;
              typeLabel = 'Kraft';
              break;
            case ExerciseType.metabolic:
              typeColor = kColorTransition;
              iconData = Icons.bolt;
              typeLabel = 'Metabolisch';
              break;
            case ExerciseType.hiit:
              typeColor = kColorAccent;
              iconData = Icons.local_fire_department;
              typeLabel = 'HIIT';
              break;
          }

          return Card(
            color: kColorSurface,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.white12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: exercise.imageAssetPath != null 
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(exercise.imageAssetPath!, fit: BoxFit.cover),
                    )
                  : Icon(iconData, color: typeColor, size: 24),
              ),
              title: Text(
                exercise.name,
                style: const TextStyle(
                  color: kColorText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        typeLabel,
                        style: TextStyle(
                          color: typeColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (exercise.isPlyometric) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: kColorSafetyHint.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Plyo',
                          style: TextStyle(
                            color: kColorSafetyHint,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: kColorTextMuted),
              onTap: () {
                context.push('/exercises/${exercise.id}');
              },
            ),
          );
        },
      ),
    );
  }
}
