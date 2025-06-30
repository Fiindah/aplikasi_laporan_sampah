import 'package:aplikasi_laporan_sampah/constant/app_color.dart';
import 'package:aplikasi_laporan_sampah/constant/app_image.dart';
import 'package:aplikasi_laporan_sampah/constant/app_style.dart';
import 'package:aplikasi_laporan_sampah/login_page.dart';
import 'package:aplikasi_laporan_sampah/register_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  static const String id = "/welcome_page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.neutral, // Consistent background color
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 48.0,
          ), // Increased vertical padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Image.asset(
                AppImage.logo,
                height: 180, // Adjusted size for welcome page
                width: 180,
              ),
              const SizedBox(height: 48), // Increased space
              // Welcome Title
              Text(
                "Selamat Datang di EcoGreen!",
                style: AppStyle.fontBold(
                  fontSize: 32,
                  // color: AppColor.mygreen,
                ), // Larger, bolder
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20), // Increased space
              // Welcome Message
              Text(
                "Laporkan sampah dengan mudah, bantu jaga lingkungan kita tetap bersih dan hijau. Mari bersama menciptakan masa depan yang lebih baik!", // More engaging text
                style: AppStyle.fontRegular(
                  fontSize: 17,
                  // color: Colors.grey[700],
                ), // Slightly larger, darker grey
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64), // Significant space before buttons
              // Login Button (Primary Action)
              SizedBox(
                width: double.infinity,
                height: 58, // Slightly taller button
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreenApi.id);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.mygreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // More rounded corners
                    ),
                    elevation: 6, // More prominent shadow
                  ),
                  child: const Text(
                    "Masuk",
                    style: TextStyle(
                      fontSize: 19, // Slightly larger text
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Space between buttons
              // Register Button (Secondary Action)
              SizedBox(
                width: double.infinity,
                height: 58,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RegisterScreenAPI.id);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColor.mygreen,
                    side: BorderSide(
                      color: AppColor.mygreen,
                      width: 2.5,
                    ), // Thicker border
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // More rounded corners
                    ),
                    elevation: 0,
                    backgroundColor:
                        Colors.white, // White background for outlined button
                  ),
                  child: Text(
                    "Daftar Akun Baru",
                    style: AppStyle.fontBold(
                      fontSize: 19,
                      // color: AppColor.mygreen,
                    ), // Use AppStyle and ensure color
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
