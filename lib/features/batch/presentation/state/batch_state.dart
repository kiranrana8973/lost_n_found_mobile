import 'package:equatable/equatable.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';

enum BatchStatus { initial, loading, loaded, error, created, updated, deleted }

class BatchState extends Equatable {
  final BatchStatus status;
  final List<BatchEntity> batches;
  final BatchEntity? selectedBatch;
  final String? errorMessage;

  const BatchState({
    this.status = BatchStatus.initial,
    this.batches = const [],
    this.selectedBatch,
    this.errorMessage,
  });

  BatchState copyWith({
    BatchStatus? status,
    List<BatchEntity>? batches,
    BatchEntity? selectedBatch,
    bool clearSelectedBatch = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return BatchState(
      status: status ?? this.status,
      batches: batches ?? this.batches,
      selectedBatch: clearSelectedBatch
          ? null
          : (selectedBatch ?? this.selectedBatch),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, batches, selectedBatch, errorMessage];
}
