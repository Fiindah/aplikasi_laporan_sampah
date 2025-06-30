import 'package:aplikasi_laporan_sampah/api/user_api.dart';
import 'package:aplikasi_laporan_sampah/constant/app_color.dart';
import 'package:aplikasi_laporan_sampah/constant/app_image.dart';
import 'package:flutter/material.dart';

class RegisterScreenAPI extends StatefulWidget {
  const RegisterScreenAPI({super.key});
  static const String id = "/register_screen_api";

  @override
  State<RegisterScreenAPI> createState() => _RegisterScreenAPIState();
}

class _RegisterScreenAPIState extends State<RegisterScreenAPI> {
  final UserService userService = UserService();
  bool _isPasswordVisible = false; // Renamed for clarity
  bool _isLoading = false; // Renamed for clarity

  final TextEditingController _emailController =
      TextEditingController(); // Renamed for clarity
  final TextEditingController _nameController =
      TextEditingController(); // Renamed for clarity
  final TextEditingController _passwordController =
      TextEditingController(); // Renamed for clarity
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() async {
    // Renamed for clarity
    if (!_formKey.currentState!.validate()) {
      return; // Stop if form is not valid
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final res = await userService.registerUser(
        email: _emailController.text,
        name: _nameController.text,
        password: _passwordController.text,
      );

      if (res["data"] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pendaftaran berhasil! Silakan masuk."),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to login page
      } else if (res["errors"] != null) {
        String errorMessage = "Pendaftaran gagal.";
        if (res["errors"]["email"] != null) {
          errorMessage += "\nEmail: ${res["errors"]["email"].join(', ')}";
        }
        if (res["errors"]["name"] != null) {
          errorMessage += "\nNama: ${res["errors"]["name"].join(', ')}";
        }
        if (res["errors"]["password"] != null) {
          errorMessage +=
              "\nKata Sandi: ${res["errors"]["password"].join(', ')}";
        } else if (res["message"] != null) {
          errorMessage = res["message"];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pendaftaran gagal: Respon tidak terduga."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint("Registration Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan saat pendaftaran: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.neutral, // Consistent background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImage.logo,
                height: 120, // Adjusted size
                width: 120,
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 0),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Daftar Akun Baru",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColor.mygreen,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildTitle("Email"),
                        const SizedBox(height: 12),
                        _buildTextField(
                          hintText: "Masukkan email Anda",
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email tidak boleh kosong';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Masukkan email yang valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTitle("Nama Lengkap"), // Changed text
                        const SizedBox(height: 12),
                        _buildTextField(
                          hintText:
                              "Masukkan nama lengkap Anda", // Changed text
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTitle("Kata Sandi"),
                        const SizedBox(height: 12),
                        _buildTextField(
                          hintText: "Masukkan kata sandi Anda",
                          controller: _passwordController,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kata sandi tidak boleh kosong';
                            }
                            if (value.length < 6) {
                              return 'Kata sandi minimal 6 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.mygreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                            ),
                            child:
                                _isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Text(
                                      "Daftar",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sudah punya akun?", // Changed text
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColor.gray88,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                "Masuk", // Changed text
                                style: TextStyle(
                                  color: AppColor.mygreen,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  // Renamed and improved TextField styling
  Widget _buildTextField({
    String? hintText,
    bool isPassword = false,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: isPassword ? !_isPasswordVisible : false,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColor.mygreen, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.grey[100],
        suffixIcon:
            isPassword
                ? IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColor.gray88,
                  ),
                )
                : null,
      ),
    );
  }

  // Renamed
  Widget _buildTitle(String text) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColor.mygreen,
          ),
        ),
      ],
    );
  }
}
