import 'models/workout_program.dart';
import 'models/training_day.dart';
import 'models/workout_step.dart';
import 'models/exercise.dart';

// REUSABLE EXERCISES
const pushUps = Exercise(
  id: 'push_ups',
  name: 'Liegestütze (Basis)',
  nameEn: 'Push-Ups',
  type: ExerciseType.strength,
  focus: [MuscleGroup.chest, MuscleGroup.core, MuscleGroup.shoulders],
  executionHint: 'Rumpf gespannt halten',
  isPlyometric: false,
  imageAssetPath: 'assets/images/pushup.png',
);

const inclinePushUps = Exercise(
  id: 'push_ups_incline',
  name: 'Schräge Liegestütze',
  nameEn: 'Incline Push-Ups',
  type: ExerciseType.strength,
  focus: [MuscleGroup.chest, MuscleGroup.shoulders],
  executionHint: 'Hände auf erhöhte Fläche',
  isPlyometric: false,
  imageAssetPath: 'assets/images/incline_pushup.png',
);

const diamondPushUps = Exercise(
  id: 'push_ups_diamond',
  name: 'Diamant-Liegestütze',
  nameEn: 'Diamond Push-Ups',
  type: ExerciseType.strength,
  focus: [MuscleGroup.triceps, MuscleGroup.chest],
  executionHint: 'Hände bilden ein Dreieck unter der Brust',
  isPlyometric: false,
  imageAssetPath: 'assets/images/diamond_pushup.png',
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

const jumpingJacks = Exercise(
  id: 'jumping_jacks',
  name: 'Hampelmänner',
  nameEn: 'Jumping Jacks',
  type: ExerciseType.hiit,
  focus: [MuscleGroup.fullBody],
  executionHint: 'Weiche Landung zum Gelenkschutz',
  isPlyometric: true,
  imageAssetPath: 'assets/images/jumping_jack.png',
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
  executionHint: 'Rücken gerade halten, Fersen am Boden',
  isPlyometric: false,
  imageAssetPath: 'assets/images/squat.png',
);

const jumpingSquats = Exercise(
  id: 'squats_jumping',
  name: 'Sprungkniebeugen',
  nameEn: 'Jumping Squats',
  type: ExerciseType.hiit,
  focus: [MuscleGroup.lowerBody, MuscleGroup.fullBody],
  executionHint: 'Explosive Sprünge nach oben',
  isPlyometric: true,
  imageAssetPath: 'assets/images/jumping_squat.png',
);

const pulsingSquats = Exercise(
  id: 'squats_pulsing',
  name: 'Puls-Kniebeugen',
  nameEn: 'Pulsing Squats',
  type: ExerciseType.strength,
  focus: [MuscleGroup.lowerBody],
  executionHint: 'Kurze, wippende Bewegungen am tiefsten Punkt',
  isPlyometric: false,
  imageAssetPath: 'assets/images/pulsing_squat.png',
);

const walkingLunges = Exercise(
  id: 'lunges_walking',
  name: 'Gehende Ausfallschritte',
  nameEn: 'Walking Lunges',
  type: ExerciseType.strength,
  focus: [MuscleGroup.lowerBody, MuscleGroup.core],
  executionHint: 'Kontrolliert nach vorne treten',
  isPlyometric: false,
  imageAssetPath: 'assets/images/walking_lunge.png',
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

const kProgramHybrid = WorkoutProgram(
  id: 'hybrid_pp_5day',
  title: '5-Tage Muskelaufbau & HIIT',
  description: 'Wöchentlicher Fokus auf Kraft und HIIT. 3x Kraft, 2x HIIT, 2x Regeneration.',
  days: [
    // --- MONTAG (Krafttraining) ---
    TrainingDay(
      id: 'mon_opt_a',
      week: 1,
      dayOfWeek: 1,
      title: 'Montag – Precision Flow (Elementar)',
      type: 'strength',
      optionLabel: 'Option A: PFF (Kraft Basis)',
      steps: [
        WorkoutStep(exercise: inclinePushUps, sets: 3, reps: 15, restSeconds: 60),
        WorkoutStep(exercise: squats, sets: 3, reps: 20, restSeconds: 60),
        WorkoutStep(exercise: lunges, sets: 3, reps: 15, restSeconds: 60),
      ],
    ),
    TrainingDay(
      id: 'mon_opt_b',
      week: 1,
      dayOfWeek: 1,
      title: 'Montag – Military Task (Intensiv)',
      type: 'strength',
      optionLabel: 'Option B: MT (Advanced Power)',
      steps: [
        WorkoutStep(exercise: diamondPushUps, sets: 3, reps: 15, restSeconds: 45),
        WorkoutStep(exercise: squats, sets: 3, reps: 25, restSeconds: 45),
        WorkoutStep(exercise: walkingLunges, sets: 3, reps: 20, restSeconds: 45),
      ],
    ),

    // --- DIENSTAG (HIIT) ---
    TrainingDay(
      id: 'tue_opt_a',
      week: 1,
      dayOfWeek: 2,
      title: 'Dienstag – HIIT Option A',
      type: 'hiit',
      optionLabel: 'Option A: PFF (Core & Ausdauer)',
      steps: [
        WorkoutStep(exercise: mountainClimbers, durationSeconds: 30, restSeconds: 20),
        WorkoutStep(exercise: jumpingJacks, durationSeconds: 30, restSeconds: 20),
        WorkoutStep(exercise: mountainClimbers, durationSeconds: 30, restSeconds: 20),
        WorkoutStep(exercise: jumpingJacks, durationSeconds: 30, restSeconds: 20),
        WorkoutStep(exercise: mountainClimbers, durationSeconds: 30, restSeconds: 20),
        WorkoutStep(exercise: jumpingJacks, durationSeconds: 30, restSeconds: 20),
        WorkoutStep(exercise: mountainClimbers, durationSeconds: 30, restSeconds: 20),
        WorkoutStep(exercise: jumpingJacks, durationSeconds: 30, restSeconds: 20),
      ],
    ),
    TrainingDay(
      id: 'tue_opt_b',
      week: 1,
      dayOfWeek: 2,
      title: 'Dienstag – HIIT Option B',
      type: 'hiit',
      optionLabel: 'Option B: MT (Kraftpaket)',
      steps: [
        WorkoutStep(exercise: burpees, durationSeconds: 30, restSeconds: 10),
        WorkoutStep(exercise: jumpingSquats, durationSeconds: 20, restSeconds: 10),
        WorkoutStep(exercise: burpees, durationSeconds: 30, restSeconds: 10),
        WorkoutStep(exercise: jumpingSquats, durationSeconds: 20, restSeconds: 10),
        WorkoutStep(exercise: burpees, durationSeconds: 30, restSeconds: 10),
        WorkoutStep(exercise: jumpingSquats, durationSeconds: 20, restSeconds: 10),
        WorkoutStep(exercise: burpees, durationSeconds: 30, restSeconds: 10),
        WorkoutStep(exercise: jumpingSquats, durationSeconds: 20, restSeconds: 10),
        WorkoutStep(exercise: burpees, durationSeconds: 30, restSeconds: 10),
        WorkoutStep(exercise: jumpingSquats, durationSeconds: 20, restSeconds: 10),
      ],
    ),
    TrainingDay(
      id: 'tue_opt_c',
      week: 1,
      dayOfWeek: 2,
      title: 'Dienstag – HIIT Option C',
      type: 'hiit',
      optionLabel: 'Option C: Advanced (Intensity)',
      steps: [
        WorkoutStep(exercise: diamondPushUps, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: pulsingSquats, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: walkingLunges, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: diamondPushUps, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: pulsingSquats, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: walkingLunges, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: diamondPushUps, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: pulsingSquats, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: walkingLunges, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: diamondPushUps, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: pulsingSquats, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: walkingLunges, durationSeconds: 30, restSeconds: 15),
      ],
    ),

    // --- MITTWOCH (Krafttraining) ---
    TrainingDay(
      id: 'wed_opt_a',
      week: 1,
      dayOfWeek: 3,
      title: 'Mittwoch – Precision Flow (Fokus)',
      type: 'strength',
      optionLabel: 'Option A: PFF (Kontrolle)',
      steps: [
        WorkoutStep(exercise: pushUps, sets: 3, reps: 15, restSeconds: 60),
        WorkoutStep(exercise: squats, sets: 3, reps: 20, restSeconds: 60),
        WorkoutStep(exercise: lunges, sets: 3, reps: 15, restSeconds: 60),
      ],
    ),
    TrainingDay(
      id: 'wed_opt_b',
      week: 1,
      dayOfWeek: 3,
      title: 'Mittwoch – Military Task (Muskelreiz)',
      type: 'strength',
      optionLabel: 'Option B: MT (Volumen)',
      steps: [
        WorkoutStep(exercise: diamondPushUps, sets: 4, reps: 15, restSeconds: 45),
        WorkoutStep(exercise: pulsingSquats, sets: 4, reps: 25, restSeconds: 45),
        WorkoutStep(exercise: walkingLunges, sets: 4, reps: 20, restSeconds: 45),
      ],
    ),

    // --- DONNERSTAG (HIIT) ---
    TrainingDay(
      id: 'thu_opt_a',
      week: 1,
      dayOfWeek: 4,
      title: 'Donnerstag – HIIT Option A',
      type: 'hiit',
      optionLabel: 'Option A: PFF (Ausdauer)',
      steps: [
        WorkoutStep(exercise: mountainClimbers, durationSeconds: 30, restSeconds: 20),
        WorkoutStep(exercise: jumpingJacks, durationSeconds: 30, restSeconds: 20),
        WorkoutStep(exercise: mountainClimbers, durationSeconds: 30, restSeconds: 20),
        WorkoutStep(exercise: jumpingJacks, durationSeconds: 30, restSeconds: 20),
        WorkoutStep(exercise: mountainClimbers, durationSeconds: 30, restSeconds: 20),
        WorkoutStep(exercise: jumpingJacks, durationSeconds: 30, restSeconds: 20),
        WorkoutStep(exercise: mountainClimbers, durationSeconds: 30, restSeconds: 20),
        WorkoutStep(exercise: jumpingJacks, durationSeconds: 30, restSeconds: 20),
      ],
    ),
    TrainingDay(
      id: 'thu_opt_b',
      week: 1,
      dayOfWeek: 4,
      title: 'Donnerstag – HIIT Option B',
      type: 'hiit',
      optionLabel: 'Option B: MT (Explosivität)',
      steps: [
        WorkoutStep(exercise: burpees, durationSeconds: 30, restSeconds: 10),
        WorkoutStep(exercise: jumpingSquats, durationSeconds: 20, restSeconds: 10),
        WorkoutStep(exercise: burpees, durationSeconds: 30, restSeconds: 10),
        WorkoutStep(exercise: jumpingSquats, durationSeconds: 20, restSeconds: 10),
        WorkoutStep(exercise: burpees, durationSeconds: 30, restSeconds: 10),
        WorkoutStep(exercise: jumpingSquats, durationSeconds: 20, restSeconds: 10),
        WorkoutStep(exercise: burpees, durationSeconds: 30, restSeconds: 10),
        WorkoutStep(exercise: jumpingSquats, durationSeconds: 20, restSeconds: 10),
        WorkoutStep(exercise: burpees, durationSeconds: 30, restSeconds: 10),
        WorkoutStep(exercise: jumpingSquats, durationSeconds: 20, restSeconds: 10),
      ],
    ),
    TrainingDay(
      id: 'thu_opt_c',
      week: 1,
      dayOfWeek: 4,
      title: 'Donnerstag – HIIT Option C',
      type: 'hiit',
      optionLabel: 'Option C: Advanced (Elite)',
      steps: [
        WorkoutStep(exercise: diamondPushUps, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: pulsingSquats, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: walkingLunges, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: diamondPushUps, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: pulsingSquats, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: walkingLunges, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: diamondPushUps, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: pulsingSquats, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: walkingLunges, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: diamondPushUps, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: pulsingSquats, durationSeconds: 30, restSeconds: 15),
        WorkoutStep(exercise: walkingLunges, durationSeconds: 30, restSeconds: 15),
      ],
    ),

    // --- FREITAG (Krafttraining) ---
    TrainingDay(
      id: 'fri_opt_a',
      week: 1,
      dayOfWeek: 5,
      title: 'Freitag – Precision Flow (Sauberkeit)',
      type: 'strength',
      optionLabel: 'Option A: PFF (Ausführung)',
      steps: [
        WorkoutStep(exercise: inclinePushUps, sets: 3, reps: 15, restSeconds: 60),
        WorkoutStep(exercise: squats, sets: 3, reps: 20, restSeconds: 60),
        WorkoutStep(exercise: lunges, sets: 3, reps: 15, restSeconds: 60),
      ],
    ),
    TrainingDay(
      id: 'fri_opt_b',
      week: 1,
      dayOfWeek: 5,
      title: 'Freitag – Military Task (Finale)',
      type: 'strength',
      optionLabel: 'Option B: MT (Belastung)',
      steps: [
        WorkoutStep(exercise: diamondPushUps, sets: 4, reps: 15, restSeconds: 45),
        WorkoutStep(exercise: jumpingSquats, sets: 4, reps: 20, restSeconds: 45),
        WorkoutStep(exercise: burpees, sets: 4, reps: 15, restSeconds: 45),
      ],
    ),

    // --- SAMSTAG (Regeneration) ---
    TrainingDay(
      id: 'sat_rest',
      week: 1,
      dayOfWeek: 6,
      title: 'Samstag – Regeneration',
      type: 'rest',
      optionLabel: 'Regeneration / Yoga',
      steps: [
        WorkoutStep(exercise: stretching, durationSeconds: 300),
      ],
    ),

    // --- SONNTAG (Regeneration) ---
    TrainingDay(
      id: 'sun_rest',
      week: 1,
      dayOfWeek: 7,
      title: 'Sonntag – Rest Day',
      type: 'rest',
      optionLabel: 'Ruhephase',
      steps: [],
    ),
  ],
);

// We keep kProgram3Weeks as the fallback for "Classic" if needed, 
// or the user can just delete it later. It is defined minimally to satisfy older code if any.
const kProgram3Weeks = WorkoutProgram(
  id: 'classic_3w',
  title: 'Classic 3-Wochen (Legacy)',
  description: 'Veralteter starrer 21-Tage Plan',
  days: [
    TrainingDay(id: 'w1d1', week: 1, title: 'Tag 1', type: 'strength', steps: []),
  ]
);

// Unified list of all programs
final kAllPrograms = [
  kProgramHybrid,
];

final kExercises = [
  pushUps,
  inclinePushUps,
  diamondPushUps,
  lunges,
  walkingLunges,
  gluteBridges,
  burpees,
  mountainClimbers,
  jumpingJacks,
  plank,
  wallSit,
  sprint,
  pullUps,
  squats,
  jumpingSquats,
  pulsingSquats,
  longRun,
  stretching,
];
