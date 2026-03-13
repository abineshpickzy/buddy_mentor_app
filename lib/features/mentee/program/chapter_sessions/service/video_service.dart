class VideoService {
  static String? getVideoEmbedUrl(String? cloudflareUid) {
    if (cloudflareUid == null) return null;
    return 'https://iframe.videodelivery.net/$cloudflareUid'
        '?autoplay=false&controls=true&preload=auto';
  }
}