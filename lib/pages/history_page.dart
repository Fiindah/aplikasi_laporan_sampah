import 'package:aplikasi_laporan_sampah/api/report_api.dart';
import 'package:aplikasi_laporan_sampah/constant/app_color.dart';
import 'package:aplikasi_laporan_sampah/models/list_laporan_response.dart';
import 'package:aplikasi_laporan_sampah/pages/report_list_page.dart';
import 'package:flutter/material.dart';

// Renamed _HistoryPageState to HistoryPageState to make it public
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  static const String id = "/history_page";

  @override
  State<HistoryPage> createState() => HistoryPageState(); // Changed here too
}

// Renamed _HistoryPageState to HistoryPageState
class HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<ListLaporanResponse>? _futureAllReports;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _refreshAllReports();
  }

  void _refreshAllReports() {
    setState(() {
      _futureAllReports = ReportService().getReports().catchError((error) {
        debugPrint('Error fetching all reports for history: $error');
        throw error;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Laporan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColor.mygreen,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: 'MASUK', icon: Icon(Icons.inbox)),
            Tab(text: 'PROSES', icon: Icon(Icons.settings)),
            Tab(text: 'SELESAI', icon: Icon(Icons.check_circle)),
          ],
        ),
      ),
      body: FutureBuilder<ListLaporanResponse>(
        future: _futureAllReports,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat riwayat laporan: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _refreshAllReports,
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
          }
          return TabBarView(
            controller: _tabController,
            children: [
              ReportListTab(
                statusFilter: 'masuk',
                futureReports: _futureAllReports,
              ),
              ReportListTab(
                statusFilter: 'proses',
                futureReports: _futureAllReports,
              ),
              ReportListTab(
                statusFilter: 'selesai',
                futureReports: _futureAllReports,
              ),
            ],
          );
        },
      ),
    );
  }
}
