import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String? categoryId;
  final String name;
  final String? description;
  final String? status;

  const CategoryEntity({
    this.categoryId,
    required this.name,
    this.description,
    this.status,
  });

  @override
  List<Object?> get props => [categoryId, name, description, status];
}
