// import 'package:belajar_flutter/helper/preference.dart';
// import 'package:belajar_flutter/meet25/tugas_15/endpoint.dart';
// import 'package:belajar_flutter/meet25/tugas_15/model/login_error_response.dart';
// import 'package:belajar_flutter/meet25/tugas_15/model/login_response.dart';
// import 'package:belajar_flutter/meet25/tugas_15/model/profile_response.dart';
// import 'package:belajar_flutter/meet25/tugas_15/model/register_error_respone.dart';
// import 'package:belajar_flutter/meet25/tugas_15/model/register_response.dart';
import 'package:aplikasi_laporan_sampah/api/endpoint.dart';
import 'package:aplikasi_laporan_sampah/model/login_error_response.dart';
import 'package:aplikasi_laporan_sampah/model/login_response.dart';
import 'package:aplikasi_laporan_sampah/model/register_error_respone.dart';
import 'package:aplikasi_laporan_sampah/model/register_response.dart';
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

  //   Future<Map<String, dynamic>> getProfile() async {
  //     String? token = await PreferenceHandler.getToken();
  //     final response = await http.get(
  //       Uri.parse(Endpoint.profile),
  //       headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
  //     );
  //     print(response.body);
  //     print(response.body);
  //     if (response.statusCode == 200) {
  //       print(profileResponseFromJson(response.body).toJson());
  //       return profileResponseFromJson(response.body).toJson();
  //     } else if (response.statusCode == 422) {
  //       return registerErrorResponseFromJson(response.body).toJson();
  //     } else {
  //       print("Failed to login user: ${response.statusCode}");
  //       throw Exception("Failed to login user: ${response.statusCode}");
  //     }
  //   }

  //   Future<Map<String, dynamic>> updatedProfile(String name) async {
  //     final token = await PreferenceHandler.getToken();
  //     final response = await http.put(
  //       Uri.parse(Endpoint.profileUpdated),
  //       headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
  //       body: {"name": name},
  //     );

  //     if (response.statusCode == 200) {
  //       return profileResponseFromJson(response.body).toJson();
  //     } else {
  //       throw Exception(jsonDecode(response.body)['message']);
  //     }
  //   }
}
