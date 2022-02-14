// import 'package:dio/dio.dart';

// class AuthService {
//   Dio _dio;
//   static const tokenUrl = '';

//   AuthService() {
//     _dio = Dio(
//       BaseOptions(
//         baseUrl: '',
//         sendTimeout: 5000,
//         receiveTimeout: 3000,
//       ),
//     );

//     initializeInterceptors();
//   }

//   initializeInterceptors() {
//     _dio.interceptors.add(InterceptorsWrapper(
//       onError: (error, errorInterceptorHandler) {
//         print(error.message);
//       },
//       onRequest: (request, requestInterceptorHandler) {
//         print("${request.method} ${request.path}");
//       },
//       onResponse: (response, responseInterceptorHandler) {
//         print(response.data);
//       },
//     ));
//   }

//   Future<Response> getRequest(String endpoint) async {
//     Response response;

//     try {
//       response = await _dio.get(endpoint);
//     } on DioError catch (e) {
//       print(e.message);
//       throw Exception(e.message);
//     }

//     return response;
//   }

//   Future<Response> authenticate(String username, String password) async {
//     Response response;
//     print('chica boom');

//     try {
//       var formData = {
//         'userName': username,
//         'password': password,
//         'grant_type': 'password',
//       };

//       _dio.options.contentType = Headers.formUrlEncodedContentType;

//       print('request jacche');
//       response = await _dio.post(
//         tokenUrl,
//         options: Options(
//           contentType: Headers.formUrlEncodedContentType,
//           headers: {
//             'Accept': 'application/json',
//             'Content-Type': 'application/x-www-form-urlencoded',
//             'Access-Control-Allow-Origin': '*',
//           },
//         ),
//         data: formData,
//       );
//       print('response asche 2');

//       print(response.data);
//     } on DioError catch (e) {
//       print('Dio Error: ');
//       print(e.message);
//       throw Exception(e.message);
//     }

//     return response;
//   }
// }
