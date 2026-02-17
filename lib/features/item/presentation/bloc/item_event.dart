import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../domain/entities/item_entity.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object?> get props => [];
}

class ItemGetAllEvent extends ItemEvent {
  const ItemGetAllEvent();
}

class ItemGetByIdEvent extends ItemEvent {
  final String itemId;

  const ItemGetByIdEvent({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class ItemGetMyItemsEvent extends ItemEvent {
  final String userId;

  const ItemGetMyItemsEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ItemCreateEvent extends ItemEvent {
  final String itemName;
  final String? description;
  final String? category;
  final String location;
  final ItemType type;
  final String? reportedBy;
  final String? media;
  final String? mediaType;

  const ItemCreateEvent({
    required this.itemName,
    this.description,
    this.category,
    required this.location,
    required this.type,
    this.reportedBy,
    this.media,
    this.mediaType,
  });

  @override
  List<Object?> get props => [itemName, description, category, location, type, reportedBy, media, mediaType];
}

class ItemUpdateEvent extends ItemEvent {
  final String itemId;
  final String itemName;
  final String? description;
  final String? category;
  final String location;
  final ItemType type;
  final String? claimedBy;
  final String? media;
  final String? mediaType;
  final bool? isClaimed;
  final String? status;

  const ItemUpdateEvent({
    required this.itemId,
    required this.itemName,
    this.description,
    this.category,
    required this.location,
    required this.type,
    this.claimedBy,
    this.media,
    this.mediaType,
    this.isClaimed,
    this.status,
  });

  @override
  List<Object?> get props => [itemId, itemName, description, category, location, type, claimedBy, media, mediaType, isClaimed, status];
}

class ItemDeleteEvent extends ItemEvent {
  final String itemId;

  const ItemDeleteEvent({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class ItemUploadPhotoEvent extends ItemEvent {
  final File photo;

  const ItemUploadPhotoEvent({required this.photo});

  @override
  List<Object?> get props => [photo];
}

class ItemUploadVideoEvent extends ItemEvent {
  final File video;

  const ItemUploadVideoEvent({required this.video});

  @override
  List<Object?> get props => [video];
}

class ItemClearErrorEvent extends ItemEvent {
  const ItemClearErrorEvent();
}

class ItemClearSelectedEvent extends ItemEvent {
  const ItemClearSelectedEvent();
}

class ItemClearReportStateEvent extends ItemEvent {
  const ItemClearReportStateEvent();
}
