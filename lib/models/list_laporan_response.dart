// lib/models/list_laporan_response.dart

import 'dart:convert';

import 'package:aplikasi_laporan_sampah/models/laporan_data_model.dart';

ListLaporanResponse listLaporanResponseFromJson(String str) =>
    ListLaporanResponse.fromJson(json.decode(str));

String listLaporanResponseToJson(ListLaporanResponse data) =>
    json.encode(data.toJson());

class ListLaporanResponse {
  String? message;
  List<Data>? data; // Now references the Data from laporan_data_model.dart

  ListLaporanResponse({this.message, this.data});

  factory ListLaporanResponse.fromJson(Map<String, dynamic> json) =>
      ListLaporanResponse(
        message: json["message"],
        data:
            json["data"] == null
                ? []
                : List<Data>.from(json["data"]!.map((x) => Data.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data":
        data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}
