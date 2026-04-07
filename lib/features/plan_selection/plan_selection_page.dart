import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../data/workout_plan.dart';
import '../../data/models/workout_program.dart';
import '../../core/providers/active_program_provider.dart';

class PlanSelectionPage extends ConsumerStatefulWidget {
  const PlanSelectionPage({super.key});

  @override
  ConsumerState<PlanSelectionPage> createState() => _PlanSelectionPageState();
}

class _PlanSelectionPageState extends ConsumerState<PlanSelectionPage> {
  int _currentStep = 0; // 0: Category, 1: Plan
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentStep == 0 ? 'Schritt 1: Ziel wählen' : 'Schritt 2: Plan wählen',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep = 0);
            } else {
              context.pop();
            }
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _currentStep == 0 ? _buildCategoryStep() : _buildPlanStep(),
      ),
    );
  }

  Widget _buildCategoryStep() {
    // Get unique categories
    final categories = kAllPrograms.map((p) => p.category).toSet().toList();

    return ListView.builder(
      key: const ValueKey('step1'),
      padding: const EdgeInsets.all(24),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        // Find a representative icon/program for this category
        final repProgram = kAllPrograms.firstWhere((p) => p.category == category);

        return _buildSelectionCard(
          title: category,
          subtitle: 'Entdecke Trainingspläne für dieses Ziel',
          icon: repProgram.icon ?? '🔥',
          onTap: () {
            setState(() {
              _selectedCategory = category;
              _currentStep = 1;
            });
          },
        );
      },
    );
  }

  Widget _buildPlanStep() {
    final filteredPlans = kAllPrograms.where((p) => p.category == _selectedCategory).toList();

    return ListView.builder(
      key: const ValueKey('step2'),
      padding: const EdgeInsets.all(24),
      itemCount: filteredPlans.length,
      itemBuilder: (context, index) {
        final program = filteredPlans[index];
        final isActive = ref.watch(activeProgramProvider).id == program.id;

        return _buildSelectionCard(
          title: program.title,
          subtitle: program.description,
          icon: program.icon ?? '📋',
          isActive: isActive,
          onTap: () {
            ref.read(activeProgramProvider.notifier).setProgram(program);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Plan "${program.title}" aktiviert!'),
                backgroundColor: kColorWork,
              ),
            );
            context.pop(); // Return to home
          },
        );
      },
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required String subtitle,
    required String icon,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: kColorSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? kColorAccent : Colors.white12,
          width: isActive ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: kColorBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: kColorText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: kColorTextMuted,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: kColorTextMuted),
            ],
          ),
        ),
      ),
    );
  }
}
