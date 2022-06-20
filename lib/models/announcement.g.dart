// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
      id: json['id'] as int?,
      author: json['author'] as String?,
      tittle: json['tittle'] as String,
      content: json['content'] as String,
      isLocal: json['isLocal'] as bool?,
    )..authorid = json['authorid'] as int?;

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'authorid': instance.authorid,
      'tittle': instance.tittle,
      'content': instance.content,
      'isLocal': instance.isLocal,
    };
