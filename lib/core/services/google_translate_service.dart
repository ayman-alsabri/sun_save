import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GoogleTranslateService {
  final http.Client _client;

  GoogleTranslateService({http.Client? client})
    : _client = client ?? http.Client();

  Future<List<String>> translate({
    required String text,
    String source = 'en',
    String target = 'ar',
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return const [];

    final uri =
        Uri.https('translation.googleapis.com', '/language/translate/v2', {
          'key': dotenv.env['GT_API_KEY'] ?? '',
          'q': trimmed,
          'source': source,
          'target': target,
          'format': 'text',
        });

    final res = await _client.get(uri);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('translate_http_${res.statusCode}');
    }

    final data = jsonDecode(res.body);
    final translations =
        (data['data']?['translations'] as List?)?.cast<Map>() ?? const <Map>[];

    return translations
        .map((t) => (t['translatedText'] as String?)?.trim() ?? '')
        .where((s) => s.isNotEmpty)
        .toList(growable: false);
  }
}
