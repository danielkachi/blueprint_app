// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerResponse _$ServerResponseFromJson(Map<String, dynamic> json) {
  return ServerResponse()..message = json['message'] as String;
}

Map<String, dynamic> _$ServerResponseToJson(ServerResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
