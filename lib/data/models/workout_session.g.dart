// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutSessionAdapter extends TypeAdapter<WorkoutSession> {
  @override
  final int typeId = 0;

  @override
  WorkoutSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutSession()
      ..workoutId = fields[0] as String
      ..completedAt = fields[1] as DateTime
      ..durationSeconds = fields[2] as int
      ..completed = fields[3] as bool
      ..week = fields[4] as int
      ..dayOfWeek = fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, WorkoutSession obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.workoutId)
      ..writeByte(1)
      ..write(obj.completedAt)
      ..writeByte(2)
      ..write(obj.durationSeconds)
      ..writeByte(3)
      ..write(obj.completed)
      ..writeByte(4)
      ..write(obj.week)
      ..writeByte(5)
      ..write(obj.dayOfWeek);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
