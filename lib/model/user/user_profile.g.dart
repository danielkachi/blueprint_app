// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return UserProfile(
    json['id'] as String,
    json['user_id'] as String,
    json['first_name'] as String,
    json['last_name'] as String,
    json['phone_number'] as String,
    json['dob'] as String,
    json['address'] as String,
    json['state'] as String,
    json['zip_code'] as String,
    json['photo'] as String,
    json['country'] as String,
    json['created_at'] as String,
    json['updated_at'] as String,
    json['email'] as String,
    json['referral_code'] as String,
    json['username'] as String,
    json['status'] as String,
  );
}

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'phone_number': instance.phone_number,
      'dob': instance.dob,
      'address': instance.address,
      'state': instance.state,
      'zip_code': instance.zip_code,
      'photo': instance.photo,
      'country': instance.country,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'email': instance.email,
      'referral_code': instance.referral_code,
      'username': instance.username,
      'status': instance.status,
    };

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    json['profile'] == null ? null : UserProfile.fromJson(json['profile']),
    json['active_subscription'] as bool,
  );
}


Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'profile': instance.profile!.toJson(),
      'active_subscription': instance.active_subscription,
    };
