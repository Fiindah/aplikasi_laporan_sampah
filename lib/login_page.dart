import 'package:aplikasi_laporan_sampah/api/user_api.dart';
import 'package:aplikasi_laporan_sampah/constant/app_color.dart';
import 'package:aplikasi_laporan_sampah/constant/app_image.dart';
import 'package:aplikasi_laporan_sampah/helper/preference.dart';
import 'package:aplikasi_laporan_sampah/pages/main_wrapper_page.dart';
import 'package:aplikasi_laporan_sampah/register_page.dart';
import 'package:flutter/material.dart';

class LoginScreenApi extends StatefulWidget {
  const LoginScreenApi({super.key});
  static const String id = "/login_screen_api";

  @override
  State<LoginScreenApi> createState() => _LoginScreenApiState();
}

class _LoginScreenApiState extends State<LoginScreenApi> {
  final UserService userService = UserService();
  bool _isPasswordVisible = false; // Renamed for clarity
  bool _isLoading = false; // Renamed for clarity

  final TextEditingController _emailController =
      TextEditingController(); // Renamed for clarity
  final TextEditingController _passwordController =
      TextEditingController(); // Renamed for clarity
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    // Renamed for clarity
    if (!_formKey.currentState!.validate()) {
      return; // Stop if form is not valid
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final res = await userService.loginUser(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (res["data"] != null) {
        SharePref.saveToken(res["data"]["token"]);
        debugPrint("Token: ${res["data"]["token"]}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login berhasil!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, MainWrapperPage.id);
      } else if (res["errors"] != null) {
        // More specific error handling for API validation messages
        String errorMessage = "Login gagal.";
        if (res["errors"]["email"] != null) {
          errorMessage += "\nEmail: ${res["errors"]["email"].join(', ')}";
        }
        if (res["errors"]["password"] != null) {
          errorMessage += "\nPassword: ${res["errors"]["password"].join(', ')}";
        } else if (res["message"] != null) {
          // General message from API if no specific field errors
          errorMessage = res["message"];
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login gagal: Respon tidak terduga."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan saat login: $e"),
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
                elevation: 8, // Add distinct shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 0,
                ), // No extra horizontal margin
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
                            "Masuk Akun Anda",
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
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implement Forgot Password logic
                            },
                            child: Text(
                              "Lupa Kata Sandi?",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColor.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.mygreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ), // More rounded corners
                              ),
                              elevation: 4, // Button shadow
                            ),
                            child:
                                _isLoading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : const Text(
                                      "Masuk",
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
                              "Belum punya akun?",
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColor.gray88,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  RegisterScreenAPI.id,
                                );
                              },
                              child: Text(
                                "Daftar Sekarang", // Changed text
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
      obscureText:
          isPassword
              ? !_isPasswordVisible
              : false, // Use ! instead of direct isVisibility
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ), // Consistent padding
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // More rounded corners
          borderSide: BorderSide.none, // No border needed if filled
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none, // No border needed if filled
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColor.mygreen,
            width: 2.0,
          ), // Highlight focus
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ), // Error highlight
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ), // Error highlight on focus
        ),
        filled: true,
        fillColor: Colors.grey[100], // Light grey background for fields
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
            fontWeight: FontWeight.w600, // Slightly bolder
            color: AppColor.mygreen,
          ),
        ),
      ],
    );
  }
}
