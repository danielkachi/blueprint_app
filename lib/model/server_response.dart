import 'package:json_annotation/json_annotation.dart';

part 'server_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ServerResponse {
   String? message;

   ServerResponse();

   factory ServerResponse.fromJson(final json) => _$ServerResponseFromJson(json);

   Map<String, dynamic> toJson() => _$ServerResponseToJson(this);
}