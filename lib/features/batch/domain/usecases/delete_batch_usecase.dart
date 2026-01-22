import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/batch/data/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';

class DeleteBatchParams extends Equatable {
  final String batchId;

  const DeleteBatchParams({required this.batchId});

  @override
  List<Object?> get props => [batchId];
}

// Create Provider
final deleteBatchUsecaseProvider = Provider<DeleteBatchUsecase>((ref) {
  final batchRepository = ref.read(batchRepositoryProvider);
  return DeleteBatchUsecase(batchRepository: batchRepository);
});

class DeleteBatchUsecase implements UsecaseWithParms<bool, DeleteBatchParams> {
  final IBatchRepository _batchRepository;

  DeleteBatchUsecase({required IBatchRepository batchRepository})
    : _batchRepository = batchRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteBatchParams params) {
    return _batchRepository.deleteBatch(params.batchId);
  }
}
