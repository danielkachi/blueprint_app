
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
 class FirebaseNotificationModel {
    final String message;
    final  String title;
    final String messageId;

    FirebaseNotificationModel(this.message, this.title, this.messageId);

    FirebaseNotificationModel.fromJson(Map<dynamic, dynamic> json) :
     message = json['message'] as String ,
      title = json['title'] as String,
     messageId = json['messageId'] as String;

    Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
      'message': message,
      'title': title,
      'messageId': messageId,
    };
}
