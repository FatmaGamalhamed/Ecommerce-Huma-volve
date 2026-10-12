import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Login
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
        throw Exception(
          'Access token was not returned by the API.',
        );
      }

      final accessToken = token as String;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken);

      return accessToken;
    } on DioException catch (e) {
      print('LOGIN STATUS: ${e.response?.statusCode}');
      print('LOGIN DETAILS: ${e.response?.data}');
      rethrow;
    }
  }

  // Register
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

  // Get products
  Future<List<dynamic>> getProducts() async {
    try {
      final response = await _dio.get('/products/');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      print('PRODUCTS STATUS: ${e.response?.statusCode}');
      print('PRODUCTS DETAILS: ${e.response?.data}');
      rethrow;
    }
  }

  // Retrieve saved token
  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
}
