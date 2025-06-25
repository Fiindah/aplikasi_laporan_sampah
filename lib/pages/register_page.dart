import 'package:aplikasi_laporan_sampah/api/user_api.dart';
import 'package:aplikasi_laporan_sampah/constant/app_color.dart';
// import 'package:belajar_flutter/constant/app_color.dart';
// import 'package:belajar_flutter/meet25/tugas_15/api/user_api.dart';
import 'package:flutter/material.dart';

class RegisterScreenAPI extends StatefulWidget {
  const RegisterScreenAPI({super.key});
  static const String id = "/register_screen_api";
  @override
  State<RegisterScreenAPI> createState() => _RegisterScreenAPIState();
}

class _RegisterScreenAPIState extends State<RegisterScreenAPI> {
  final UserService userService = UserService();
  bool isVisibility = false;
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void register() async {
    setState(() {
      isLoading = true;
    });
    final res = await userService.registerUser(
      email: emailController.text,
      name: nameController.text,
      password: passwordController.text,
    );
    if (res["data"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration successful!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (res["errors"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Maaf, ${res["message"]}"),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text(
                //   "Logo Brand",
                //   style: TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //     color: AppColor.myblue1,
                //   ),
                // ),
                height(12),
                Text(
                  "Register to your account",
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColor.mygreen,
                    fontWeight: FontWeight.bold,
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
                buildTitle("Nama"),
                height(12),
                buildTextField(
                  hintText: "Enter your name",
                  controller: nameController,
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
                        print("Name: ${nameController.text}");
                        print("Password: ${passwordController.text}");
                        register();
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
                              "Register",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),

                height(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have an account?",
                      style: TextStyle(fontSize: 16, color: AppColor.gray88),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Sign In",
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
