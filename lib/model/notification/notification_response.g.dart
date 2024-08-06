// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationResponse _$NotificationResponseFromJson(Map<String, dynamic> json) {
  return NotificationResponse()
    ..id = json['id'] as int
    ..title = json['title'] as String
    ..text = json['text'] as String
    ..message = json['message'] as String
    ..user_id = json['user_id'] as String
    ..created_at = json['created_at'] as String
    ..updated_at = json['updated_at'] as String
    ..username = json['username'] as String
    ..photo = json['photo'] as String;
}

Map<String, dynamic> _$NotificationResponseToJson(
        NotificationResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'text': instance.text,
      'message': instance.message,
      'user_id': instance.user_id,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'username': instance.username,
      'photo': instance.photo,
    };

NotificationsAPI _$NotificationsAPIFromJson(Map<String, dynamic> json) {
  return NotificationsAPI()
    ..messages = (json['messages'] as List)
        .map((e) => e == null ? null : NotificationResponse.fromJson(e))
        .toList();
}

Map<String, dynamic> _$NotificationsAPIToJson(NotificationsAPI instance) =>
    <String, dynamic>{
      'messages': instance.messages!.map((e) => e!.toJson()).toList(),
    };

FeedbackResponse _$FeedbackResponseFromJson(Map<String, dynamic> json) {
  return FeedbackResponse()
    ..id = json['id'] as String
    ..title = json['title'] as String
    ..text = json['text'] as String
    ..message = json['message'] as String
    ..user_id = json['user_id'] as String
    ..created_at = json['created_at'] as String
    ..updated_at = json['updated_at'] as String
    ..username = json['username'] as String
    ..photo = json['photo'] as String;
}

Map<String, dynamic> _$FeedbackResponseToJson(
    FeedbackResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'text': instance.text,
      'message': instance.message,
      'user_id': instance.user_id,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'username': instance.username,
      'photo': instance.photo,
    };