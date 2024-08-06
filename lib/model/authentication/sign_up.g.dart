// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpRequest _$SignUpRequestFromJson(Map<String, dynamic> json) {
  return SignUpRequest()
    ..username = json['username'] as String
    ..email = json['email'] as String
    ..password = json['password'] as String
    ..sponsor_code = json['sponsor_code'] as String
    ..phone = json['phone'] as String;
}

Map<String, dynamic> _$SignUpRequestToJson(SignUpRequest instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'password': instance.password,
      'sponsor_code': instance.sponsor_code,
      'phone': instance.phone,
    };

SignUpResponse _$SignUpResponseFromJson(Map<String, dynamic> json) {
  return SignUpResponse()
    ..message = json['message'] as String
    ..token = json['token'] as String;
}

Map<String, dynamic> _$SignUpResponseToJson(SignUpResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'token': instance.token,
    };
