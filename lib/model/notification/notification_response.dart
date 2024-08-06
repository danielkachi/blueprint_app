import 'package:json_annotation/json_annotation.dart';

part 'notification_response.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationResponse{

  int? id;
  String? title;
  String? text;
  String? message;
  String? user_id;
  String? created_at;
  String? updated_at;
  String? username;
  String? photo;


  NotificationResponse();

  factory NotificationResponse.fromJson(final json) => _$NotificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class NotificationsAPI {
  List<NotificationResponse?>? messages;

  NotificationsAPI();

  factory NotificationsAPI.fromJson(final json) => _$NotificationsAPIFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsAPIToJson(this);
}


@JsonSerializable(explicitToJson: true)
class FeedbackResponse{

  String? id;
  String? title;
  String? text;
  String? message;
  String? user_id;
  String? created_at;
  String? updated_at;
  String? username;
  String? photo;


  FeedbackResponse();

  factory FeedbackResponse.fromJson(final json) => _$FeedbackResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FeedbackResponseToJson(this);
}