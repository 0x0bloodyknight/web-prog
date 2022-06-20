import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String? username;
  String? firstName;
  String? lastName;
  String? password;
  String? email;
  String? phone;
  String? city;

  User({
    this.username,
    this.firstName,
    this.lastName,
    this.password,
    this.email,
    this.phone,
    this.city,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
