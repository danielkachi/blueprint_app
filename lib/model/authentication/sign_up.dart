import 'package:json_annotation/json_annotation.dart';

part 'sign_up.g.dart';

@JsonSerializable(explicitToJson: true)
class SignUpRequest {

  String? username;
  String? email;
  String? password;
  String? sponsor_code;
  String? phone;

  SignUpRequest();

  factory SignUpRequest.fromJson(final json) => _$SignUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpRequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SignUpResponse{
   String? message;
   String? token;

   SignUpResponse();

   factory SignUpResponse.fromJson(final json) => _$SignUpResponseFromJson(json);

   Map<String, dynamic> toJson() => _$SignUpResponseToJson(this);
}