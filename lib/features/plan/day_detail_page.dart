import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/active_program_provider.dart';

class DayDetailPage extends ConsumerWidget {
  final String dayId;
  const DayDetailPage({super.key, required this.dayId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Find day from the active program
    final activeProgram = ref.watch(activeProgramProvider);
    final day = activeProgram.days.firstWhere(
      (d) => d.id == dayId,
      orElse: () => activeProgram.days.first,
    );

    final isRestDay = day.type == 'rest';

    return Scaffold(
      appBar: AppBar(
        title: Text('Woche ${day.week} / Tag ${day.dayOfWeek}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isRestDay ? 'Regeneration' : (day.type == 'hiit' ? 'HIIT Flow' : 'Kraft-Training'),
              style: const TextStyle(
                color: kColorText,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (isRestDay)
              const ContainerInfoBlock(
                text: 'Heute steht Regeneration auf dem Plan. Gönne deinem Körper Ruhe, mache ein leichtes Stretching oder eine Tai-Chi-Sequenz.',
                icon: Icons.self_improvement,
                color: kColorRest,
              )
            else ...[
              ContainerInfoBlock(
                text: day.type == 'hiit' 
                    ? 'HIIT Flow: Intervalltraining. 30s Belastung, 20s Pause.' 
                    : 'Kraft-Tag: 3 Sätze pro Übung mit Erholungspausen.',
                icon: day.type == 'hiit' ? Icons.timer : Icons.fitness_center,
                color: day.type == 'hiit' ? kColorAccent : kColorWork,
              ),
              const SizedBox(height: 32),
              const Text(
                'Übungen',
                style: TextStyle(
                  color: kColorText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...day.steps.map((step) {
                final exercise = step.exercise;
                return Card(
                  color: kColorSurface,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.white12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      exercise.name,
                      style: const TextStyle(color: kColorText, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        exercise.executionHint,
                        style: const TextStyle(color: kColorTextMuted),
                      ),
                    ),
                    isThreeLine: true,
                  ),
                );
              }).toList(),
            ],
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  if (isRestDay) {
                    // Falls Rest Day -> man kann in V2 abschließen, aktuell einfach Info
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Regenerationstag kann nicht als Training gestartet werden.')),
                    );
                  } else {
                    context.push('/workout/${day.id}');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRestDay ? kColorSurface : kColorAccent,
                  foregroundColor: isRestDay ? kColorTextMuted : kColorBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isRestDay ? const BorderSide(color: Colors.white12) : BorderSide.none,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isRestDay ? 'ZURÜCK' : 'TRAINING STARTEN',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerInfoBlock extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const ContainerInfoBlock({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color.withOpacity(0.9),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          )
        ],
      ),
    );
  }
}
