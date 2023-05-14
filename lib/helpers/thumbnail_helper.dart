String getYoutubeThumbnail(String videoUrl) {
  final Uri? uri = Uri.tryParse(videoUrl);
  if (uri == null) {
    return '';
  }

  return 'https://img.youtube.com/vi/${uri.queryParameters['v']}/maxresdefault.jpg';
}
