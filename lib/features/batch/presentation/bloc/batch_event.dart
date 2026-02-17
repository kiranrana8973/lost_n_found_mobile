import 'package:equatable/equatable.dart';

abstract class BatchEvent extends Equatable {
  const BatchEvent();

  @override
  List<Object?> get props => [];
}

class BatchGetAllEvent extends BatchEvent {
  const BatchGetAllEvent();
}

class BatchGetByIdEvent extends BatchEvent {
  final String batchId;

  const BatchGetByIdEvent({required this.batchId});

  @override
  List<Object?> get props => [batchId];
}

class BatchCreateEvent extends BatchEvent {
  final String batchName;

  const BatchCreateEvent({required this.batchName});

  @override
  List<Object?> get props => [batchName];
}

class BatchUpdateEvent extends BatchEvent {
  final String batchId;
  final String batchName;
  final String? status;

  const BatchUpdateEvent({
    required this.batchId,
    required this.batchName,
    this.status,
  });

  @override
  List<Object?> get props => [batchId, batchName, status];
}

class BatchDeleteEvent extends BatchEvent {
  final String batchId;

  const BatchDeleteEvent({required this.batchId});

  @override
  List<Object?> get props => [batchId];
}

class BatchClearErrorEvent extends BatchEvent {
  const BatchClearErrorEvent();
}

class BatchClearSelectedEvent extends BatchEvent {
  const BatchClearSelectedEvent();
}
