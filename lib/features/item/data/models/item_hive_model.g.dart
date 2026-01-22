// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemHiveModelAdapter extends TypeAdapter<ItemHiveModel> {
  @override
  final int typeId = 2;

  @override
  ItemHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemHiveModel(
      itemId: fields[0] as String?,
      reportedBy: fields[1] as String?,
      claimedBy: fields[2] as String?,
      categoryId: fields[3] as String?,
      itemName: fields[4] as String,
      description: fields[5] as String?,
      type: fields[6] as String,
      location: fields[7] as String,
      media: fields[8] as String?,
      mediaType: fields[9] as String?,
      isClaimed: fields[10] as bool?,
      status: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ItemHiveModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.reportedBy)
      ..writeByte(2)
      ..write(obj.claimedBy)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.itemName)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.type)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.media)
      ..writeByte(9)
      ..write(obj.mediaType)
      ..writeByte(10)
      ..write(obj.isClaimed)
      ..writeByte(11)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
