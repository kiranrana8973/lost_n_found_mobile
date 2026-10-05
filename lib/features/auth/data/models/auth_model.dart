import 'package:lost_n_found/core/services/database/app_database.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:uuid/uuid.dart';

// The row class itself is generated into app_database.dart; re-export it so
// importing this file gives you both the model and its mappers.
export 'package:lost_n_found/core/services/database/app_database.dart'
    show AuthModel;

// AuthModel is the drift row class generated from AuthTable.
// These extensions map it to and from the domain entity.

extension AuthModelX on AuthModel {
  AuthEntity toEntity({BatchEntity? batch}) {
    return AuthEntity(
      authId: authId,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      username: username,
      password: password,
      batchId: batchId,
      batch: batch,
      profilePicture: profilePicture,
    );
  }
}

extension AuthEntityX on AuthEntity {
  AuthModel toModel() {
    return AuthModel(
      authId: authId ?? const Uuid().v4(),
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      username: username,
      password: password,
      batchId: batchId ?? batch?.batchId,
      profilePicture: profilePicture,
    );
  }
}

extension AuthModelListX on List<AuthModel> {
  List<AuthEntity> toEntityList() => map((model) => model.toEntity()).toList();
}
