//"w7s9da"
import 'package:flutter/material.dart';

import '../models/story_model.dart';
import '../services/hacker_news_service.dart';
import '../utils/constants.dart';

class CommentWidget extends StatefulWidget {
  final StoryModel comment;
  final int depth;

  const CommentWidget({
    super.key,
    required this.comment,
    this.depth = 0,
  });

  @override
  State<CommentWidget> createState() =>
      _CommentWidgetState();
}

class _CommentWidgetState
    extends State<CommentWidget> {
  final HackerNewsService _service =
      HackerNewsService();

  List<StoryModel> nestedComments = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _loadNestedComments();
  }

  Future<void> _loadNestedComments() async {
    if (widget.comment.kids == null ||
        widget.comment.kids!.isEmpty) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    nestedComments =
        await _service.fetchComments(
      widget.comment.kids,
    );

    setState(() {
      isLoading = false;
    });
  }

  String _cleanHtml(String? text) {
    if (text == null) return '';

    return text
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&#x27;', "'")
        .replaceAll('&quot;', '"')
        .replaceAll('&gt;', '>')
        .replaceAll('&lt;', '<')
        .replaceAll('&amp;', '&');
  }

  @override
  Widget build(BuildContext context) {
    final marginLeft =
        widget.depth * 12.0;

    return Container(
      margin: EdgeInsets.only(
        left: marginLeft,
        right: 8,
        top: 8,
        bottom: 8,
      ),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius:
            BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person,
                size: 16,
                color: Colors.grey,
              ),

              const SizedBox(width: 4),

              Expanded(
                child: Text(
                  widget.comment.by ??
                      'Unknown User',
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            _cleanHtml(
              widget.comment.text,
            ),
            style:
                AppTextStyles.commentStyle,
          ),

          if (isLoading)
            const Padding(
              padding:
                  EdgeInsets.only(top: 10),
              child: SizedBox(
                height: 18,
                width: 18,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),

          if (nestedComments.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.only(
                top: 12,
              ),
              child: Column(
                children:
                    nestedComments.map(
                  (nestedComment) {
                    return CommentWidget(
                      comment:
                          nestedComment,
                      depth:
                          widget.depth + 1,
                    );
                  },
                ).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

