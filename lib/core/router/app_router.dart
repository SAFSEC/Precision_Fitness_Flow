import 'package:go_router/go_router.dart';
import '../../features/home/home_page.dart';
import '../../features/plan/plan_overview_page.dart';
import '../../features/plan/day_detail_page.dart';
import '../../features/workout/workout_page.dart';
import '../../features/workout/workout_complete_page.dart';
import '../../features/exercises/exercise_list_page.dart';
import '../../features/exercises/exercise_detail_page.dart';
import '../../features/history/history_page.dart';

import '../../features/plan_selection/plan_selection_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/plan-selection',
      builder: (context, state) => const PlanSelectionPage(),
    ),
    GoRoute(
      path: '/plan',
      builder: (context, state) => const PlanOverviewPage(),
      routes: [
        GoRoute(
          path: ':dayId',
          builder: (context, state) {
            final dayId = state.pathParameters['dayId']!;
            return DayDetailPage(dayId: dayId);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/workout/:dayId',
      builder: (context, state) {
        final dayId = state.pathParameters['dayId']!;
        return WorkoutPage(dayId: dayId);
      },
      routes: [
        GoRoute(
          path: 'complete',
          builder: (context, state) {
            final dayId = state.pathParameters['dayId']!;
            return WorkoutCompletePage(dayId: dayId);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/exercises',
      builder: (context, state) => const ExerciseListPage(),
      routes: [
        GoRoute(
          path: ':exerciseId',
          builder: (context, state) {
            final exerciseId = state.pathParameters['exerciseId']!;
            return ExerciseDetailPage(exerciseId: exerciseId);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryPage(),
    ),
  ],
);
