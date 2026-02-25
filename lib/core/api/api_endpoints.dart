import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice = false;

  static const String _ipAddress = '192.168.1.1';

  static const int _port = 3000;

  static String get _host {
    if (isPhysicalDevice) return _ipAddress;
    if (kIsWeb || Platform.isIOS) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get serverUrl => 'http://$_host:$_port';

  static String get baseUrl => '$serverUrl/api/v1';

  static String get mediaServerUrl => serverUrl;

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String studentLogin = '/students/login';
  static const String studentRegister = '/students/register';
  static const String studentMe = '/students/me';
  static const String refreshToken = '/auth/refresh';

  static const String students = '/students';
  static String studentById(String id) => '/students/${_encode(id)}';
  static String studentPhoto(String id) => '/students/${_encode(id)}/photo';
  static String studentProfilePicture(String filename) =>
      '$mediaServerUrl/profile_pictures/${_encode(filename)}';

  static const String batches = '/batches';
  static String batchById(String id) => '/batches/${_encode(id)}';

  static const String categories = '/categories';
  static String categoryById(String id) => '/categories/${_encode(id)}';

  static const String items = '/items';
  static String itemById(String id) => '/items/${_encode(id)}';
  static String itemClaim(String id) => '/items/${_encode(id)}/claim';
  static const String itemUploadPhoto = '/items/upload-photo';
  static const String itemUploadVideo = '/items/upload-video';
  static String itemPicture(String filename) =>
      '$mediaServerUrl/item_photos/${_encode(filename)}';
  static String itemVideo(String filename) =>
      '$mediaServerUrl/item_videos/${_encode(filename)}';

  static String itemSearch(String query) => '/items?q=${_encode(query)}';

  static const String comments = '/comments';
  static String commentById(String id) => '/comments/${_encode(id)}';
  static String commentsByItem(String itemId) =>
      '/comments/item/${_encode(itemId)}';
  static String commentLike(String id) => '/comments/${_encode(id)}/like';

  static String _encode(String component) => Uri.encodeComponent(component);
}
