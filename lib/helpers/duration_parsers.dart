import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> getVideoDurationFromUrl(String videoUrl, String apiKey) async {
  String videoId = _extractVideoId(videoUrl);
  if (videoId.isEmpty) {
    throw Exception('Invalid YouTube URL');
  }

  final apiUrl = Uri.https('www.googleapis.com', '/youtube/v3/videos', {
    'id': videoId,
    'part': 'contentDetails',
    'key': apiKey,
  });

  try {
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final jsonMap = json.decode(response.body);
      final duration = jsonMap['items'][0]['contentDetails']['duration'];
      return _convertDuration(duration);
    } else {
      throw Exception('Failed to load video duration');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

String _extractVideoId(String videoUrl) {
  Uri? uri = Uri.tryParse(videoUrl);

  if (uri != null) {
    if (uri.host == 'www.youtube.com') {
      return uri.queryParameters['v'] ?? '';
    } else if (uri.host == 'youtu.be') {
      return uri.pathSegments.first;
    }
  }

  return '';
}

String _convertDuration(String iso8601Duration) {
  final durationRegExp = RegExp(r'(\d+)([HMS])');
  final match = durationRegExp.allMatches(iso8601Duration);

  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  for (final m in match) {
    final value = int.parse(m.group(1)!);
    final unit = m.group(2);

    if (unit == 'H') {
      hours = value;
    } else if (unit == 'M') {
      minutes = value;
    } else if (unit == 'S') {
      seconds = value;
    }
  }

  final formattedDuration = '${hours.toString().padLeft(2, '0')}:'
      '${minutes.toString().padLeft(2, '0')}:'
      '${seconds.toString().padLeft(2, '0')}';

  return formattedDuration;
}
