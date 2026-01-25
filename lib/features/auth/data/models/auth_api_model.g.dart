// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthApiModel _$AuthApiModelFromJson(Map<String, dynamic> json) => AuthApiModel(
  id: json['_id'] as String?,
  fullName: json['name'] as String,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  username: json['username'] as String,
  password: json['password'] as String?,
  batchId: json['batchId'] as String?,
  profilePicture: json['profilePicture'] as String?,
  batch: json['batch'] == null
      ? null
      : BatchApiModel.fromJson(json['batch'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthApiModelToJson(AuthApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'username': instance.username,
      'password': instance.password,
      'batchId': instance.batchId,
      'profilePicture': instance.profilePicture,
      'batch': instance.batch,
    };
