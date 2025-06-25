// To parse this JSON data, do
//
//     final statistikLaporanResponse = statistikLaporanResponseFromJson(jsonString);

import 'dart:convert';

StatistikLaporanResponse statistikLaporanResponseFromJson(String str) =>
    StatistikLaporanResponse.fromJson(json.decode(str));

String statistikLaporanResponseToJson(StatistikLaporanResponse data) =>
    json.encode(data.toJson());

class StatistikLaporanResponse {
  String? message;
  Data? data;

  StatistikLaporanResponse({this.message, this.data});

  factory StatistikLaporanResponse.fromJson(Map<String, dynamic> json) =>
      StatistikLaporanResponse(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  int? masuk;
  int? proses;
  int? selesai;

  Data({this.masuk, this.proses, this.selesai});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    masuk: json["masuk"],
    proses: json["proses"],
    selesai: json["selesai"],
  );

  Map<String, dynamic> toJson() => {
    "masuk": masuk,
    "proses": proses,
    "selesai": selesai,
  };
}
