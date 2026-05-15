//"t9q4le"
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/story_model.dart';
import '../providers/story_provider.dart';
import '../utils/constants.dart';
import '../widgets/comment_widget.dart';
import 'webview_screen.dart';

class DetailScreen extends StatefulWidget {
  final StoryModel story;

  const DetailScreen({
    super.key,
    required this.story,
  });

  @override
  State<DetailScreen> createState() =>
      _DetailScreenState();
}

class _DetailScreenState
    extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<StoryProvider>()
          .fetchComments(
            widget.story.kids,
          );
    });
  }

  @override
  void dispose() {
    context
        .read<StoryProvider>()
        .clearComments();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Details'),
      ),
      body: Consumer<StoryProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(
                  AppConstants
                      .screenPadding,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      widget.story.title ??
                          '',
                      style:
                          AppTextStyles
                              .titleStyle,
                    ),

                    const SizedBox(
                        height: 12),

                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 18,
                          color:
                              Colors.grey,
                        ),

                        const SizedBox(
                            width: 4),

                        Text(
                          widget.story.by ??
                              '',
                          style:
                              AppTextStyles
                                  .subtitleStyle,
                        ),

                        const Spacer(),

                        const Icon(
                          Icons
                              .arrow_upward,
                          size: 18,
                          color:
                              Colors.orange,
                        ),

                        const SizedBox(
                            width: 4),

                        Text(
                          '${widget.story.score ?? 0}',
                          style:
                              AppTextStyles
                                  .subtitleStyle,
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 16),

                    if (widget.story.url !=
                        null)
                      SizedBox(
                        width:
                            double.infinity,
                        child:
                            ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        WebViewScreen(
                                  title:
                                      widget
                                              .story
                                              .title ??
                                          '',
                                  url:
                                      widget
                                              .story
                                              .url ??
                                          '',
                                ),
                              ),
                            );
                          },
                          child:
                              const Text(
                            'Open Article',
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const Divider(),

              Expanded(
                child:
                    provider.isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator(),
                          )
                        : provider
                                .comments
                                .isEmpty
                            ? const Center(
                                child:
                                    Text(
                                  'No comments available',
                                ),
                              )
                            : ListView.builder(
                                itemCount:
                                    provider
                                        .comments
                                        .length,
                                itemBuilder:
                                    (
                                  context,
                                  index,
                                ) {
                                  final comment =
                                      provider
                                              .comments[
                                          index];

                                  return CommentWidget(
                                    comment:
                                        comment,
                                  );
                                },
                              ),
              ),
            ],
          );
        },
      ),
    );
  }
}

