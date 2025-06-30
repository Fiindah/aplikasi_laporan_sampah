import 'dart:convert';

import 'package:aplikasi_laporan_sampah/api/endpoint.dart';
import 'package:aplikasi_laporan_sampah/helper/preference.dart';
import 'package:aplikasi_laporan_sampah/models/laporan_response.dart';
import 'package:aplikasi_laporan_sampah/models/list_laporan_response.dart';
import 'package:flutter/foundation.dart'; // Untuk debugPrint
import 'package:http/http.dart' as http;

class ReportService {
  // Helper untuk mendapatkan token
  Future<String> _getAuthToken() async {
    final token = await SharePref.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Authentication token is missing. Please log in.");
    }
    return token;
  }

  // Helper untuk membuat header
  Map<String, String> _getHeaders(String token) {
    return {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
      "Content-Type": "application/json", // Penting untuk body JSON
    };
  }

  /// Mengirim laporan baru ke server.
  /// Parameter `id` (userId dari laporan yang dibuat) biasanya tidak dikirim dari client
  /// karena server yang akan menentukan ID laporan yang baru.
  /// Begitu juga `createdAt` dan `updatedAt` yang umumnya diatur oleh server.
  Future<LaporanResponse> postReport({
    required String judul,
    required String isi,
    required dynamic status,
    required dynamic lokasi,
    String? imageUrl,
  }) async {
    final token = await _getAuthToken();

    final Map<String, dynamic> body = {
      "judul": judul,
      "isi": isi,
      "status": status,
      "lokasi": lokasi,
    };
    if (imageUrl != null && imageUrl.isNotEmpty) {
      body["image_url"] = imageUrl;
    }

    final response = await http.post(
      Uri.parse(Endpoint.laporan),
      headers: _getHeaders(token),
      body: jsonEncode(body),
    );

    debugPrint('POST Report Status Code: ${response.statusCode}');
    debugPrint('POST Report Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return laporanResponseFromJson(response.body);
    } else {
      String errorMessage = "Failed to create report.";
      try {
        final errorData = jsonDecode(response.body);
        errorMessage = errorData['message'] ?? errorMessage;
      } catch (e) {
        debugPrint("Error parsing error response: $e");
      }
      throw Exception("Error ${response.statusCode}: $errorMessage");
    }
  }

  /// Mengambil daftar laporan dari server.
  Future<ListLaporanResponse> getReports() async {
    final token = await _getAuthToken();

    final response = await http.get(
      Uri.parse(
        Endpoint.laporan,
      ), // Pastikan ini adalah endpoint untuk GET semua laporan
      headers: _getHeaders(token),
    );

    debugPrint('GET Reports Status Code: ${response.statusCode}');
    debugPrint('GET Reports Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return listLaporanResponseFromJson(response.body);
    } else {
      String errorMessage = "Failed to load reports.";
      try {
        final errorData = jsonDecode(response.body);
        errorMessage = errorData['message'] ?? errorMessage;
      } catch (e) {
        debugPrint("Error parsing error response: $e");
      }
      throw Exception("Error ${response.statusCode}: $errorMessage");
    }
  }

  Future<LaporanResponse> updateReport({
    required String reportId,
    required String judul,
    required String isi,
    String? imageUrl,
    required String status,
    required dynamic lokasi,
  }) async {
    final token = await _getAuthToken();

    final url = Uri.parse(
      Endpoint.updateLaporan.replaceFirst('{id}', reportId),
    );

    final Map<String, dynamic> body = {
      "judul": judul,
      "isi": isi,
      "status": status,
      "lokasi": lokasi,
    };
    if (imageUrl != null && imageUrl.isNotEmpty) {
      body["image_url"] = imageUrl;
    }

    final response = await http.put(
      url,
      headers: _getHeaders(token),
      body: jsonEncode(body), // Kirim body sebagai JSON
    );

    debugPrint('PUT Report Status Code: ${response.statusCode}');
    debugPrint('PUT Report Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return laporanResponseFromJson(response.body);
    } else {
      String errorMessage = "Failed to update report.";
      try {
        final errorData = jsonDecode(response.body);
        errorMessage = errorData['message'] ?? errorMessage;
      } catch (e) {
        debugPrint("Error parsing error response: $e");
      }
      throw Exception("Error ${response.statusCode}: $errorMessage");
    }
  }

  /// Menghapus laporan berdasarkan ID.
  Future<Map<String, dynamic>> deleteReport(String id) async {
    final token = await _getAuthToken();

    final response = await http.delete(
      Uri.parse(
        Endpoint.deleteLaporan.replaceFirst('{id}', id),
      ), // Pastikan {id} diganti
      headers: _getHeaders(token),
    );

    debugPrint('DELETE Laporan Status Code: ${response.statusCode}');
    debugPrint('DELETE Laporan Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      // 204 No Content juga umum untuk DELETE sukses
      // Terkadang API tidak mengembalikan body untuk DELETE, jadi pastikan penanganan ini
      return {"message": "Laporan berhasil dihapus"};
    } else {
      String errorMessage = "Failed to delete report.";
      try {
        final errorData = jsonDecode(response.body);
        errorMessage = errorData['message'] ?? errorMessage;
      } catch (e) {
        debugPrint("Error parsing error response: $e");
      }
      throw Exception("Error ${response.statusCode}: $errorMessage");
    }
  }

  Future<LaporanResponse> updateReportStatus({
    required String reportId,
    required String newStatus,
  }) async {
    final token = await _getAuthToken();

    final url = Uri.parse(
      Endpoint.statuslaporan.replaceFirst(
        '{id}',
        reportId,
      ), // Uses the statuslaporan endpoint
    );

    final Map<String, dynamic> body = {
      "status": newStatus, // Sends only the new status in the body
    };

    final response = await http.put(
      // Uses a PUT request
      url,
      headers: _getHeaders(token),
      body: jsonEncode(body),
    );

    debugPrint('PUT Report (Status) Status Code: ${response.statusCode}');
    debugPrint('PUT Report (Status) Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return laporanResponseFromJson(response.body);
    } else {
      String errorMessage = "Failed to update report status.";
      try {
        final errorData = jsonDecode(response.body);
        errorMessage = errorData['message'] ?? errorMessage;
      } catch (e) {
        debugPrint("Error parsing error response: $e");
      }
      throw Exception("Error ${response.statusCode}: $errorMessage");
    }
  }
}
