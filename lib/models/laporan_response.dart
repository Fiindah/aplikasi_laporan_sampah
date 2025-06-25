// To parse this JSON data, do
//
//     final laporanResponse = laporanResponseFromJson(jsonString);

import 'dart:convert';

LaporanResponse laporanResponseFromJson(String str) =>
    LaporanResponse.fromJson(json.decode(str));

String laporanResponseToJson(LaporanResponse data) =>
    json.encode(data.toJson());

class LaporanResponse {
  String? message;
  Data? data;

  LaporanResponse({this.message, this.data});

  factory LaporanResponse.fromJson(Map<String, dynamic> json) =>
      LaporanResponse(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  int? userId;
  String? judul;
  String? isi;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data({
    this.userId,
    this.judul,
    this.isi,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    judul: json["judul"],
    isi: json["isi"],
    updatedAt: json["updated_at"],
    createdAt: json["created_at"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "judul": judul,
    "isi": isi,
    "updated_at": updatedAt,
    "created_at": createdAt,
    "id": id,
  };
}
