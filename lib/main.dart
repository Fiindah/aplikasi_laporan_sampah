import 'package:aplikasi_laporan_sampah/login_page.dart';
import 'package:aplikasi_laporan_sampah/pages/main_wrapper_page.dart';
import 'package:aplikasi_laporan_sampah/register_page.dart';
import 'package:aplikasi_laporan_sampah/splash_page.dart';
import 'package:aplikasi_laporan_sampah/welcome_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoGreen App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Set SplashScreen as the initial route
      home: const SplashScreen(),
      // Define named routes
      routes: {
        SplashScreen.id:
            (context) =>
                const SplashScreen(), // Ensure SplashScreen can be a named route
        WelcomePage.id:
            (context) => const WelcomePage(), // Add WelcomePage route
        LoginScreenApi.id: (context) => const LoginScreenApi(),
        RegisterScreenAPI.id: (context) => const RegisterScreenAPI(),
        MainWrapperPage.id: (context) => const MainWrapperPage(),
        // No need to define HomePage, HistoryPage, StatisticPage here if they are only
        // accessed via MainWrapperPage's PageView.
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
