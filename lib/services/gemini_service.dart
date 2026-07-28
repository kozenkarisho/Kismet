import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/space_item.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService({required String apiKey})
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
        );

  /// Generate a 2-sentence summary and 3 keyword tags for a saved link.
  Future<({String summary, List<String> tags})> enrichLink({
    required String url,
    required String title,
    String? note,
  }) async {
    final prompt = '''
You are a personal knowledge assistant. A user saved this link to their knowledge vault.

URL: $url
Title: $title
${note != null && note.isNotEmpty ? 'Personal note: $note' : ''}

Respond with ONLY valid JSON in this exact format (no markdown, no code blocks):
{
  "summary": "Two sentences describing what this content is about and why it might be valuable.",
  "tags": ["tag1", "tag2", "tag3"]
}

Keep tags lowercase, single words or short phrases. Make them descriptive and useful for search.
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';

      // Extract JSON from response
      final jsonStart = text.indexOf('{');
      final jsonEnd = text.lastIndexOf('}');
      if (jsonStart == -1 || jsonEnd == -1) {
        return (summary: 'A saved link from your vault.', tags: ['link']);
      }

      final jsonStr = text.substring(jsonStart, jsonEnd + 1);
      // Basic JSON parse
      final summaryMatch = RegExp(r'"summary"\s*:\s*"([^"]*)"').firstMatch(jsonStr);
      final tagsMatch = RegExp(r'"tags"\s*:\s*\[([^\]]*)\]').firstMatch(jsonStr);

      final summary = summaryMatch?.group(1) ?? 'A saved link from your vault.';
      final tagsRaw = tagsMatch?.group(1) ?? '';
      final tags = tagsRaw
          .split(',')
          .map((t) => t.trim().replaceAll('"', '').replaceAll("'", ''))
          .where((t) => t.isNotEmpty)
          .take(3)
          .toList();

      return (summary: summary, tags: tags.isEmpty ? ['link'] : tags);
    } catch (e) {
      return (summary: 'A saved link from your vault.', tags: ['link']);
    }
  }

  /// Semantic search — finds relevant links for a natural language query.
  Future<List<LinkItem>> searchSemantically({
    required String query,
    required List<LinkItem> allLinks,
  }) async {
    if (allLinks.isEmpty) return [];

    final linksList = allLinks
        .take(50)
        .map((l) => '- [${l.id}] ${l.title}: ${l.summary ?? ''} ${l.keywords?.join(', ') ?? ''}')
        .join('\n');

    final prompt = '''
A user is searching their personal knowledge vault.
Query: "$query"

Here are their saved links:
$linksList

Return ONLY a JSON array of the IDs of the most relevant links (max 10), ordered by relevance.
Example: ["id1", "id2", "id3"]
If nothing is relevant, return an empty array: []
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';

      final arrayStart = text.indexOf('[');
      final arrayEnd = text.lastIndexOf(']');
      if (arrayStart == -1 || arrayEnd == -1) return [];

      final arrayStr = text.substring(arrayStart, arrayEnd + 1);
      final ids = RegExp(r'"([^"]+)"')
          .allMatches(arrayStr)
          .map((m) => m.group(1)!)
          .toList();

      return allLinks.where((l) => ids.contains(l.id)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Generate insight cards for the Dive In screen.
  Future<List<Map<String, String>>> generateDiveInInsights({
    required List<LinkItem> allLinks,
  }) async {
    if (allLinks.isEmpty) {
      return [
        {'title': 'Start saving links!', 'insight': 'Your Dive In feed will populate as you save links to your Mind Spaces.', 'emoji': '✨'},
      ];
    }

    final linksList = allLinks
        .take(30)
        .map((l) => '${l.title}: ${l.summary ?? ''}')
        .join('\n');

    final prompt = '''
A user has saved these links to their personal knowledge vault:
$linksList

Generate 6 interesting insight cards about their saved content. Each card should surface a pattern, theme, or interesting connection between the links.

Respond with ONLY valid JSON array:
[
  {"title": "Short catchy title", "insight": "1-2 sentence insight about their saved content.", "emoji": "relevant emoji"},
  ...
]
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      final text = response.text ?? '';

      final arrayStart = text.indexOf('[');
      final arrayEnd = text.lastIndexOf(']');
      if (arrayStart == -1 || arrayEnd == -1) return _fallbackInsights();

      final arrayStr = text.substring(arrayStart, arrayEnd + 1);
      final results = <Map<String, String>>[];

      // Parse each object
      final objectPattern = RegExp(r'\{[^}]+\}', dotAll: true);
      for (final match in objectPattern.allMatches(arrayStr)) {
        final obj = match.group(0)!;
        final titleMatch = RegExp(r'"title"\s*:\s*"([^"]*)"').firstMatch(obj);
        final insightMatch = RegExp(r'"insight"\s*:\s*"([^"]*)"').firstMatch(obj);
        final emojiMatch = RegExp(r'"emoji"\s*:\s*"([^"]*)"').firstMatch(obj);

        if (titleMatch != null && insightMatch != null) {
          results.add({
            'title': titleMatch.group(1) ?? '',
            'insight': insightMatch.group(1) ?? '',
            'emoji': emojiMatch?.group(1) ?? '💡',
          });
        }
      }

      return results.isEmpty ? _fallbackInsights() : results.take(6).toList();
    } catch (e) {
      return _fallbackInsights();
    }
  }

  List<Map<String, String>> _fallbackInsights() {
    return [
      {'title': 'Keep Saving!', 'insight': 'Add more links to your Mind Spaces to unlock AI-powered insights.', 'emoji': '🔮'},
      {'title': 'Explore Your Vault', 'insight': 'Visit your Mind Spaces to rediscover content you\'ve saved.', 'emoji': '🗺️'},
    ];
  }
}
