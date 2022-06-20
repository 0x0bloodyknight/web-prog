import 'package:json_annotation/json_annotation.dart';

part 'announcement.g.dart';

@JsonSerializable()
class Announcement {
  int? id;
  String? author;
  int? authorid;
  String tittle;
  String content;
  bool? isLocal;

  Announcement({
    this.id,
    this.author,
    required this.tittle,
    required this.content,
    this.isLocal,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);

  Map<String, dynamic> toJson() => _$AnnouncementToJson(this);
}
