import 'models/workout_program.dart';
import 'models/training_day.dart';
import 'models/workout_step.dart';
import 'models/exercise.dart';

// REUSABLE EXERCISES
const pushUps = Exercise(
  id: 'push_ups',
  name: 'Liegestütze',
  nameEn: 'Push-Ups',
  type: ExerciseType.strength,
  focus: [MuscleGroup.chest, MuscleGroup.core, MuscleGroup.shoulders],
  executionHint: 'Rumpf gespannt halten',
  isPlyometric: false,
  imageAssetPath: 'assets/images/pushup.png',
);

const lunges = Exercise(
  id: 'lunges',
  name: 'Ausfallschritte',
  nameEn: 'Lunges',
  type: ExerciseType.strength,
  focus: [MuscleGroup.lowerBody, MuscleGroup.core],
  executionHint: 'Oberkörper aufrecht, Knie nicht über die Zehen',
  isPlyometric: false,
  imageAssetPath: 'assets/images/lunge.png',
);

const gluteBridges = Exercise(
  id: 'glute_bridges',
  name: 'Glute Bridges',
  nameEn: 'Glute Bridges',
  type: ExerciseType.strength,
  focus: [MuscleGroup.lowerBody, MuscleGroup.core],
  executionHint: 'Hüfte strecken und Po anspannen',
  isPlyometric: false,
  imageAssetPath: 'assets/images/glute_bridges.png',
);

const burpees = Exercise(
  id: 'burpees',
  name: 'Burpees',
  nameEn: 'Burpees',
  type: ExerciseType.hiit,
  focus: [MuscleGroup.fullBody],
  executionHint: 'Maximales Tempo, saubere Form',
  isPlyometric: true,
  safetyHint: 'Achte bei der Landung auf deine Kniegelenke!',
  imageAssetPath: 'assets/images/burpee.png',
);

const mountainClimbers = Exercise(
  id: 'mountain_climbers',
  name: 'Mountain Climbers',
  nameEn: 'Mountain Climbers',
  type: ExerciseType.hiit,
  focus: [MuscleGroup.core, MuscleGroup.shoulders],
  executionHint: 'Knie schnell zur Brust ziehen',
  isPlyometric: true,
  imageAssetPath: 'assets/images/mountain_climber.png',
);

const plank = Exercise(
  id: 'plank',
  name: 'Unterarmstütz',
  nameEn: 'Plank',
  type: ExerciseType.strength,
  focus: [MuscleGroup.core],
  executionHint: 'Körper bildet eine gerade Linie',
  isPlyometric: false,
  imageAssetPath: 'assets/images/plank.png',
);

const wallSit = Exercise(
  id: 'wall_sit',
  name: 'Wandsitz',
  nameEn: 'Wall Sit',
  type: ExerciseType.strength,
  focus: [MuscleGroup.lowerBody],
  executionHint: 'Beine im 90 Grad Winkel',
  isPlyometric: false,
  imageAssetPath: 'assets/images/wall_sit.png',
);

const sprint = Exercise(
  id: 'sprint',
  name: 'Sprint / High Knees',
  nameEn: 'Sprint',
  type: ExerciseType.hiit,
  focus: [MuscleGroup.lowerBody, MuscleGroup.fullBody],
  executionHint: 'Maximale Geschwindigkeit',
  isPlyometric: true,
  imageAssetPath: 'assets/images/sprint.png',
);

const pullUps = Exercise(
  id: 'pull_ups',
  name: 'Klimmzüge (oder Rudern)',
  nameEn: 'Pull-Ups',
  type: ExerciseType.strength,
  focus: [MuscleGroup.shoulders, MuscleGroup.triceps],
  executionHint: 'Kinn über die Stange',
  isPlyometric: false,
  imageAssetPath: 'assets/images/pull_ups.png',
);

const squats = Exercise(
  id: 'squats',
  name: 'Kniebeugen',
  nameEn: 'Squats',
  type: ExerciseType.strength,
  focus: [MuscleGroup.lowerBody],
  executionHint: 'Rücken gerade halten',
  isPlyometric: false,
  imageAssetPath: 'assets/images/squat.png',
);

const longRun = Exercise(
  id: 'long_run',
  name: 'Langsamer Dauerlauf / Marsch',
  nameEn: 'Long Run',
  type: ExerciseType.metabolic,
  focus: [MuscleGroup.lowerBody],
  executionHint: 'Konstantes, ruhiges Tempo',
  isPlyometric: false,
  imageAssetPath: 'assets/images/long_run.png',
);

const stretching = Exercise(
  id: 'stretching',
  name: 'Dehnen / Mobility',
  nameEn: 'Stretching',
  type: ExerciseType.metabolic,
  focus: [MuscleGroup.fullBody],
  executionHint: 'Entspannt atmen',
  isPlyometric: false,
  imageAssetPath: 'assets/images/stretching.png',
);


// -------------------------------------------------------------------------------- //
// MULTI-PROGRAM DEFINITIONS
// -------------------------------------------------------------------------------- //

final kProgramHybrid = WorkoutProgram(
  id: 'hybrid_pp',
  title: 'Precision & Performance Hybrid',
  description: 'Wöchentlich rotierender Plan: Wähle jeden Tag zwischen Precision Flow (Technik) oder Military Task (Leistung).',
  days: [
    // --- MONTAG ---
    const TrainingDay(
      id: 'mon_opt_a',
      week: 1,
      dayOfWeek: 1,
      title: 'Montag – Precision Flow (PFF)',
      type: 'strength',
      optionLabel: 'Option A: PFF (Kraft/Core)',
      steps: [
        WorkoutStep(exercise: pushUps, sets: 1, reps: 15, restSeconds: 60),
        WorkoutStep(exercise: lunges, sets: 1, reps: 20, restSeconds: 60),
      ],
    ),
    const TrainingDay(
      id: 'mon_opt_b',
      week: 1,
      dayOfWeek: 1,
      title: 'Montag – Military Task (MT)',
      type: 'strength',
      optionLabel: 'Option B: MT (Kraft-Volumen)',
      steps: [
        WorkoutStep(exercise: pushUps, sets: 3, reps: 20, restSeconds: 45),
        WorkoutStep(exercise: lunges, sets: 3, reps: 24, restSeconds: 45),
        WorkoutStep(exercise: gluteBridges, sets: 3, reps: 20, restSeconds: 45),
      ],
    ),

    // --- DIENSTAG ---
    const TrainingDay(
      id: 'tue_opt_a',
      week: 1,
      dayOfWeek: 2,
      title: 'Dienstag – Precision Flow (PFF)',
      type: 'hiit',
      optionLabel: 'Option A: PFF (Anaerob/Speed)',
      steps: [
        WorkoutStep(exercise: mountainClimbers, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: burpees, durationSeconds: 30, restSeconds: 15),
      ],
    ),
    const TrainingDay(
      id: 'tue_opt_b',
      week: 1,
      dayOfWeek: 2,
      title: 'Dienstag – Military Task (MT)',
      type: 'hiit',
      optionLabel: 'Option B: MT (Intervall-Sprint)',
      steps: [
        WorkoutStep(exercise: sprint, durationSeconds: 60, restSeconds: 60),
        WorkoutStep(exercise: sprint, durationSeconds: 60, restSeconds: 60),
        WorkoutStep(exercise: sprint, durationSeconds: 60, restSeconds: 60),
      ],
    ),

    // --- MITTWOCH ---
    const TrainingDay(
      id: 'wed_opt_a',
      week: 1,
      dayOfWeek: 3,
      title: 'Mittwoch – Precision Flow (PFF)',
      type: 'strength',
      optionLabel: 'Option A: PFF (Isometrik)',
      steps: [
        WorkoutStep(exercise: plank, sets: 1, durationSeconds: 60, restSeconds: 30),
      ],
    ),
    const TrainingDay(
      id: 'wed_opt_b',
      week: 1,
      dayOfWeek: 3,
      title: 'Mittwoch – Military Task (MT)',
      type: 'strength',
      optionLabel: 'Option B: MT (Statik-Zirkel)',
      steps: [
        WorkoutStep(exercise: wallSit, sets: 3, durationSeconds: 60, restSeconds: 30),
        WorkoutStep(exercise: plank, sets: 3, durationSeconds: 90, restSeconds: 30),
      ],
    ),

    // --- DONNERSTAG ---
    const TrainingDay(
      id: 'thu_rest',
      week: 1,
      dayOfWeek: 4,
      title: 'Donnerstag – Regeneration',
      type: 'rest',
      optionLabel: 'Regeneration / Mobility',
      steps: [
        WorkoutStep(exercise: stretching, durationSeconds: 300),
      ],
    ),

    // --- FREITAG ---
    const TrainingDay(
      id: 'fri_opt_a',
      week: 1,
      dayOfWeek: 5,
      title: 'Freitag – Precision Flow (PFF)',
      type: 'strength',
      optionLabel: 'Option A: PFF (Symmetrie)',
      steps: [
        WorkoutStep(exercise: squats, sets: 2, reps: 15, restSeconds: 60),
        WorkoutStep(exercise: pullUps, sets: 2, reps: 8, restSeconds: 60),
      ],
    ),
    const TrainingDay(
      id: 'fri_opt_b',
      week: 1,
      dayOfWeek: 5,
      title: 'Freitag – Military Task (MT)',
      type: 'strength',
      optionLabel: 'Option B: MT (High Volume Calisthenics)',
      steps: [
        WorkoutStep(exercise: pullUps, sets: 4, reps: 10, restSeconds: 90),
        WorkoutStep(exercise: squats, sets: 4, reps: 25, restSeconds: 60),
        WorkoutStep(exercise: pushUps, sets: 4, reps: 20, restSeconds: 60),
      ],
    ),

    // --- SAMSTAG ---
    const TrainingDay(
      id: 'sat_opt_a',
      week: 1,
      dayOfWeek: 6,
      title: 'Samstag – Precision Flow (PFF)',
      type: 'hiit', // as flow mastery could be dynamic
      optionLabel: 'Option A: PFF (Flow Mastery)',
      steps: [
        WorkoutStep(exercise: mountainClimbers, durationSeconds: 40, restSeconds: 20),
        WorkoutStep(exercise: burpees, durationSeconds: 40, restSeconds: 20),
      ],
    ),
    const TrainingDay(
      id: 'sat_opt_b',
      week: 1,
      dayOfWeek: 6,
      title: 'Samstag – Military Task (MT)',
      type: 'rest', // using rest type to render static description
      optionLabel: 'Option B: MT (Long Run)',
      steps: [
        WorkoutStep(exercise: longRun, durationSeconds: 3600), // 1 hour 
      ],
    ),

    // --- SONNTAG ---
    const TrainingDay(
      id: 'sun_rest',
      week: 1,
      dayOfWeek: 7,
      title: 'Sonntag – Rest Day',
      type: 'rest',
      optionLabel: 'Regeneration',
      steps: [],
    ),
  ],
);

// We keep kProgram3Weeks as the fallback for "Classic" if needed, 
// or the user can just delete it later. It is defined minimally to satisfy older code if any.
final kProgram3Weeks = WorkoutProgram(
  id: 'classic_3w',
  title: 'Classic 3-Wochen (Legacy)',
  description: 'Veralteter starrer 21-Tage Plan',
  days: [
    const TrainingDay(id: 'w1d1', week: 1, title: 'Tag 1', type: 'strength', steps: []),
  ]
);

// Unified list of all programs
final kAllPrograms = [
  kProgramHybrid,
];

final kExercises = [
  pushUps,
  lunges,
  gluteBridges,
  burpees,
  mountainClimbers,
  plank,
  wallSit,
  sprint,
  pullUps,
  squats,
  longRun,
  stretching,
];
