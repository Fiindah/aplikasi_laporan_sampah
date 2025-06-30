// lib/models/laporan_data_model.dart

// Data model for a single report, used consistently across the app.
class Data {
  int? id;
  int? userId;
  String? judul;
  String? isi;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? imageUrl;
  String? lokasi;

  User? user;

  Data({
    this.id,
    this.userId,
    this.judul,
    this.isi,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
    this.lokasi, // Added to constructor
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: int.tryParse(json["user_id"].toString()),
    judul: json["judul"],
    isi: json["isi"],
    status: json["status"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    imageUrl: json["image_url"],
    lokasi: json["lokasi"], // Now parses directly as String
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "judul": judul,
    "isi": isi,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "image_url": imageUrl,
    "lokasi": lokasi, // Now handles String directly
    "user": user?.toJson(),
  };
}

// User model (remains unchanged)
class User {
  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

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
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
