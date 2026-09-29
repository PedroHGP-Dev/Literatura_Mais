import 'dart:convert';
import 'package:http/http.dart' as http;

class BookCoverService {
  static final Map<String, String> _cache = {};

  static Future<String?> fetchCoverUrl(String title, String author) async {
    final key = '$title-$author';
    if (_cache.containsKey(key)) {
      return _cache[key];
    }

    final openLibraryUrl = await _fetchFromOpenLibrary(title, author);
    if (openLibraryUrl != null) {
      _cache[key] = openLibraryUrl;
      return openLibraryUrl;
    }

    final googleBooksUrl = await _fetchFromGoogleBooks(title, author);
    if (googleBooksUrl != null) {
      _cache[key] = googleBooksUrl;
      return googleBooksUrl;
    }

    return null;
  }

  static Future<String?> _fetchFromOpenLibrary(
    String title,
    String author,
  ) async {
    final query = Uri.encodeComponent('$title $author');
    final url = Uri.parse(
      'https://openlibrary.org/search.json?q=$query&limit=3',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['docs'] != null && (data['docs'] as List).isNotEmpty) {
          for (var doc in data['docs']) {
            if (doc['cover_i'] != null) {
              final coverId = doc['cover_i'];
              return 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
            }
          }
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<String?> _fetchFromGoogleBooks(
    String title,
    String author,
  ) async {
    final query = Uri.encodeComponent('$title $author');
    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=$query&maxResults=1',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] != null && (data['items'] as List).isNotEmpty) {
          final volumeInfo = data['items'][0]['volumeInfo'];
          if (volumeInfo != null && volumeInfo['imageLinks'] != null) {
            final imageLinks = volumeInfo['imageLinks'];
            String? cover =
                imageLinks['thumbnail'] ?? imageLinks['smallThumbnail'];
            if (cover != null) {
              return cover.replaceAll('http://', 'https://');
            }
          }
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
