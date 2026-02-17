import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class CategoryGetAllEvent extends CategoryEvent {
  const CategoryGetAllEvent();
}

class CategoryGetByIdEvent extends CategoryEvent {
  final String categoryId;

  const CategoryGetByIdEvent({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class CategoryCreateEvent extends CategoryEvent {
  final String name;
  final String? description;

  const CategoryCreateEvent({required this.name, this.description});

  @override
  List<Object?> get props => [name, description];
}

class CategoryUpdateEvent extends CategoryEvent {
  final String categoryId;
  final String name;
  final String? description;
  final String? status;

  const CategoryUpdateEvent({
    required this.categoryId,
    required this.name,
    this.description,
    this.status,
  });

  @override
  List<Object?> get props => [categoryId, name, description, status];
}

class CategoryDeleteEvent extends CategoryEvent {
  final String categoryId;

  const CategoryDeleteEvent({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class CategoryClearErrorEvent extends CategoryEvent {
  const CategoryClearErrorEvent();
}

class CategoryClearSelectedEvent extends CategoryEvent {
  const CategoryClearSelectedEvent();
}
