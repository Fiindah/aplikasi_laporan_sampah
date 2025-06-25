import 'package:flutter/material.dart';

class NewReportFormPage extends StatefulWidget {
  const NewReportFormPage({super.key});

  @override
  State<NewReportFormPage> createState() => _NewReportFormPageState();
}

class _NewReportFormPageState extends State<NewReportFormPage> {
  final _formKey = GlobalKey<FormState>(); // Kunci untuk validasi form

  // Controller untuk input teks
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();

  // Variabel untuk menyimpan nilai yang dipilih
  File? _selectedImage; // Untuk menyimpan file gambar yang dipilih

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    ); // Bisa juga ImageSource.camera

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Fungsi saat form disubmit
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form valid, lakukan sesuatu dengan data
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mengirim laporan...')));

      // Anda bisa mencetak data atau mengirimnya ke backend
      print('Lokasi: ${_lokasiController.text}');
      print('Jenis Sampah: $_selectedJenisSampah');
      print('Deskripsi: ${_deskripsiController.text}');
      print('Gambar: ${_selectedImage?.path ?? "Tidak ada gambar"}');

      // Setelah submit, mungkin ingin kembali ke halaman sebelumnya
      // atau menampilkan pesan sukses dan mereset form.
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    }
  }

  @override
  void dispose() {
    _lokasiController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Laporan Sampah Baru',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
        iconTheme: const IconThemeData(color: Colors.white), // Warna ikon back
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Pasang GlobalKey ke Form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Lokasi
              TextFormField(
                controller: _lokasiController,
                decoration: InputDecoration(
                  labelText: 'Lokasi Sampah',
                  hintText: 'Cth: Jl. Kebersihan No. 5',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lokasi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Dropdown Jenis Sampah
              DropdownButtonFormField<String>(
                value: _selectedJenisSampah,
                hint: const Text('Pilih Jenis Sampah'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.category),
                ),
                items:
                    _jenisSampahOptions.map((String jenis) {
                      return DropdownMenuItem<String>(
                        value: jenis,
                        child: Text(jenis),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedJenisSampah = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis sampah harus dipilih';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Input Deskripsi Tambahan
              TextFormField(
                controller: _deskripsiController,
                maxLines: 4, // Multi-line input
                decoration: InputDecoration(
                  labelText: 'Deskripsi Tambahan (Opsional)',
                  hintText: 'Cth: Banyak sampah plastik dan botol kaca.',
                  alignLabelWithHint:
                      true, // Untuk label di atas input multi-line
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(
                      bottom: 60,
                    ), // Posisikan ikon di atas
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Icon(Icons.description),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bagian Unggah Gambar
              GestureDetector(
                onTap: _pickImage, // Panggil fungsi _pickImage saat diklik
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  dashPattern: const [8, 4],
                  strokeCap: StrokeCap.round,
                  color: Colors.grey[400]!,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        _selectedImage != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150,
                              ),
                            )
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload,
                                  size: 50,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Unggah Gambar Sampah',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Text(
                                  '(Ketuk untuk memilih)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitForm, // Panggil fungsi _submitForm
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text(
                    'Kirim Laporan',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
