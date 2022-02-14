part of 'login_error.dart';

LoginError _$LoginErrorFromJson(Map<String, dynamic> json) {
  return LoginError(
    error: json['error'].toString(),
    errorDescription: json['error_description'].toString(),
  );
}

Map<String, dynamic> _$LoginErrorToJson(LoginError instance) =>
    <String, dynamic>{
      'error': instance.error,
      'error_description': instance.errorDescription,
    };
