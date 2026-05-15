//"n7w2ae"
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/story_model.dart';

class HackerNewsService {
  static const String baseUrl =
      'https://hacker-news.firebaseio.com/v0';
  static const Duration _timeout = Duration(seconds: 15);
  static const int _batchSize = 10;

  final http.Client _client;

  HackerNewsService({http.Client? client})
      : _client = client ?? http.Client();

  Future<http.Response> _get(String path) {
    return _client
        .get(Uri.parse('$baseUrl$path'))
        .timeout(_timeout);
  }

  /// Fetch top story IDs
  Future<List<int>> fetchTopStoryIds() async {
    final response = await _get('/topstories.json');

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to fetch top stories (${response.statusCode})',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Unexpected response from Hacker News API');
    }

    return decoded.map((e) => e as int).toList();
  }

  /// Fetch single story/item; returns null if missing or invalid.
  Future<StoryModel?> fetchStoryOrNull(int id) async {
    try {
      final response = await _get('/item/$id.json');

      if (response.statusCode != 200) {
        return null;
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      return StoryModel.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  /// Fetch single story/item
  Future<StoryModel> fetchStory(int id) async {
    final story = await fetchStoryOrNull(id);
    if (story == null) {
      throw Exception('Failed to fetch story $id');
    }
    return story;
  }

  /// Fetch multiple stories for home screen
  Future<List<StoryModel>> fetchTopStories({
    int limit = 20,
  }) async {
    final ids = await fetchTopStoryIds();
    if (ids.isEmpty) {
      throw Exception('Hacker News returned no story IDs');
    }

    final stories = <StoryModel>[];
    var index = 0;

    while (stories.length < limit && index < ids.length) {
      final batch = ids
          .skip(index)
          .take(_batchSize)
          .toList();
      index += batch.length;

      final batchStories = await Future.wait(
        batch.map(fetchStoryOrNull),
      );

      for (final story in batchStories) {
        if (story != null && story.isVisible) {
          stories.add(story);
          if (stories.length >= limit) {
            break;
          }
        }
      }
    }

    if (stories.isEmpty) {
      throw Exception(
        'Could not load any stories. Check your internet connection.',
      );
    }

    return stories;
  }

  /// Fetch comments recursively
  Future<List<StoryModel>> fetchComments(
    List<dynamic>? commentIds,
  ) async {
    if (commentIds == null || commentIds.isEmpty) {
      return [];
    }

    final comments = <StoryModel>[];

    for (final id in commentIds) {
      final comment = await fetchStoryOrNull(id as int);
      if (comment != null && comment.text != null) {
        comments.add(comment);
      }
    }

    return comments;
  }

  void dispose() {
    _client.close();
  }
}
