import 'package:aplikasi_laporan_sampah/api/user_api.dart';
import 'package:aplikasi_laporan_sampah/constant/app_color.dart';
import 'package:aplikasi_laporan_sampah/helper/preference.dart';
import 'package:aplikasi_laporan_sampah/pages/home_page.dart';
import 'package:aplikasi_laporan_sampah/pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginScreenApi extends StatefulWidget {
  const LoginScreenApi({super.key});
  static const String id = "/login_screen_api";
  @override
  State<LoginScreenApi> createState() => _LoginScreenApiState();
}

class _LoginScreenApiState extends State<LoginScreenApi> {
  final UserService userService = UserService();
  bool isVisibility = false;
  bool isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void login() async {
    setState(() {
      isLoading = true;
    });
    final res = await userService.loginUser(
      email: emailController.text,
      password: passwordController.text,
    );
    if (res["data"] != null) {
      SharePref.saveToken(res["data"]["token"]);
      print("Token: ${res["data"]["token"]}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login successful!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushNamedAndRemoveUntil(context, HomePage.id, (route) => false);
    } else if (res["errors"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${res["message"]}"),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stack(children: [buildBackground(), buildLayer()]),
      ),
    );
  }

  SafeArea buildLayer() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              height(12),
              Text(
                "Login to your account",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColor.mygreen,
                ),
              ),
              height(24),
              buildTitle("Email"),
              height(12),
              buildTextField(
                hintText: "Enter your email",
                controller: emailController,
              ),
              height(16),
              buildTitle("Password"),
              height(12),
              buildTextField(
                hintText: "Enter your password",
                isPassword: true,
                controller: passwordController,
              ),
              height(12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => MeetSebelas()),
                    // );
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              height(24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("Email: ${emailController.text}");
                      print("Password: ${passwordController.text}");
                      login();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.mygreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child:
                      isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 16, color: AppColor.gray88),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterScreenAPI.id);
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: AppColor.mygreen,

                        fontSize: 16,
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
    );
  }

  Container buildBackground() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColor.neutral,
        // image: DecorationImage(
        //   image: AssetImage("assets/images/background.png"),
        //   fit: BoxFit.cover,
        // ),
      ),
    );
  }

  Widget buildTextField({
    String? hintText,
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      obscureText: isPassword ? isVisibility : false,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.black, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        suffixIcon:
            isPassword
                ? IconButton(
                  onPressed: () {
                    setState(() {
                      isVisibility = !isVisibility;
                    });
                  },
                  icon: Icon(
                    isVisibility ? Icons.visibility_off : Icons.visibility,
                    color: AppColor.gray88,
                  ),
                )
                : null,
      ),
    );
  }

  SizedBox height(double height) => SizedBox(height: height);
  SizedBox width(double width) => SizedBox(width: width);

  Widget buildTitle(String text) {
    return Row(
      children: [
        Text(text, style: TextStyle(fontSize: 16, color: AppColor.mygreen)),
      ],
    );
  }
}
