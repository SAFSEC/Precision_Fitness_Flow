import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'home_controller.dart';
import '../../widgets/week_progress_bar.dart';
import '../../core/constants/app_colors.dart';
import '../../data/workout_plan.dart';
import '../../data/models/training_day.dart';
import '../../core/providers/active_program_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Read state from HomeController
    final state = ref.watch(homeControllerProvider);
    final activeDay = state.activeDay;
    final activeProgram = ref.watch(activeProgramProvider);
    
    // Find all day options for this specific logical day
    final allDaysForCurrentLogicalDay = activeProgram.days.where((d) => 
        d.week == activeDay.week && d.dayOfWeek == activeDay.dayOfWeek).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Precision Fitness & Flow', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            color: kColorTextMuted,
            onPressed: () => _showPlanSelection(context, ref),
            tooltip: 'Trainingsplan wechseln',
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => context.push('/plan'),
            tooltip: 'Plan Übersicht',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/history'),
            tooltip: 'Trainingshistorie',
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
            const Text(
              'Wähle dein heutiges Training',
              style: TextStyle(
                color: kColorText,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // New Plan Discovery Card
            _buildPlanDiscoveryCard(context),
            
            const SizedBox(height: 24),

            // Active Day Options
            ...allDaysForCurrentLogicalDay.map((dayOption) {
               return _buildDayCard(context, dayOption);
            }),

            const SizedBox(height: 16),
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

  Widget _buildDayCard(BuildContext context, TrainingDay day) {
    String typeLabel = '';
    Color typeColor = kColorWork;

    if (day.type == 'strengthA' || day.type == 'strength') {
      typeLabel = day.type == 'strengthA' ? 'Kraft-Tag A' : 'Kraft-Tag';
    } else if (day.type == 'strengthB') {
      typeLabel = 'Kraft-Tag B';
    } else if (day.type == 'hiit') {
      typeLabel = 'HIIT Flow';
      typeColor = kColorAccent;
    } else {
      typeLabel = 'Regeneration';
      typeColor = kColorRest;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
                day.optionLabel ?? 'Woche ${day.week} / Tag ${day.dayOfWeek ?? ""}',
                style: const TextStyle(
                  color: kColorAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
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
            day.title,
            style: const TextStyle(
              color: kColorText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            day.steps.isNotEmpty
                ? '${day.steps.length} Übungen'
                : 'Zeit für Stretching oder Tai Chi',
            style: const TextStyle(color: kColorTextMuted),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                context.push('/workout/${day.id}');
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
    );
  }

  Widget _buildPlanDiscoveryCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF78166), Color(0xFFC0392B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kColorAccent.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/plan-selection'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Neuen Trainingsplan entdecken',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Schritt-für-Schritt zum perfekten Ziel',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.explore, color: Colors.white, size: 28),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPlanSelection(BuildContext context, WidgetRef ref) {
    final activeProgram = ref.read(activeProgramProvider);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: kColorSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Trainingsplan wählen',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kColorText),
                  ),
                ),
                const SizedBox(height: 16),
                ...kAllPrograms.map((program) {
                  final isActive = program.id == activeProgram.id;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    leading: Icon(
                      isActive ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: isActive ? kColorAccent : kColorTextMuted,
                    ),
                    title: Text(
                      program.title,
                      style: TextStyle(
                        color: isActive ? kColorText : kColorTextMuted,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(program.description, style: const TextStyle(color: kColorTextMuted, fontSize: 12)),
                    ),
                    onTap: () {
                      ref.read(activeProgramProvider.notifier).setProgram(program);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
