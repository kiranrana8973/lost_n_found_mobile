import 'package:equatable/equatable.dart';

enum ItemType { lost, found }

class ItemEntity extends Equatable {
  final String? itemId;
  final String? reportedBy;
  final String? claimedBy;
  final String? category;
  final String itemName;
  final String? description;
  final ItemType type;
  final String location;
  final String? media;
  final String? mediaType;
  final bool isClaimed;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ItemEntity({
    this.itemId,
    this.reportedBy,
    this.claimedBy,
    this.category,
    required this.itemName,
    this.description,
    required this.type,
    required this.location,
    this.media,
    this.mediaType,
    this.isClaimed = false,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  bool get isVideo {
    if (mediaType == 'video') return true;
    if (media == null) return false;
    final ext = media!.split('.').last.toLowerCase();
    return const {'mp4', 'mov', 'avi', 'mkv', 'webm'}.contains(ext);
  }

  @override
  List<Object?> get props => [
    itemId,
    reportedBy,
    claimedBy,
    category,
    itemName,
    description,
    type,
    location,
    media,
    mediaType,
    isClaimed,
    status,
    createdAt,
    updatedAt,
  ];
}
