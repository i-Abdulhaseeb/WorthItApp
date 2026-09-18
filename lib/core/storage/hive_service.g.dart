// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_service.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedDecisionAdapter extends TypeAdapter<SavedDecision> {
  @override
  final int typeId = 0;

  @override
  SavedDecision read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedDecision(
      productName: fields[0] as String,
      productPrice: fields[1] as double,
      imagePath: fields[2] as String?,
      decidedAt: fields[3] as DateTime,
      verdict: fields[4] as String,
      reason: fields[5] as String,
      recommendation: fields[6] as String,
      affordability: fields[7] as int,
      necessity: fields[8] as int,
      value: fields[9] as int,
      usage: fields[10] as int,
      alternative: fields[11] as int,
      impulseRisk: fields[12] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SavedDecision obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.productName)
      ..writeByte(1)
      ..write(obj.productPrice)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.decidedAt)
      ..writeByte(4)
      ..write(obj.verdict)
      ..writeByte(5)
      ..write(obj.reason)
      ..writeByte(6)
      ..write(obj.recommendation)
      ..writeByte(7)
      ..write(obj.affordability)
      ..writeByte(8)
      ..write(obj.necessity)
      ..writeByte(9)
      ..write(obj.value)
      ..writeByte(10)
      ..write(obj.usage)
      ..writeByte(11)
      ..write(obj.alternative)
      ..writeByte(12)
      ..write(obj.impulseRisk);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedDecisionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
