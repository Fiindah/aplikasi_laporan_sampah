// To parse this JSON data, do
//
//     final riwayatLaporanResponse = riwayatLaporanResponseFromJson(jsonString);

import 'dart:convert';

RiwayatLaporanResponse riwayatLaporanResponseFromJson(String str) =>
    RiwayatLaporanResponse.fromJson(json.decode(str));

String riwayatLaporanResponseToJson(RiwayatLaporanResponse data) =>
    json.encode(data.toJson());

class RiwayatLaporanResponse {
  String? message;
  List<Data>? data;

  RiwayatLaporanResponse({this.message, this.data});

  factory RiwayatLaporanResponse.fromJson(Map<String, dynamic> json) =>
      RiwayatLaporanResponse(
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

class Data {
  int? id;
  String? userId;
  String? judul;
  String? isi;
  String? status;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.userId,
    this.judul,
    this.isi,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    judul: json["judul"],
    isi: json["isi"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "judul": judul,
    "isi": isi,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
