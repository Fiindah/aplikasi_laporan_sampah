// To parse this JSON data, do
//
//     final listLaporanResponse = listLaporanResponseFromJson(jsonString);

import 'dart:convert';

ListLaporanResponse listLaporanResponseFromJson(String str) =>
    ListLaporanResponse.fromJson(json.decode(str));

String listLaporanResponseToJson(ListLaporanResponse data) =>
    json.encode(data.toJson());

class ListLaporanResponse {
  final String? message;
  final List<Data>? data;

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

class Data {
  int? id;
  String? userId;
  String? judul;
  String? isi;
  String? status;
  String? createdAt;
  String? updatedAt;
  User? user;

  Data({
    this.id,
    this.userId,
    this.judul,
    this.isi,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    judul: json["judul"],
    isi: json["isi"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "judul": judul,
    "isi": isi,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "user": user?.toJson(),
  };
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final dynamic emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
