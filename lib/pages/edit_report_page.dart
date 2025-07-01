import 'dart:io';

import 'package:aplikasi_laporan_sampah/api/report_api.dart';
import 'package:aplikasi_laporan_sampah/constant/app_color.dart';
import 'package:aplikasi_laporan_sampah/models/laporan_data_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditReportPage extends StatefulWidget {
  final Data report;

  const EditReportPage({super.key, required this.report});

  @override
  State<EditReportPage> createState() => _EditReportPageState();
}

class _EditReportPageState extends State<EditReportPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulController;
  late TextEditingController _isiController;
  late TextEditingController _lokasiController;

  File? _selectedImage;
  String? _currentImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.report.judul);
    _isiController = TextEditingController(text: widget.report.isi);
    _lokasiController = TextEditingController(text: widget.report.lokasi);
    _currentImageUrl = widget.report.imageUrl;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _currentImageUrl = null;
      });
    }
  }

  Future<void> _updateReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ReportService().updateReport(
        reportId: widget.report.id.toString(),
        judul: _judulController.text,
        isi: _isiController.text,
        lokasi: _lokasiController.text,
        status: widget.report.status!,
        imageFile: _selectedImage, // ✅ File? yang dikirim ke API
      );

      _showSnackBar('Laporan berhasil diperbarui!', Colors.green);
      Navigator.pop(context, true);
    } catch (e) {
      _showSnackBar('Gagal memperbarui laporan: $e', Colors.red);
      debugPrint('Error updating report: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmDelete() async {
    final bool confirm =
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text('Hapus Laporan?'),
              content: const Text(
                'Anda yakin ingin menghapus laporan ini? Tindakan ini tidak bisa dibatalkan.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Hapus'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirm) {
      _deleteReport();
    }
  }

  Future<void> _deleteReport() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ReportService().deleteReport(widget.report.id.toString());
      _showSnackBar('Laporan berhasil dihapus!', Colors.green);
      Navigator.pop(context, true);
    } catch (e) {
      _showSnackBar('Gagal menghapus laporan: $e', Colors.red);
      debugPrint('Error deleting report: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Laporan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.mygreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            tooltip: 'Hapus Laporan',
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _judulController,
                        decoration: _inputDecoration(
                          'Judul Laporan',
                          'Cth: Sampah menumpuk di jalan A',
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'Judul tidak boleh kosong'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _isiController,
                        maxLines: 5,
                        decoration: _inputDecoration(
                          'Isi Laporan',
                          'Jelaskan detail laporan Anda...',
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'Isi tidak boleh kosong'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _lokasiController,
                        decoration: _inputDecoration(
                          'Lokasi Kejadian',
                          'Cth: Jalan Merdeka No. 10',
                        ),
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? 'Lokasi tidak boleh kosong'
                                    : null,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey),
                          ),
                          child:
                              _selectedImage != null
                                  ? Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                  )
                                  : (_currentImageUrl != null &&
                                          _currentImageUrl!.isNotEmpty
                                      ? CachedNetworkImage(
                                        imageUrl: _currentImageUrl!,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                        errorWidget:
                                            (context, url, error) => const Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                            ),
                                      )
                                      : _imagePlaceholder()),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _updateReport,
                          icon: const Icon(Icons.save),
                          label: const Text(
                            'Simpan Perubahan',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.mygreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      filled: true,
      fillColor: Colors.grey[100],
    );
  }

  Widget _imagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.camera_alt, size: 50, color: Colors.grey[600]),
        const SizedBox(height: 8),
        Text(
          'Pilih atau Ganti Gambar',
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
      ],
    );
  }
}
