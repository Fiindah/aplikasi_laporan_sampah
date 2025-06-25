import 'dart:convert';

import 'package:aplikasi_laporan_sampah/api/endpoint.dart';
import 'package:aplikasi_laporan_sampah/helper/preference.dart';
import 'package:aplikasi_laporan_sampah/models/laporan_response.dart';
import 'package:aplikasi_laporan_sampah/models/list_laporan_response.dart';
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

  Future<Map<String, dynamic>> postLaporan({
    required String userId,
    required String judul,
    required String isi,
    String? gambarUrl,
    required String updatedAt,
    required String createdAt,
  }) async {
    final token = await SharePref.getToken();
    if (token == null) {
      throw Exception("No token found. User not authenticated.");
    }
    final response = await http.post(
      Uri.parse(Endpoint.laporan),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {
        "userId": userId,
        "judul": judul,
        "isi": isi,
        "gambar_url": gambarUrl,
        "updatedAt": updatedAt,
        "createdAt": createdAt,
      },
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(laporanResponseFromJson(response.body).toJson());
      return laporanResponseFromJson(response.body).toJson();
    } else if (response.statusCode == 422) {
      return loginErrorResponseFromJson(response.body).toJson();
    } else {
      print("Failed to load Laporan");
      throw Exception("Failed to login Laporan");
    }
  }

  Future<Map<String, dynamic>> getListLaporan() async {
    String? token = await SharePref.getToken();
    final response = await http.get(
      Uri.parse(Endpoint.laporan),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );
    print(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      print(listLaporanResponseFromJson(response.body).toJson());
      return listLaporanResponseFromJson(response.body).toJson();
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<Map<String, dynamic>> updatedLaporan(
    String judul,
    String userId,
    String isi,
    String? gambarUrl,
    String status,
    String updatedAt,
    String createdAt,
  ) async {
    final token = await SharePref.getToken();
    final response = await http.put(
      Uri.parse(Endpoint.updateLaporan),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      body: {
        "user_Id": userId,
        "judul": judul,
        "isi": isi,
        "status": status,
        "gambar_url": gambarUrl,
        "updatedAt": updatedAt,
        "createdAt": createdAt,
      },
    );

    if (response.statusCode == 200) {
      return laporanResponseFromJson(response.body).toJson();
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<Map<String, dynamic>> deleteLaporan(String id) async {
    final token = await SharePref.getToken();
    if (token == null) {
      throw Exception("No token found. User not authenticated.");
    }

    final response = await http.delete(
      Uri.parse(Endpoint.deleteLaporan.replaceFirst('{id}', id)),
      headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
    );

    print('DELETE Laporan Body: ${response.body}');
    print('DELETE Laporan Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      return {"message": "Laporan berhasil dihapus"}; // Asumsi respons sukses
    } else {
      print("Failed to delete Laporan: ${response.statusCode}");
      throw Exception(
        jsonDecode(response.body)['message'] ?? "Failed to delete Laporan",
      );
    }
  }
}
