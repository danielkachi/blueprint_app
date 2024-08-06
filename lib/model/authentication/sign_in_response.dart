import 'package:json_annotation/json_annotation.dart';

part 'sign_in_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SignInResponse {
  String? username;
  String? bearer_token;
  String? role;

  SignInResponse();

  factory SignInResponse.fromJson(final json) => _$SignInResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignInResponseToJson(this);
}