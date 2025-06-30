import 'package:aplikasi_laporan_sampah/api/endpoint.dart';
import 'package:aplikasi_laporan_sampah/models/login_error_response.dart';
import 'package:aplikasi_laporan_sampah/models/login_response.dart';
import 'package:aplikasi_laporan_sampah/models/register_error_respone.dart';
import 'package:aplikasi_laporan_sampah/models/register_response.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<Map<String, dynamic>> registerUser({
    required String email,
    required String name,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.register),
      headers: {"Accept": "application/json"},
      body: {"name": name, "email": email, "password": password},
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(registerResponseFromJson(response.body).toJson());
      return registerResponseFromJson(response.body).toJson();
    } else if (response.statusCode == 422) {
      return registerErrorResponseFromJson(response.body).toJson();
    } else {
      print("Failed to register user: ${response.statusCode}");
      throw Exception("Failed to register user: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(Endpoint.login),
      headers: {"Accept": "application/json"},
      body: {"email": email, "password": password},
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(loginResponseFromJson(response.body).toJson());
      return loginResponseFromJson(response.body).toJson();
    } else if (response.statusCode == 422) {
      return loginErrorResponseFromJson(response.body).toJson();
    } else {
      print("Failed to login user: ${response.statusCode}");
      throw Exception("Failed to login user: ${response.statusCode}");
    }
  }
}
