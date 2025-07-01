import 'package:aplikasi_laporan_sampah/api/report_api.dart';
import 'package:aplikasi_laporan_sampah/constant/app_color.dart';
import 'package:aplikasi_laporan_sampah/models/laporan_data_model.dart';
import 'package:aplikasi_laporan_sampah/models/list_laporan_response.dart';
import 'package:aplikasi_laporan_sampah/pages/add_report_page.dart';
import 'package:aplikasi_laporan_sampah/pages/edit_report_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String id = "/home_page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<ListLaporanResponse>? _futureReports;
  final List<String> _allStatuses = ['masuk', 'proses', 'selesai'];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() {
    setState(() {
      _futureReports = ReportService().getReports().catchError((error) {
        debugPrint('Error fetching reports: $error');
        throw error;
      });
    });
  }

  Future<void> _refreshReports() async {
    _loadReports();
  }

  /// Shows a bottom sheet to allow updating the status of a specific report.
  void _showUpdateStatusBottomSheet(Data report) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Center(
                  child: Text(
                    'Ubah Status Laporan "${report.judul ?? 'N/A'}"',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Divider(),
              ..._allStatuses.map((statusOption) {
                return ListTile(
                  title: Text(statusOption.toUpperCase()),
                  leading: Icon(
                    _getStatusIcon(statusOption),
                    color: _getStatusColor(statusOption),
                  ),
                  trailing:
                      report.status?.toLowerCase() == statusOption
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                  onTap: () async {
                    Navigator.pop(context); // Close the bottom sheet
                    await _updateReportStatus(
                      report.id.toString(),
                      statusOption,
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  /// Calls the API to update the report's status.
  Future<void> _updateReportStatus(String reportId, String newStatus) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Memperbarui status..."),
              ],
            ),
          ),
        );
      },
    );

    try {
      await ReportService().updateReportStatus(
        reportId: reportId,
        newStatus: newStatus,
      );
      Navigator.pop(context); // Close the loading dialog
      _showSnackBar(
        'Status laporan berhasil diperbarui menjadi ${newStatus.toUpperCase()}!',
        Colors.green,
      );
      _refreshReports(); // Refresh the home page list
    } catch (e) {
      Navigator.pop(context); // Close the loading dialog
      _showSnackBar('Gagal memperbarui status laporan: $e', Colors.red);
      debugPrint('Error updating report status from Home Page: $e');
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EcoGreen',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColor.mygreen,
        foregroundColor: Colors.white,
        centerTitle: false,
        actions: const [],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshReports,
        child: FutureBuilder<ListLaporanResponse>(
          future: _futureReports,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off, color: Colors.red, size: 60),
                      const SizedBox(height: 16),
                      Text(
                        'Gagal memuat laporan. Pastikan Anda terhubung ke internet dan sudah login. '
                        'Detail Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _refreshReports,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColor.mygreen,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (!snapshot.hasData ||
                snapshot.data?.data == null ||
                (snapshot.data?.data?.isEmpty ?? true)) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox, color: Colors.grey, size: 60),
                      const SizedBox(height: 16),
                      const Text(
                        'Belum ada laporan sampah saat ini. Yuk, buat laporan pertama Anda!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _refreshReports,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh Daftar'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColor.mygreen,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // This line is already robust and safe
              final List<Data> reports = snapshot.data!.data ?? [];

              if (reports.isEmpty) {
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inbox, color: Colors.grey, size: 60),
                        const SizedBox(height: 16),
                        const Text(
                          'Belum ada laporan sampah saat ini. Yuk, buat laporan pertama Anda!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _refreshReports,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Refresh Daftar'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: AppColor.mygreen,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  final Data report = reports[index];
                  return Card(
                    key: ValueKey(report.id),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: InkWell(
                      onTap: () async {
                        final bool? result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EditReportPage(report: report),
                          ),
                        );
                        if (result == true) {
                          _refreshReports();
                        }
                      },
                      onLongPress: () => _showUpdateStatusBottomSheet(report),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report.judul ?? 'Judul Tidak Tersedia',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColor.mygreen,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Chip(
                                label: Text(
                                  report.status?.toUpperCase() ??
                                      'STATUS TIDAK DIKETAHUI',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor: _getStatusColor(report.status),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (report.imageUrl != null &&
                                report.imageUrl!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  imageUrl: report.imageUrl!,
                                  placeholder:
                                      (context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                  errorWidget:
                                      (context, url, error) => const Icon(
                                        Icons.image_not_supported,
                                        size: 60,
                                        color: Colors.grey,
                                      ),
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (report.imageUrl != null &&
                                report.imageUrl!.isNotEmpty)
                              const SizedBox(height: 12),
                            Text(
                              report.isi ?? 'Isi laporan tidak tersedia.',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (report.lokasi != null &&
                                report.lokasi!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        'Lokasi: ${report.lokasi ?? 'N/A'}', // Added ?? 'N/A' here
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (report.user != null &&
                                report.user!.name != null)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Pelapor: ${report.user!.name ?? 'N/A'}', // Added ?? 'N/A' here
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Dibuat: ${report.createdAt != null ? DateFormat('dd MMMEEEE HH:mm').format(report.createdAt!.toLocal()) : 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'Diperbarui: ${report.updatedAt != null ? DateFormat('dd MMMEEEE HH:mm').format(report.updatedAt!.toLocal()) : 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final bool? result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              EditReportPage(report: report),
                                    ),
                                  );
                                  if (result == true) {
                                    _refreshReports();
                                  }
                                },
                                icon: const Icon(Icons.edit, size: 18),
                                label: const Text('Edit'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: AppColor.mygreen,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddReportPage()),
          );
          if (result == true) {
            _refreshReports();
          }
        },
        tooltip: 'Tambah Laporan',
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'masuk':
        return Colors.blue;
      case 'proses':
        return Colors.orange;
      case 'selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'masuk':
        return Icons.inbox;
      case 'proses':
        return Icons.settings;
      case 'selesai':
        return Icons.check_circle;
      default:
        return Icons.help_outline;
    }
  }
}
