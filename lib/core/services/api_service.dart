
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.escuelajs.co/api/v1',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email.trim(),
          'password': password,
        },
      );

      final token = response.data['access_token'];

      if (token == null) {
        throw Exception('Access token was not returned by the API.');
      }

      return token as String;
    } on DioException catch (e) {
      print('LOGIN STATUS: ${e.response?.statusCode}');
      print('LOGIN DETAILS: ${e.response?.data}');
      rethrow;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _dio.post(
        '/users/',
        data: {
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
          'avatar': 'https://i.imgur.com/LDOO4Qs.jpg',
        },
      );
    } on DioException catch (e) {
      print('REGISTER STATUS: ${e.response?.statusCode}');
      print('REGISTER DETAILS: ${e.response?.data}');
      rethrow;
    }
  }
}
