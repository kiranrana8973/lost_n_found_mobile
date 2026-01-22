import 'package:equatable/equatable.dart';

enum ItemType { lost, found }

class ItemEntity extends Equatable {
  final String? itemId;
  final String? reportedBy; // ref to user who reported
  final String? claimedBy; // ref to user who claimed
  final String? categoryId; // ref to category
  final String itemName;
  final String? description;
  final ItemType type; // lost or found
  final String location;
  final String? media; // image/file path
  final String? mediaType; // image, video, etc.
  final bool isClaimed;
  final String? status;

  const ItemEntity({
    this.itemId,
    this.reportedBy,
    this.claimedBy,
    this.categoryId,
    required this.itemName,
    this.description,
    required this.type,
    required this.location,
    this.media,
    this.mediaType,
    this.isClaimed = false,
    this.status,
  });

  @override
  List<Object?> get props => [
        itemId,
        reportedBy,
        claimedBy,
        categoryId,
        itemName,
        description,
        type,
        location,
        media,
        mediaType,
        isClaimed,
        status,
      ];
}
