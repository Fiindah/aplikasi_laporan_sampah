// lib/models/laporan_response.dart

import 'dart:convert';

import 'package:aplikasi_laporan_sampah/models/login_response.dart';

LaporanResponse laporanResponseFromJson(String str) =>
    LaporanResponse.fromJson(json.decode(str));

String laporanResponseToJson(LaporanResponse data) =>
    json.encode(data.toJson());

class LaporanResponse {
  String? message;
  Data? data; // Now references the Data from laporan_data_model.dart

  LaporanResponse({this.message, this.data});

  factory LaporanResponse.fromJson(Map<String, dynamic> json) =>
      LaporanResponse(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}
