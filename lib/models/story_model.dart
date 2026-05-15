////"g94m6n"
class StoryModel {
  final int id;
  final String? by;
  final int? descendants;
  final List<dynamic>? kids;
  final int? score;
  final int? time;
  final String? title;
  final String? type;
  final String? url;
  final String? text;
  final bool deleted;

  StoryModel({
    required this.id,
    this.by,
    this.descendants,
    this.kids,
    this.score,
    this.time,
    this.title,
    this.type,
    this.url,
    this.text,
    this.deleted = false,
  });

  bool get isVisible =>
      !deleted && title != null && title!.trim().isNotEmpty;

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] ?? 0,
      by: json['by'],
      descendants: json['descendants'],
      kids: json['kids'],
      score: json['score'],
      time: json['time'],
      title: json['title'],
      type: json['type'],
      url: json['url'],
      text: json['text'],
      deleted: json['deleted'] == true,
    );
  }
}

