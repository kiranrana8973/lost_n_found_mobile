// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BatchApiModel _$BatchApiModelFromJson(Map<String, dynamic> json) =>
    BatchApiModel(
      id: json['_id'] as String?,
      batchName: json['batchName'] as String,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$BatchApiModelToJson(BatchApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'batchName': instance.batchName,
      'status': instance.status,
    };
