import 'package:equatable/equatable.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';

class AuthEntity extends Equatable {
  final String? authId;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String username;
  final String? password;
  final String? batchId;
  final BatchEntity? batch;
  final String? profilePicture;

  const AuthEntity({
    this.authId,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    required this.username,
    this.password,
    this.batchId,
    this.batch,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [
    authId,
    fullName,
    email,
    phoneNumber,
    username,
    password,
    batchId,
    batch,
    profilePicture,
  ];
}
