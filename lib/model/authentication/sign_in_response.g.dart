// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInResponse _$SignInResponseFromJson(Map<String, dynamic> json) {
  return SignInResponse()
    ..username = json['username'] as String
    ..bearer_token = json['bearer_token'] as String
    ..role = json['role'] as String;
}

Map<String, dynamic> _$SignInResponseToJson(SignInResponse instance) =>
    <String, dynamic>{
      'username': instance.username,
      'bearer_token': instance.bearer_token,
      'role': instance.role,
    };
