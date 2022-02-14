part of 'token.dart';

Token _$TokenFromJson(Map<String, dynamic> json) {
  return Token(
    accessToken: json['access_token'].toString(),
    expires: json['.expires'].toString(),
    expiresIn: json['expires_in'].toString(),
    isTeacher: json['IsTeacher'].toString(),
    issued: json['.issued'].toString(),
    refreshToken: json['refresh_token'].toString(),
    tokenType: json['token_type'].toString(),
    userGroupId: json['UserGroupID'].toString(),
    userTypeId: json['UserTypeId'].toString(),
  );
}

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'expires_in': instance.expiresIn,
      'refresh_token': instance.refreshToken,
      'UserTypeId': instance.userTypeId,
      'IsTeacher': instance.isTeacher,
      'UserGroupID': instance.userGroupId,
      '.issued': instance.issued,
      '.expires': instance.expires,
    };
