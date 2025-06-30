import 'package:aplikasi_laporan_sampah/constant/app_image.dart';
import 'package:aplikasi_laporan_sampah/constant/app_style.dart';
import 'package:aplikasi_laporan_sampah/helper/preference.dart';
import 'package:aplikasi_laporan_sampah/pages/main_wrapper_page.dart';
import 'package:aplikasi_laporan_sampah/welcome_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String id = "/splash_screen"; // Ensure ID is consistent

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Animation controller for fade-in effect
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize animation
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Animation duration
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward(); // Start the animation

    _navigateToNextScreen(); // Call navigation logic after animation starts
  }

  /// Determines whether to navigate to the main app or the welcome page
  /// based on the user's login status from SharedPreferences.
  void _navigateToNextScreen() {
    Future.delayed(const Duration(seconds: 3), () async {
      bool isLogin = await SharePref.getLogin();
      debugPrint("isLogin: $isLogin");

      if (isLogin) {
        Navigator.pushReplacementNamed(context, MainWrapperPage.id);
      } else {
        Navigator.pushReplacementNamed(context, WelcomePage.id);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Clean white background
      body: Center(
        child: FadeTransition(
          // Apply fade transition to the content
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // App Logo
              SizedBox(
                height: 200, // Consistent sizing
                width: 200,
                child: Image.asset(AppImage.logo), // Ensure correct path
              ),
              const SizedBox(height: 20),
              // App Title
              Text(
                "Jaga Bumi Kita,",
                style: AppStyle.fontBold(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              Text(
                "Laporkan Sampah",
                style: AppStyle.fontBold(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16.0,
                  ), // Add some bottom padding
                  child: Text(
                    "v 1.0.0",
                    style: AppStyle.fontRegular(
                      fontSize: 12,
                      // color: Colors.grey[600],
                    ), // Subtle styling
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
