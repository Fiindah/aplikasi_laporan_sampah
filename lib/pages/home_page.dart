import 'dart:io';

import 'package:aplikasi_laporan_sampah/api/user_api.dart';
import 'package:aplikasi_laporan_sampah/helper/preference.dart';
import 'package:aplikasi_laporan_sampah/models/laporan_response.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _namaPengguna =
      'Budi'; // Nanti bisa diambil dari data user login
  int _selectedIndex = 0;

  List<Report> _laporanSampah =
      []; // Ubah menjadi list kosong dan akan diisi dari API
  bool _isLoading = true; // State untuk loading
  String? _errorMessage; // State untuk error message

  // UserService instance
  final UserService _userService = UserService();
  String? _currentUserId; // Untuk menyimpan userId yang sedang login

  @override
  void initState() {
    super.initState();
    _fetchUserIdAndReports(); // Panggil fungsi untuk ambil userId dan laporan
  }

  Future<void> _fetchUserIdAndReports() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      _currentUserId = await SharePref.getUserId(); // Ambil userId dummy/asli
      await _fetchLaporan();
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mengambil ID pengguna atau laporan: $e';
        _isLoading = false;
      });
      print('Error _fetchUserIdAndReports: $e');
    }
  }

  Future<void> _fetchLaporan() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final List<LaporanResponse> fetchedReports =
          await _userService.getListLaporan();
      setState(() {
        _laporanSampah = fetchedReports;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat laporan: $e';
        _isLoading = false;
      });
      print('Error _fetchLaporan: $e');
    }
  }

  // Fungsi untuk menghapus laporan
  void _deleteLaporan(String id) async {
    setState(() {
      _isLoading = true; // Aktifkan loading saat menghapus
      _errorMessage = null;
    });
    try {
      await _userService.deleteLaporan(id);
      setState(() {
        _laporanSampah.removeWhere((laporan) => laporan.id == id);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Laporan $id berhasil dihapus')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus laporan: $e')));
      setState(() {
        _errorMessage = 'Gagal menghapus laporan: $e';
      });
      print('Error _deleteLaporan: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk memperbarui laporan
  void _updateLaporan(Report updatedData) async {
    setState(() {
      _isLoading = true; // Aktifkan loading saat update
      _errorMessage = null;
    });
    try {
      // Pastikan _currentUserId tidak null
      if (_currentUserId == null) {
        throw Exception("User ID not available for update.");
      }

      await _userService.updatedLaporan(
        updatedData.id,
        _currentUserId!, // Gunakan userId yang ada
        updatedData.lokasiLaporan,
        updatedData.jenisSampah,
        updatedData.deskripsi ?? '', // Pastikan tidak null
        updatedData.status,
        updatedData.gambarUrl,
      );

      setState(() {
        final index = _laporanSampah.indexWhere(
          (laporan) => laporan.id == updatedData.id,
        );
        if (index != -1) {
          _laporanSampah[index] = updatedData; // Update di UI lokal
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Laporan ${updatedData.id} berhasil diperbarui'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui laporan: $e')));
      setState(() {
        _errorMessage = 'Gagal memperbarui laporan: $e';
      });
      print('Error _updateLaporan: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // List halaman yang akan diakses melalui BottomNavigationBar
  // Menggunakan `late` dan menginisialisasi di `initState` atau sebagai getter
  // Atau karena ini stateful widget, bisa langsung diinisialisasi di sini
  late final List<Widget> _widgetOptions = <Widget>[
    _buildHomePageContent(),
    const Center(
      child: Text(
        'Halaman Riwayat Laporan',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    StatistikPage(laporanData: _laporanSampah), // Meneruskan data laporan
  ];

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Januari';
      case 2:
        return 'Februari';
      case 3:
        return 'Maret';
      case 4:
        return 'April';
      case 5:
        return 'Mei';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'Agustus';
      case 9:
        return 'September';
      case 10:
        return 'Oktober';
      case 11:
        return 'November';
      case 12:
        return 'Desember';
      default:
        return '';
    }
  }

  // Fungsi helper untuk mendapatkan warna berdasarkan status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      // Pastikan case insensitive
      case 'masuk':
        return Colors.blue[100]!;
      case 'proses':
        return Colors.orange[100]!;
      case 'selesai':
        return Colors.green[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  // Fungsi helper untuk mendapatkan warna teks berdasarkan status
  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'masuk':
        return Colors.blue[700]!;
      case 'proses':
        return Colors.orange[700]!;
      case 'selesai':
        return Colors.green[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  // Fungsi yang berisi konten untuk halaman beranda
  Widget _buildHomePageContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(
                context,
              ).style.copyWith(fontSize: 22, color: Colors.black87),
              children: <TextSpan>[
                TextSpan(
                  text: 'Selamat Datang, ',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                TextSpan(
                  text: '$_namaPengguna!',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Laporan sampah yang perlu Anda tangani:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        _isLoading // Tampilkan loading indicator
            ? const Expanded(child: Center(child: CircularProgressIndicator()))
            : _errorMessage !=
                null // Tampilkan error message
            ? Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _fetchLaporan,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            )
            : _laporanSampah.isEmpty
            ? Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: Colors.green[400],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Tidak ada laporan sampah yang perlu diambil saat ini.\nTerima kasih atas kerja keras Anda!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
            : Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _laporanSampah.length,
                itemBuilder: (context, index) {
                  final Report laporan = _laporanSampah[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child:
                                    laporan.gambarUrl != null
                                        ? (laporan.isLocalImage
                                            ? Image.file(
                                              File(laporan.gambarUrl!),
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )
                                            : Image.network(
                                              laporan.gambarUrl!,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Container(
                                                  width: 80,
                                                  height: 80,
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Icons.broken_image,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                            ))
                                        : Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey,
                                          ),
                                        ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ID Laporan: ${laporan.id}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      laporan.lokasiLaporan,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.category,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          laporan.jenisSampah,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4.0),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          '${laporan.tanggalLaporan.day} '
                                          '${_getMonthName(laporan.tanggalLaporan.month)} '
                                          '${laporan.tanggalLaporan.year}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24, thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(laporan.status),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  laporan.status,
                                  style: TextStyle(
                                    color: _getStatusTextColor(laporan.status),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              if (laporan.status.toLowerCase() == 'masuk')
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blue[700],
                                      ),
                                      tooltip: 'Edit Laporan',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => EditReportFormPage(
                                                  laporanData: laporan,
                                                  onUpdate: _updateLaporan,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red[700],
                                      ),
                                      tooltip: 'Hapus Laporan',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: const Text(
                                                  'Hapus Laporan?',
                                                ),
                                                content: Text(
                                                  'Anda yakin ingin menghapus laporan ${laporan.id}?',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () => Navigator.pop(
                                                          context,
                                                        ),
                                                    child: const Text('Batal'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      _deleteLaporan(
                                                        laporan.id,
                                                      );
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'Hapus',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => DetailLaporanPage(
                                            laporanData: laporan,
                                          ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('Lihat Detail'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? 'Lapor Sampah'
              : (_selectedIndex == 1 ? 'Riwayat' : 'Statistik'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green[700],
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Aksi saat tombol notifikasi ditekan
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              // Aksi saat tombol profil ditekan
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton:
          _selectedIndex == 0
              ? FloatingActionButton.extended(
                onPressed: () {
                  // Navigasi ke halaman form laporan baru
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder:
                  //         (context) => NewReportFormPage(
                  //           onNewReport: (newReport) {
                  //             // Callback saat laporan baru berhasil dibuat
                  //             // Tambahkan laporan baru ke list lokal dan refresh UI
                  //             setState(() {
                  //               _laporanSampah.add(newReport);
                  //             });
                  //             _fetchLaporan(); // Opsional: refresh dari API untuk memastikan data konsisten
                  //           },
                  //         ),
                  //   ),
                  // );
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Lapor Sampah Baru',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.green[600],
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
            // Jika pindah ke tab Beranda, refresh data
            if (index == 0) {
              _fetchLaporan();
            }
          });
        },
      ),
    );
  }
}
