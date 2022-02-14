import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/service/api.dart';
import '../model/object/login.dart';
import '../model/json/token.dart';
import '../model/json/login_error.dart';

class LoginProvider with ChangeNotifier {
  bool _passwordVisible = false;
  bool _isLoading = false;
  Login _login = Login(userName: '', password: '');
  bool _hasError = false;
  String _errorMessage = '';
  bool _isLoggedIn = false;
  bool _isAuthenticated = false;
  Token _token = Token(
    accessToken: '',
    expires: '',
    expiresIn: '',
    isTeacher: '',
    issued: '',
    refreshToken: '',
    tokenType: '',
    userGroupId: '',
    userTypeId: '',
  );
  static header() => {"Content-Type": "application/json"};
  late LoginError _loginError;
  bool get passwordVisible {
    return this._passwordVisible;
  }

  togglePasswordVisible() {
    this._passwordVisible = !this._passwordVisible;
    notifyListeners();
  }

  String get username {
    return this._login.userName;
  }

  String get password {
    return this._login.password;
  }

  bool get isLoading {
    return this._isLoading;
  }

  bool get hasError {
    return this._hasError;
  }

  String get errorMessage {
    return this._errorMessage;
  }

  bool get isLoggedIn {
    return this._isLoggedIn;
  }

  Future<bool> get isAuthenticated async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString('accessToken');
    String? tokenExpiresStr = sharedPreferences.getString('expires');

    DateTime expireDate;
    if (tokenExpiresStr != null) {
      expireDate = HttpDate.parse(tokenExpiresStr);
    } else {
      var today = new DateTime.now();
      expireDate = today.add(new Duration(days: 1));
    }

    if (accessToken != null &&
        (expireDate != null && expireDate.isAfter(DateTime.now()))) {
      this._isAuthenticated = true;
    } else {
      this._isAuthenticated = false;
    }
    notifyListeners();
    return _isAuthenticated;
  }

  void saveToken(Token token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('accessToken', token.accessToken);
    sharedPreferences.setString('expires', token.expires);
    sharedPreferences.setString('expiresIn', token.expiresIn);
    sharedPreferences.setString('isTeacher', token.isTeacher);
    sharedPreferences.setString('issued', token.issued);
    sharedPreferences.setString('refreshToken', token.refreshToken);
    sharedPreferences.setString('tokenType', token.tokenType);
    sharedPreferences.setString('userGroupId', token.userGroupId);
    sharedPreferences.setString('userTypeId', token.userTypeId);
  }

  Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString('accessToken');
    return "$accessToken";
  }

  Future<void> _authenticate(String username, String password) async {
    const url = Api.tokenUrl;
    var dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    Response response;

    this._login = Login(userName: username, password: password);

    try {
      var formData = {
        'userName': this._login.userName,
        'password': this._login.password,
        'grant_type': 'password',
      };

      response = await dio.post(
        url,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.json,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded',
            'Access-Control-Allow-Origin': '*',
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200) {
        _token = Token.fromJson(response.data);
        this._hasError = false;
        this._errorMessage = '';
        if (_token.accessToken.isNotEmpty) {
          saveToken(_token);
          await getProfileImage();
          await getCurrentUserInfo();
          this._isLoggedIn = true;
        } else {
          this._isLoggedIn = false;
        }
      } else {
        this._hasError = true;
        this._errorMessage = 'Oops! Something went wrong!';
        this._isLoggedIn = false;
      }
      this._isLoading = false;
      notifyListeners();
    } on DioError catch (e) {
      if (e.response != null) {
        _errorMessage = 'Failed to authenticate. Please try again later.';
        _loginError = LoginError.fromJson(e.response!.data);
        _errorMessage = _loginError.errorDescription;
        this._isLoading = false;
        this._isLoggedIn = false;

        notifyListeners();
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        this._hasError = true;
        this._errorMessage = 'Authentication failed.';
        this._isLoading = false;
        this._isLoggedIn = false;
        notifyListeners();
      }
    } catch (error) {
      this._hasError = true;
      this._errorMessage = 'Could not authenticate you. Please try again.';
      this._isLoading = false;
      this._isLoggedIn = false;
      notifyListeners();
    }
  }

  Future<void> _getProfileImage() async {
    const url = Api.baseUrl + 'Common/GetProfileImage';
    var dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    Response response;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var _authToken = sharedPreferences.getString('accessToken');

    try {
      response = await dio.get(
        url,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.json,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded',
            'AppKey': 'AiubPortalMobileAppBy\$DD2019',
            'Authorization': 'Bearer $_authToken',
            'Access-Control-Allow-Origin': '*',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data == null || response.data.toString().isEmpty) {
          this._hasError = true;
          this._errorMessage = 'Image not found';
        } else {
          var profileImageData = response.data;
          sharedPreferences.setString('profileImageString', profileImageData);
          this._hasError = false;
          this._errorMessage = '';
        }
      } else {
        this._hasError = true;
        this._errorMessage = 'Oops! Something went wrong!';
      }
      this._isLoading = false;
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio Error in client: ');
        print(e.response!.data);

        _errorMessage = '';
        this._isLoading = false;
      } else {
        this._hasError = true;
        this._errorMessage = 'Server Error!';
        this._isLoading = false;
      }
    } catch (error) {
      this._hasError = true;
      this._errorMessage =
          'Could not connect to server. Please try again later.';
      this._isLoading = false;
    }
    notifyListeners();
  }

  Future<void> _getCurrentUserInfo() async {
    const url = Api.baseUrl + 'Common/GetCurrentUserInfo2';
    var dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    Response response;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var _authToken = sharedPreferences.getString('accessToken');

    try {
      response = await dio.get(
        url,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          responseType: ResponseType.json,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded',
            'AppKey': 'AiubPortalMobileAppBy\$DD2019',
            'Authorization': 'Bearer $_authToken',
            'Access-Control-Allow-Origin': '*',
          },
        ),
      );

      if (response.statusCode == 200) {
        if (response.data['HasError'] == true) {
          this._hasError = true;
          this._errorMessage = 'Error from Server';
        } else {
          if (response.data == null || response.data.toString().isEmpty) {
            this._hasError = true;
            this._errorMessage = 'No data found!';
          } else {
            sharedPreferences.setString(
                'userId', response.data['Data']['User']['ID'].toString());
            sharedPreferences.setString('userName',
                response.data['Data']['User']['UserName'].toString());
            sharedPreferences.setString('fullName',
                response.data['Data']['User']['FullName'].toString());
            this._hasError = false;
            this._errorMessage = '';
          }
          this._hasError = false;
          this._errorMessage = '';
        }
      } else {
        this._hasError = true;
        this._errorMessage = 'Oops! Something went wromg!';
      }
      this._isLoading = false;
    } on DioError catch (e) {
      if (e.response != null) {
        print('Dio Error in client: ');
        print(e.response!.data);

        _errorMessage = '';
        this._isLoading = false;
      } else {
        this._hasError = true;
        this._errorMessage = 'Server Error!';
        this._isLoading = false;
      }
    } catch (error) {
      this._hasError = true;
      this._errorMessage =
          'Could not connect to server. Please try again later.';
      this._isLoading = false;
    }
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    // Response response;
    this._isLoading = true;
    return _authenticate(username, password);

    // try {
    //   this._isLoading = true;
    //   response = await authService.authenticate(username, password);
    //   this._isLoading = false;
    //   print(response.data);

    //   if (response.statusCode == 200) {
    //     print('All Ok');
    //     _token2response = Token2Response.fromJson(response.data);
    //     _token2 = _token2response.token;
    //   } else {
    //     print('Oops! Something went wromg.');
    //   }
    // } on Exception catch (e) {
    //   this._isLoading = false;
    //   print(e);
    // }
  }

  Future<void> getProfileImage() async {
    return _getProfileImage();
  }

  Future<void> getCurrentUserInfo() async {
    return _getCurrentUserInfo();
  }
}
