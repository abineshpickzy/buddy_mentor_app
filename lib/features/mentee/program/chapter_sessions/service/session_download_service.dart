import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:buddymentor/core/network/dio_client.dart';
import 'package:buddymentor/features/auth/data/services/storage_service.dart';

class SessionDownloadService {
  static Future<Dio> _buildDio() async {
    final dio = Dio(BaseOptions(
      baseUrl: DioClient.dio.options.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 60),
    ));
    final token = await StorageService.getAccessToken();
    final user  = await StorageService.getUser();
    if (token != null) dio.options.headers['Authorization'] = 'Bearer $token';
    if (user?.uuid != null) dio.options.headers['X-User-UUID'] = user!.uuid!;
    return dio;
  }

  /// Fetches file bytes for preview
  static Future<Uint8List> fetchBytes({
    required int programType,
    required String nodeId,
    required String assetId,
  }) async {
    final dio = await _buildDio();
    final response = await dio.post(
      'prgm/ast/dwld',
      data: {'type': programType, 'node_id': nodeId, 'asset_id': assetId},
      options: Options(responseType: ResponseType.bytes),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch file: ${response.statusCode}');
    }
    return Uint8List.fromList(response.data as List<int>);
  }

  /// Saves bytes to phone's Downloads folder
  static Future<String> saveToDownloads({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final savePath = await _getSavePath(fileName);
    debugPrint('💾 Saving to: $savePath');
    await File(savePath).writeAsBytes(bytes, flush: true);
    debugPrint('✅ Saved successfully');
    return savePath;
  }

  static Future<String> _getSavePath(String fileName) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      debugPrint('📱 Android SDK: $sdkInt');

      if (sdkInt >= 30) {
        // Android 11+ — no permission needed
        final dir = await getExternalStorageDirectory();
        if (dir != null) {
          final downloadsDir = Directory('${dir.path}/Downloads');
          if (!await downloadsDir.exists()) {
            await downloadsDir.create(recursive: true);
          }
          return _uniquePath(downloadsDir.path, fileName);
        }
      } else {
        // ✅ Android 10 (SDK 29) AND below — need runtime permission
        final status = await Permission.storage.request();
        debugPrint('📂 Storage permission: $status');

        if (status.isGranted) {
          const downloadPath = '/storage/emulated/0/Download';
          final dir = Directory(downloadPath);
          if (!await dir.exists()) await dir.create(recursive: true);
          return _uniquePath(downloadPath, fileName);
        } else if (status.isPermanentlyDenied) {
          await openAppSettings();
          throw Exception('Storage permission permanently denied. Please enable it in Settings.');
        } else {
          throw Exception('Storage permission denied.');
        }
      }

      // Fallback
      final appDir = await getApplicationDocumentsDirectory();
      return _uniquePath(appDir.path, fileName);
    } else {
      // iOS
      final dir = await getApplicationDocumentsDirectory();
      return _uniquePath(dir.path, fileName);
    }
  }

  static String _uniquePath(String dirPath, String fileName) {
    String path = '$dirPath/$fileName';
    if (!File(path).existsSync()) return path;
    final dot  = fileName.lastIndexOf('.');
    final name = dot != -1 ? fileName.substring(0, dot) : fileName;
    final ext  = dot != -1 ? fileName.substring(dot)    : '';
    int count  = 1;
    while (File(path).existsSync()) {
      path = '$dirPath/$name($count)$ext';
      count++;
    }
    return path;
  }
}