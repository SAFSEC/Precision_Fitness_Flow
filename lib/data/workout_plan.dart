import 'models/exercise.dart';
import 'models/training_day.dart';

// 6 Kernübungen
const List<Exercise> kExercises = [
  Exercise(
    id: 'pushup',
    name: 'Liegestütze',
    nameEn: 'Push-Up',
    type: ExerciseType.strength,
    focus: [MuscleGroup.chest, MuscleGroup.shoulders, MuscleGroup.triceps],
    executionHint: 'Brust senkt sich bis ca. 5 cm über den Boden. Körper bleibt gerade – keine Hüfte nach oben oder unten.',
    safetyHint: null,
    isPlyometric: false,
    imageAssetPath: 'assets/images/pushup.png',
  ),
  Exercise(
    id: 'squat',
    name: 'Kniebeugen',
    nameEn: 'Squat',
    type: ExerciseType.strength,
    focus: [MuscleGroup.lowerBody, MuscleGroup.core],
    executionHint: 'Knie zeigen in Zehenrichtung. Fersen bleiben auf dem Boden. Oberkörper aufrecht, Blick geradeaus.',
    safetyHint: null,
    isPlyometric: false,
    imageAssetPath: 'assets/images/squat.png',
  ),
  Exercise(
    id: 'lunge',
    name: 'Ausfallschritte',
    nameEn: 'Lunges',
    type: ExerciseType.strength,
    focus: [MuscleGroup.lowerBody, MuscleGroup.core],
    executionHint: 'Vorderes Knie nicht über die Zehenspitze. Hinteres Knie sinkt kontrolliert Richtung Boden.',
    safetyHint: null,
    isPlyometric: false,
    imageAssetPath: 'assets/images/lunge.png',
  ),
  Exercise(
    id: 'mountain_climber',
    name: 'Mountain Climbers',
    nameEn: 'Mountain Climbers',
    type: ExerciseType.metabolic,
    focus: [MuscleGroup.core, MuscleGroup.fullBody],
    executionHint: 'Hüfte bleibt auf Plank-Höhe – nicht nach oben oder unten wandern. Knie zieht aktiv zur Brust.',
    safetyHint: null,
    isPlyometric: false,
    imageAssetPath: 'assets/images/mountain_climber.png',
  ),
  Exercise(
    id: 'jumping_jack',
    name: 'Hampelmänner',
    nameEn: 'Jumping Jacks',
    type: ExerciseType.metabolic,
    focus: [MuscleGroup.fullBody],
    executionHint: 'Kontrollierte Bewegung – Arme aktiv nach oben führen.',
    safetyHint: 'Weiche Landung: Knie leicht gebeugt beim Aufkommen. Nicht auf den Fersen landen.',
    isPlyometric: true,
    imageAssetPath: 'assets/images/jumping_jack.png',
  ),
  Exercise(
    id: 'burpee',
    name: 'Burpees / Sprungkniebeugen',
    nameEn: 'Burpees / Jump Squats',
    type: ExerciseType.hiit,
    focus: [MuscleGroup.fullBody, MuscleGroup.core],
    executionHint: 'Beim Burpee: Plank-Position korrekt halten, kein Hohlkreuz. Sprung aus der vollen Hocke.',
    safetyHint: 'Weiche Landung: Auf dem Vorfuß landen, Knie beim Aufkommen leicht beugen. Gelenke schonen.',
    isPlyometric: true,
    imageAssetPath: 'assets/images/burpee.png',
  ),
];

// 3-Wochen-Trainingsplan
final List<TrainingDay> kWorkoutPlan = [
  // Woche 1
  TrainingDay(
    week: 1,
    dayOfWeek: 1,
    type: 'strengthA',
    exercises: [
      kExercises[0], // Pushup
      kExercises[1], // Squat
      kExercises[2], // Lunge
    ],
  ),
  TrainingDay(
    week: 1,
    dayOfWeek: 2,
    type: 'hiit',
    exercises: [
      kExercises[3], // Mountain Climber
      kExercises[4], // Jumping Jack
      kExercises[5], // Burpee
    ],
  ),
  TrainingDay(
    week: 1,
    dayOfWeek: 3,
    type: 'strengthB',
    exercises: [
      kExercises[3], // Mountain Climber
      kExercises[4], // Jumping Jack
      kExercises[1], // Squat
    ],
  ),
  TrainingDay(
    week: 1,
    dayOfWeek: 4,
    type: 'rest',
    exercises: [],
  ),
  TrainingDay(
    week: 1,
    dayOfWeek: 5,
    type: 'strengthA',
    exercises: [
      kExercises[0], // Pushup
      kExercises[1], // Squat
      kExercises[2], // Lunge
    ],
  ),
  TrainingDay(
    week: 1,
    dayOfWeek: 6,
    type: 'hiit',
    exercises: [
      kExercises[3], // Mountain Climber
      kExercises[4], // Jumping Jack
      kExercises[5], // Burpee
    ],
  ),
  TrainingDay(
    week: 1,
    dayOfWeek: 7,
    type: 'rest',
    exercises: [],
  ),
  
  // Woche 2
  TrainingDay(
    week: 2,
    dayOfWeek: 1,
    type: 'strengthA',
    exercises: [kExercises[0], kExercises[1], kExercises[2]],
  ),
  TrainingDay(
    week: 2,
    dayOfWeek: 2,
    type: 'hiit',
    exercises: [kExercises[3], kExercises[4], kExercises[5]],
  ),
  TrainingDay(
    week: 2,
    dayOfWeek: 3,
    type: 'strengthB',
    exercises: [kExercises[3], kExercises[4], kExercises[1]],
  ),
  TrainingDay(
    week: 2,
    dayOfWeek: 4,
    type: 'rest',
    exercises: [],
  ),
  TrainingDay(
    week: 2,
    dayOfWeek: 5,
    type: 'strengthA',
    exercises: [kExercises[0], kExercises[1], kExercises[2]],
  ),
  TrainingDay(
    week: 2,
    dayOfWeek: 6,
    type: 'hiit',
    exercises: [kExercises[3], kExercises[4], kExercises[5]],
  ),
  TrainingDay(
    week: 2,
    dayOfWeek: 7,
    type: 'rest',
    exercises: [],
  ),
  
  // Woche 3
  TrainingDay(
    week: 3,
    dayOfWeek: 1,
    type: 'strengthA',
    exercises: [kExercises[0], kExercises[1], kExercises[2]],
  ),
  TrainingDay(
    week: 3,
    dayOfWeek: 2,
    type: 'hiit',
    exercises: [kExercises[3], kExercises[4], kExercises[5]],
  ),
  TrainingDay(
    week: 3,
    dayOfWeek: 3,
    type: 'strengthB',
    exercises: [kExercises[3], kExercises[4], kExercises[1]],
  ),
  TrainingDay(
    week: 3,
    dayOfWeek: 4,
    type: 'rest',
    exercises: [],
  ),
  TrainingDay(
    week: 3,
    dayOfWeek: 5,
    type: 'strengthA',
    exercises: [kExercises[0], kExercises[1], kExercises[2]],
  ),
  TrainingDay(
    week: 3,
    dayOfWeek: 6,
    type: 'hiit',
    exercises: [kExercises[3], kExercises[4], kExercises[5]],
  ),
  TrainingDay(
    week: 3,
    dayOfWeek: 7,
    type: 'rest',
    exercises: [],
  ),
];
