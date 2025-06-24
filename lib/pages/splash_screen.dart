import 'package:aplikasi_laporan_sampah/constant/app_image.dart';
import 'package:aplikasi_laporan_sampah/constant/app_style.dart';
import 'package:aplikasi_laporan_sampah/helper/preference.dart';
import 'package:aplikasi_laporan_sampah/pages/login_screen.dart';
// import 'package:belajar_flutter/constant/app_image.dart';
// import 'package:belajar_flutter/constant/app_style.dart';
// import 'package:belajar_flutter/helper/preference.dart';
// import 'package:belajar_flutter/meet25/tugas_15/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void changePage() {
    Future.delayed(Duration(seconds: 3), () async {
      bool isLogin = await SharePref.getLogin();
      print("isLogin: $isLogin");
      // if (isLogin) {
      //   return Navigator.pushNamedAndRemoveUntil(
      //     context,
      //     LoginScreenApi.id,
      //     (route) => false,
      //   );
      // } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginScreenApi.id,
        (route) => false,
      );
      // }
    });
  }

  @override
  void initState() {
    changePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset(AppImage.logo),
            ),
            SizedBox(height: 20),
            Text("Jaga Bumi Kita, Laporkan Sampah", style: AppStyle.fontBold()),
            Spacer(),
            SafeArea(
              child: Text("v 1.0.0", style: AppStyle.fontRegular(fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }
}
