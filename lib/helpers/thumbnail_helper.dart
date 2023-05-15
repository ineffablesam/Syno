String getYoutubeThumbnail(String videoUrl) {
  final Uri? uri = Uri.tryParse(videoUrl);
  if (uri == null) {
    return '';
  }

  String videoId = '';

  if (uri.host == 'www.youtube.com') {
    videoId = uri.queryParameters['v'] ?? '';
  } else if (uri.host == 'youtu.be') {
    videoId = uri.pathSegments.first;
  }

  if (videoId.isEmpty) {
    return '';
  }

  return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
}
