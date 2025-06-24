import 'package:aplikasi_laporan_sampah/constant/app_color.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Data dummy untuk daftar laporan sampah
  // final List<Map<String, String>> _laporanSampah = [
  //   {
  //     'id': 'LPS001',
  //     'lokasi': 'Jl. Merdeka No. 10, Jakarta Pusat',
  //     'jenis_sampah': 'Organik & Anorganik',
  //     'tanggal': '23 Juni 2025',
  //     'status': 'Menunggu Penjemputan',
  //     'gambar_url':
  //         'https://via.placeholder.com/150/FF6347/FFFFFF?text=Sampah+1', // Ganti dengan URL gambar asli
  //   },
  //   {
  //     'id': 'LPS002',
  //     'lokasi': 'Perumahan Indah Blok C-5, Bekasi',
  //     'jenis_sampah': 'Kertas',
  //     'tanggal': '23 Juni 2025',
  //     'status': 'Menunggu Penjemputan',
  //     'gambar_url':
  //         'https://via.placeholder.com/150/4682B4/FFFFFF?text=Sampah+2', // Ganti dengan URL gambar asli
  //   },
  //   {
  //     'id': 'LPS003',
  //     'lokasi': 'Dekat Pasar Tradisional, Bandung',
  //     'jenis_sampah': 'Plastik',
  //     'tanggal': '22 Juni 2025',
  //     'status': 'Menunggu Penjemputan',
  //     'gambar_url':
  //         'https://via.placeholder.com/150/3CB371/FFFFFF?text=Sampah+3', // Ganti dengan URL gambar asli
  //   },
  //   {
  //     'id': 'LPS004',
  //     'lokasi': 'Area Kantor, Surabaya',
  //     'jenis_sampah': 'Elektronik',
  //     'tanggal': '22 Juni 2025',
  //     'status': 'Menunggu Penjemputan',
  //     'gambar_url':
  //         'https://via.placeholder.com/150/FFD700/FFFFFF?text=Sampah+4', // Ganti dengan URL gambar asli
  //   },
  //
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EcoGreen',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColor.mygreen, // Warna tema hijau untuk lingkungan
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(
                  context,
                ).style.copyWith(fontSize: 20, color: Colors.black87),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Selamat Datang, ',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  TextSpan(
                    text: 'Nama',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green, // Warna nama pengguna
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SizedBox(height: 16),
          Expanded(
            child:
                _laporanSampah.isEmpty
                    ? Center(
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
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _laporanSampah.length,
                      itemBuilder: (context, index) {
                        final laporan = _laporanSampah[index];
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
                                    // Gambar laporan sampah
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        laporan['gambar_url']!,
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
                                      ),
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'ID Laporan: ${laporan['id']}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            laporan['lokasi']!,
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
                                                laporan['jenis_sampah']!,
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
                                                laporan['tanggal']!,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange[100],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        laporan['status']!,
                                        style: TextStyle(
                                          color: Colors.orange[700],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        // Aksi saat tombol "Lihat Detail" ditekan
                                        // Anda bisa menavigasi ke halaman detail laporan
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Melihat detail laporan ${laporan['id']}',
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.arrow_forward),
                                      label: const Text('Lihat Detail'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors
                                                .green, // Warna tombol yang kohesif dengan tema
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Aksi saat tombol "Buat Laporan Baru" ditekan
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Membuka halaman buat laporan baru')),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Lapor Sampah Baru',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[600], // Warna tombol FAB
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Peta'),
        ],
        currentIndex: 0, // Indeks halaman saat ini
        selectedItemColor: Colors.green[800], // Warna item terpilih
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Aksi saat item Bottom Navigation Bar ditekan
          // Anda bisa mengatur navigasi antar halaman di sini
        },
      ),
    );
  }
}
