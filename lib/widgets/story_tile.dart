//"v5u1nk"
import 'package:flutter/material.dart';

import '../models/story_model.dart';
import '../utils/constants.dart';

class StoryTile extends StatelessWidget {
  final StoryModel story;
  final VoidCallback onTap;

  const StoryTile({
    super.key,
    required this.story,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppConstants.cardRadius,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          AppConstants.cardRadius,
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(
            AppConstants.screenPadding,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                story.title ?? 'No Title',
                style: AppTextStyles.titleStyle,
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 18,
                    color: Colors.grey,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    story.by ?? 'Unknown',
                    style:
                        AppTextStyles.subtitleStyle,
                  ),

                  const Spacer(),

                  const Icon(
                    Icons.arrow_upward,
                    size: 18,
                    color: Colors.orange,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    '${story.score ?? 0}',
                    style:
                        AppTextStyles.subtitleStyle,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(
                    Icons.comment,
                    size: 18,
                    color: Colors.blueGrey,
                  ),

                  const SizedBox(width: 4),

                  Text(
                    '${story.descendants ?? 0} comments',
                    style:
                        AppTextStyles.subtitleStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

