// lib/features/mentee/session_content/data/models/session_asset_model.dart

class SessionAsset {
  final String id;
  final String fileName;
  final String originalName;
  final String type; // "video", "docx", "image", "pdf", etc.
  final int reviewStatus;
  final String? cloudflareUid; // only for videos
  final int status;

  const SessionAsset({
    required this.id,
    required this.fileName,
    required this.originalName,
    required this.type,
    required this.reviewStatus,
    this.cloudflareUid,
    required this.status,
  });

  factory SessionAsset.fromJson(Map<String, dynamic> json) {
    return SessionAsset(
      id: json['_id'] as String,
      fileName: json['file_name'] as String,
      originalName: json['original_name'] as String,
      type: json['type'] as String,
      reviewStatus: json['review_status'] as int,
      cloudflareUid: json['cloudflare_uid'] as String?,
      status: json['status'] as int,
    );
  }

  bool get isVideo => type == 'video';
  bool get isImage => type == 'image';
  bool get isDocument => type == 'docx' || type == 'pdf' || type == 'doc';
}

class SessionContentResponse {
  final bool success;
  final String message;
  final String nodeId;
  final List<SessionAsset> assets;

  const SessionContentResponse({
    required this.success,
    required this.message,
    required this.nodeId,
    required this.assets,
  });

  factory SessionContentResponse.fromJson(Map<String, dynamic> json) {
    return SessionContentResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      nodeId: json['node_id'] as String,
      assets: (json['assets'] as List<dynamic>)
          .map((e) => SessionAsset.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  SessionAsset? get videoAsset {
    print('All assets: ${assets.map((a) => 'type: ${a.type}, cloudflareUid: ${a.cloudflareUid}').toList()}');
    final videos = assets.where((a) => a.isVideo).toList();
    print('Video assets found: ${videos.length}');
    return videos.isNotEmpty ? videos.first : null;
  }

  List<SessionAsset> get downloadableAssets =>
      assets.where((a) => !a.isVideo).toList();
}