import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'home_controller.dart';
import '../../widgets/week_progress_bar.dart';
import '../../core/constants/app_colors.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read state from HomeController
    final state = ref.watch(homeControllerProvider);
    final activeDay = state.activeDay;

    String typeLabel = '';
    Color typeColor = kColorWork;

    if (activeDay.type == 'strengthA') {
      typeLabel = 'Kraft-Tag A';
    } else if (activeDay.type == 'strengthB') {
      typeLabel = 'Kraft-Tag B';
    } else if (activeDay.type == 'hiit') {
      typeLabel = 'HIIT Flow';
      typeColor = kColorAccent;
    } else {
      typeLabel = 'Regeneration';
      typeColor = kColorRest;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Precision Fitness & Flow', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => context.push('/plan'),
            tooltip: '3-Wochen-Plan Übersicht',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Headings
            const Text(
              'Guten Tag.',
              style: TextStyle(
                color: kColorTextMuted,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dein heutiges Training',
              style: const TextStyle(
                color: kColorText,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),

            // Active Day Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: kColorSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Woche ${activeDay.week} / Tag ${activeDay.dayOfWeek}',
                        style: const TextStyle(
                          color: kColorTextMuted,
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: typeColor.withOpacity(0.5)),
                        ),
                        child: Text(
                          typeLabel,
                          style: TextStyle(
                            color: typeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    typeLabel,
                    style: const TextStyle(
                      color: kColorText,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activeDay.exercises.isNotEmpty
                        ? '${activeDay.exercises.length} Übungen'
                        : 'Zeit für Stretching oder Tai Chi',
                    style: const TextStyle(color: kColorTextMuted),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/workout/${activeDay.id}');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kColorAccent,
                        foregroundColor: kColorBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'TRAINING STARTEN',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 32),
            WeekProgressBar(
              currentWeek: state.currentWeek,
              completedIds: state.completedIds,
            ),
            
            const SizedBox(height: 32),
            Center(
              child: TextButton(
                onPressed: () => context.push('/plan'),
                child: const Text(
                  'Gesamten Plan ansehen',
                  style: TextStyle(color: kColorText),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
