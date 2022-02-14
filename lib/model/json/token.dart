import 'package:json_annotation/json_annotation.dart';

part 'token.g.dart';

@JsonSerializable()
class Token {
  @JsonKey(name: "access_token")
  String accessToken;

  @JsonKey(name: "token_type")
  String tokenType;

  @JsonKey(name: "expires_in")
  String expiresIn;

  @JsonKey(name: "refresh_token")
  String refreshToken;

  @JsonKey(name: "UserTypeId")
  String userTypeId;

  @JsonKey(name: "IsTeacher")
  String isTeacher;

  @JsonKey(name: "UserGroupID")
  String userGroupId;

  @JsonKey(name: ".issued")
  String issued;

  @JsonKey(name: ".expires")
  String expires;

  Token({
    required this.accessToken,
    required this.expires,
    required this.expiresIn,
    required this.isTeacher,
    required this.issued,
    required this.refreshToken,
    required this.tokenType,
    required this.userGroupId,
    required this.userTypeId,
  });

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
  Map<String, dynamic> toJson() => _$TokenToJson(this);
}
