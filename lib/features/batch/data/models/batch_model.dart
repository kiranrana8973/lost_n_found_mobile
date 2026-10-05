import 'package:lost_n_found/core/services/database/app_database.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:uuid/uuid.dart';

// The row class itself is generated into app_database.dart; re-export it so
// importing this file gives you both the model and its mappers.
export 'package:lost_n_found/core/services/database/app_database.dart'
    show BatchModel;

// BatchModel is the drift row class generated from BatchTable.
// These extensions map it to and from the domain entity.

extension BatchModelX on BatchModel {
  BatchEntity toEntity() {
    return BatchEntity(batchId: batchId, batchName: batchName, status: status);
  }
}

extension BatchEntityX on BatchEntity {
  BatchModel toModel() {
    return BatchModel(
      batchId: batchId ?? const Uuid().v4(),
      batchName: batchName,
      status: status ?? 'active',
    );
  }
}

extension BatchModelListX on List<BatchModel> {
  List<BatchEntity> toEntityList() => map((model) => model.toEntity()).toList();
}
