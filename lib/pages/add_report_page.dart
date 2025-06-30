import 'dart:io'; // Required for File

import 'package:aplikasi_laporan_sampah/api/report_api.dart';
import 'package:aplikasi_laporan_sampah/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddReportPage extends StatefulWidget {
  const AddReportPage({super.key});
  static const String id = "/add_report_page";

  @override
  State<AddReportPage> createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();

  File? _selectedImage; // To store the selected image file
  bool _isLoading = false; // To manage loading state during API call
  String? _selectedStatus; // To store the selected status from the dropdown

  // List of available statuses for the dropdown
  final List<String> _statuses = ['masuk', 'proses', 'selesai'];

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Function to handle report submission
  Future<void> _submitReport() async {
    // Validate the form before proceeding
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedStatus == null) {
      _showSnackBar('Pilih status laporan terlebih dahulu.', Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true; // Set loading state to true
    });

    try {
      // IMPORTANT: For real-world apps, you'll need to upload
      // '_selectedImage' to a server (e.g., Firebase Storage, AWS S3)
      // to get a downloadable URL. For this example, we'll use a placeholder
      // or assume the API handles base64 directly (less common but possible).
      // If your API expects a URL, and you're providing a local file,
      // this part needs a proper image upload mechanism.
      String? imageUrlToSend;
      if (_selectedImage != null) {
        // --- Placeholder for actual image upload logic ---
        // This is where you would upload _selectedImage and get a URL.
        // Example:
        // final String uploadedUrl = await ImageUploaderService.upload(_selectedImage!);
        // imageUrlToSend = uploadedUrl;
        // For now, if no real upload is implemented, this will send null or an empty string,
        // unless you're explicitly sending base64 which is less common for "imageUrl" fields.
        //
        // If your backend handles base64 directly (unlikely for an 'imageUrl' field):
        // List<int> imageBytes = await _selectedImage!.readAsBytes();
        // String base64Image = base64Encode(imageBytes);
        // imageUrlToSend = base64Image;
        //
        // For demonstration, let's assume if an image is selected,
        // we're just pretending it's uploaded and getting a dummy URL.
        // In a real scenario, this would be a URL from your storage service.
        imageUrlToSend =
            'https://placehold.co/600x400/000000/FFFFFF/png?text=Laporan+Gambar';
      }

      // Call the postReport API
      final response = await ReportService().postReport(
        judul: _judulController.text,
        isi: _isiController.text,
        status: _selectedStatus!,
        lokasi: _lokasiController.text,
        imageUrl: imageUrlToSend,
      );

      // Show success message
      _showSnackBar('Laporan berhasil ditambahkan!', Colors.green);

      // Navigate back to the previous page and indicate success
      Navigator.pop(context, true);
    } catch (e) {
      // Show error message
      _showSnackBar('Gagal menambahkan laporan: $e', Colors.red);
      debugPrint('Error adding report: $e'); // Log the error for debugging
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state
      });
    }
  }

  // Helper to show a SnackBar message
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
          'Tambah Laporan Baru',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColor.mygreen,
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(),
              ) // Show loading indicator
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey, // Assign the form key
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul Laporan Input
                      TextFormField(
                        controller: _judulController,
                        decoration: InputDecoration(
                          labelText: 'Judul Laporan',
                          hintText: 'Cth: Sampah menumpuk di jalan A',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Judul laporan tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Isi Laporan Input
                      TextFormField(
                        controller: _isiController,
                        maxLines: 5, // Allow multiple lines for content
                        decoration: InputDecoration(
                          labelText: 'Isi Laporan',
                          hintText: 'Jelaskan detail laporan Anda...',
                          alignLabelWithHint:
                              true, // Aligns label with hint text in multiline fields
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Isi laporan tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Lokasi Laporan Input
                      TextFormField(
                        controller: _lokasiController,
                        decoration: InputDecoration(
                          labelText: 'Lokasi Kejadian',
                          hintText: 'Cth: Jalan Merdeka No. 10, Jakarta',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lokasi tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Status Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        hint: const Text('Pilih Status Laporan'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        items:
                            _statuses.map((String status) {
                              return DropdownMenuItem<String>(
                                value: status,
                                child: Text(status.toUpperCase()),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedStatus = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Status tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Image Picker Section
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
                                  : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey[600],
                                        size: 50,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Pilih Gambar',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      SizedBox(
                        width: double.infinity, // Make button fill width
                        child: ElevatedButton.icon(
                          onPressed: _submitReport,
                          icon: const Icon(Icons.send),
                          label: const Text(
                            'Kirim Laporan',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: AppColor.mygreen,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5, // Add shadow
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
