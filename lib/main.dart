import 'package:aplikasi_laporan_sampah/constant/app_color.dart';
import 'package:aplikasi_laporan_sampah/pages/home_page.dart';
import 'package:aplikasi_laporan_sampah/pages/login_page.dart';
// import 'package:aplikasi_laporan_sampah/pages/profile_screen.dart';
import 'package:aplikasi_laporan_sampah/pages/register_page.dart';
import 'package:aplikasi_laporan_sampah/pages/splash_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => SplashScreen(),
        "/login": (context) => LoginScreenApi(),
        LoginScreenApi.id: (context) => LoginScreenApi(),
        RegisterScreenAPI.id: (context) => RegisterScreenAPI(),
        HomePage.id: (context) => HomePage(),
      },
      title: 'EcoGreen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.mygreen),
      ),
      // home: HomePage(),
    );
  }
}
