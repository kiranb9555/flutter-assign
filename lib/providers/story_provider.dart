//"g38mkl"
import 'package:flutter/material.dart';

import '../models/story_model.dart';
import '../services/hacker_news_service.dart';

class StoryProvider extends ChangeNotifier {
  final HackerNewsService _service = HackerNewsService();

  List<StoryModel> _stories = [];
  List<StoryModel> _comments = [];

  bool _isLoading = false;
  String? _errorMessage;

  List<StoryModel> get stories => _stories;

  List<StoryModel> get comments => _comments;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  /// Fetch top stories
  Future<void> fetchTopStories() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _stories = await _service.fetchTopStories();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      _stories = [];
      notifyListeners();
    }
  }

  /// Fetch comments for detail screen
  Future<void> fetchComments(List<dynamic>? ids) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _comments = await _service.fetchComments(ids);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      _comments = [];
      notifyListeners();
    }
  }

  /// Clear comments when leaving detail page
  void clearComments() {
    _comments = [];
    notifyListeners();
  }
}

