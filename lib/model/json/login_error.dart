import 'package:json_annotation/json_annotation.dart';

part 'login_error.g.dart';

@JsonSerializable()
class LoginError {
  @JsonKey(name: "error")
  String error;

  @JsonKey(name: "error_description")
  String errorDescription;

  LoginError({required this.error, required this.errorDescription});

  factory LoginError.fromJson(Map<String, dynamic> json) =>
      _$LoginErrorFromJson(json);
  Map<String, dynamic> toJson() => _$LoginErrorToJson(this);
}
