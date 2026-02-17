import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_batch_usecase.dart';
import '../../domain/usecases/delete_batch_usecase.dart';
import '../../domain/usecases/get_all_batch_usecase.dart';
import '../../domain/usecases/get_batch_byid_usecase.dart';
import '../../domain/usecases/update_batch_usecase.dart';
import '../state/batch_state.dart';
import 'batch_event.dart';

class BatchBloc extends Bloc<BatchEvent, BatchState> {
  final GetAllBatchUsecase _getAllBatchUsecase;
  final GetBatchByIdUsecase _getBatchByIdUsecase;
  final CreateBatchUsecase _createBatchUsecase;
  final UpdateBatchUsecase _updateBatchUsecase;
  final DeleteBatchUsecase _deleteBatchUsecase;

  BatchBloc({
    required GetAllBatchUsecase getAllBatchUsecase,
    required GetBatchByIdUsecase getBatchByIdUsecase,
    required CreateBatchUsecase createBatchUsecase,
    required UpdateBatchUsecase updateBatchUsecase,
    required DeleteBatchUsecase deleteBatchUsecase,
  })  : _getAllBatchUsecase = getAllBatchUsecase,
        _getBatchByIdUsecase = getBatchByIdUsecase,
        _createBatchUsecase = createBatchUsecase,
        _updateBatchUsecase = updateBatchUsecase,
        _deleteBatchUsecase = deleteBatchUsecase,
        super(const BatchState()) {
    on<BatchGetAllEvent>(_onGetAll);
    on<BatchGetByIdEvent>(_onGetById);
    on<BatchCreateEvent>(_onCreate);
    on<BatchUpdateEvent>(_onUpdate);
    on<BatchDeleteEvent>(_onDelete);
    on<BatchClearErrorEvent>(_onClearError);
    on<BatchClearSelectedEvent>(_onClearSelected);
  }

  Future<void> _onGetAll(
    BatchGetAllEvent event,
    Emitter<BatchState> emit,
  ) async {
    emit(state.copyWith(status: BatchStatus.loading));

    final result = await _getAllBatchUsecase();

    result.fold(
      (failure) => emit(state.copyWith(
        status: BatchStatus.error,
        errorMessage: failure.message,
      )),
      (batches) => emit(state.copyWith(
        status: BatchStatus.loaded,
        batches: batches,
      )),
    );
  }

  Future<void> _onGetById(
    BatchGetByIdEvent event,
    Emitter<BatchState> emit,
  ) async {
    emit(state.copyWith(status: BatchStatus.loading));

    final result = await _getBatchByIdUsecase(
      GetBatchByIdParams(batchId: event.batchId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: BatchStatus.error,
        errorMessage: failure.message,
      )),
      (batch) => emit(state.copyWith(
        status: BatchStatus.loaded,
        selectedBatch: batch,
      )),
    );
  }

  Future<void> _onCreate(
    BatchCreateEvent event,
    Emitter<BatchState> emit,
  ) async {
    emit(state.copyWith(status: BatchStatus.loading));

    final result = await _createBatchUsecase(
      CreateBatchParams(batchName: event.batchName),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: BatchStatus.error,
        errorMessage: failure.message,
      )),
      (success) {
        emit(state.copyWith(status: BatchStatus.created));
        add(const BatchGetAllEvent());
      },
    );
  }

  Future<void> _onUpdate(
    BatchUpdateEvent event,
    Emitter<BatchState> emit,
  ) async {
    emit(state.copyWith(status: BatchStatus.loading));

    final result = await _updateBatchUsecase(
      UpdateBatchParams(
        batchId: event.batchId,
        batchName: event.batchName,
        status: event.status,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: BatchStatus.error,
        errorMessage: failure.message,
      )),
      (success) {
        emit(state.copyWith(status: BatchStatus.updated));
        add(const BatchGetAllEvent());
      },
    );
  }

  Future<void> _onDelete(
    BatchDeleteEvent event,
    Emitter<BatchState> emit,
  ) async {
    emit(state.copyWith(status: BatchStatus.loading));

    final result = await _deleteBatchUsecase(
      DeleteBatchParams(batchId: event.batchId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: BatchStatus.error,
        errorMessage: failure.message,
      )),
      (success) {
        emit(state.copyWith(status: BatchStatus.deleted));
        add(const BatchGetAllEvent());
      },
    );
  }

  void _onClearError(
    BatchClearErrorEvent event,
    Emitter<BatchState> emit,
  ) {
    emit(state.copyWith(clearErrorMessage: true));
  }

  void _onClearSelected(
    BatchClearSelectedEvent event,
    Emitter<BatchState> emit,
  ) {
    emit(state.copyWith(clearSelectedBatch: true));
  }
}
