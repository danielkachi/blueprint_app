
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable(explicitToJson: true)
 class UserProfile {
  String? id;
  String? user_id;
  String? first_name;
  String? last_name;
  String? phone_number;
  String? dob;
  String? address;
  String? state;
  String? zip_code;
  String? photo;
  String? country;
  String? created_at;
  String? updated_at;
  String? email;
  String? referral_code;
  String? status;
  String? username;



  UserProfile(this.id, this.user_id, this.first_name, this.last_name,
      this.phone_number, this.dob, this.address, this.state, this.zip_code, this.photo,
      this.country, this.created_at, this.updated_at, this.email, this.referral_code, this.username, this.status);

  factory UserProfile.fromJson(final json) =>  _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
 }


@JsonSerializable(explicitToJson: true)
class Profile {
 UserProfile? profile ;
 bool active_subscription;

 Profile(this.profile, this.active_subscription);


 factory Profile.fromJson(final json) =>  _$ProfileFromJson(json);

 Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

class UpdateProfile {
 String phone_number;
 String photo;

 UpdateProfile(this.phone_number, this.photo);

}
