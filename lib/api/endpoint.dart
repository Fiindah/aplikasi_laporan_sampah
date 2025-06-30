class Endpoint {
  static const String baseUrl = "http://applaporan.mobileprojp.com";
  static const String baseUrlApi = "$baseUrl/api";
  static const String register = "$baseUrlApi/register";
  static const String login = "$baseUrlApi/login";
  static const String laporan = "$baseUrlApi/laporan";
  static const String statuslaporan = "$baseUrlApi/laporan/{id}/status";
  static const String updateLaporan = "$baseUrlApi/laporan/{id}";
  static const String deleteLaporan = "$baseUrlApi/laporan/{id}";
  static const String riwayat = "$baseUrlApi/riwayat";
  static const String statistik = "$baseUrlApi/statistik";
}
