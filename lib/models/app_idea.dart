import 'package:my_idea_pool/shared/common_utils.dart';

class AppIdea {
  String id;
  String content;
  String impact;
  String ease;
  String confidence;
  double average_score;
  String created_at;
  AppIdea({
    this.id,
    this.content,
    this.impact,
    this.ease,
    this.confidence,
    this.average_score,
    this.created_at,
  });

  AppIdea.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"] as String,
        content = map["content"] as String,
        impact = (map["impact"] as int).toString(),
        ease = (map["ease"] as int).toString(),
        confidence = (map["confidence"] as int).toString(),
        average_score = map["average_score"] as double,
        created_at = _formatCreatedAt(map["created_at"]);

  static _formatCreatedAt(int created_at) {
    return created_at != null
        ? CommonUtils.getFormattedDate(
            date: DateTime.fromMillisecondsSinceEpoch(created_at * 1000))
        : "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['content'] = content;
    data['impact'] = impact;
    data['ease'] = ease;
    data['confidence'] = confidence;
    data['average_score'] = average_score;
    data['created_at'] = created_at;
    return data;
  }

  Map<String, dynamic> toRequestJson() {
    Map<String, dynamic> data = toJson();
    data.remove('id');
    data.remove('average_score');
    data.remove('created_at');
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
