
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
 class FirebaseUserModel {
    final String token;
    final  String userId;

    FirebaseUserModel(this.token, this.userId);

     FirebaseUserModel.fromJson(Map<dynamic, dynamic> json) :
     token = json['token'] as String ,
      userId = json['userId'] as String ;

    Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
      'token': token,
      'userId': userId,
    };
}
