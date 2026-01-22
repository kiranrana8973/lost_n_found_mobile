import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/batch/data/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';

class GetBatchByIdParams extends Equatable {
  final String batchId;

  const GetBatchByIdParams({required this.batchId});

  @override
  List<Object?> get props => [batchId];
}

// Create Provider
final getBatchByIdUsecaseProvider = Provider<GetBatchByIdUsecase>((ref) {
  final batchRepository = ref.read(batchRepositoryProvider);
  return GetBatchByIdUsecase(batchRepository: batchRepository);
});

class GetBatchByIdUsecase
    implements UsecaseWithParms<BatchEntity, GetBatchByIdParams> {
  final IBatchRepository _batchRepository;

  GetBatchByIdUsecase({required IBatchRepository batchRepository})
    : _batchRepository = batchRepository;

  @override
  Future<Either<Failure, BatchEntity>> call(GetBatchByIdParams params) {
    return _batchRepository.getBatchById(params.batchId);
  }
}
