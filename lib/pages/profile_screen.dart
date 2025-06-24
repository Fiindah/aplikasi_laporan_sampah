// import 'package:belajar_flutter/constant/app_color.dart';
// import 'package:belajar_flutter/constant/app_style.dart';
// import 'package:belajar_flutter/helper/preference.dart';
// import 'package:belajar_flutter/meet25/tugas_15/api/user_api.dart';
// import 'package:belajar_flutter/meet25/tugas_15/login_screen.dart';
import 'package:flutter/material.dart';

class ProfileUserScreen extends StatefulWidget {
  const ProfileUserScreen({super.key});
  static const String id = "/profile_user_screen";

  @override
  State<ProfileUserScreen> createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  late Future<dynamic>? userUpdate;

  @override
  void initState() {
    super.initState();
    userUpdate = UserService().getProfile();
  }

  void refreshProfile() {
    setState(() {
      userUpdate = UserService().getProfile();
    });
  }

  int _selectedIndex = 0;
  // final List<Widget> _screen = [TopicListPage(), ProfilePage()];

  void _itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print("Halaman saat ini : $_selectedIndex");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter App")),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.home, color: AppColor.myblue1),
              title: Text("Home", style: AppStyle.fontRegular(fontSize: 14)),
              onTap: () {
                _itemTapped(0);
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: AppColor.myblue),
              title: Text(
                "Profil Aplikasi",
                style: AppStyle.fontRegular(fontSize: 14),
              ),
              // onTap: () {
              //   _itemTapped(1);
              //   // Navigator.pop(context); // Close the drawer
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) => const ProfilePage()),
              //   );
              // },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: AppColor.orange),
              title: Text("Keluar", style: AppStyle.fontRegular(fontSize: 14)),
              onTap: () {
                PreferenceHandler.deleteLogin();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreenApi()),
                  (route) => false,
                );
              },
            ),
            // _screen.elementAt(_selectedIndex),
          ],
        ),
      ),
      body: FutureBuilder(
        future: userUpdate,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final user = snapshot.data?["data"];
            print(user);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user["name"] ?? "Nama Tidak Tersedia",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    user["email"] ?? "Email Tidak Tersedia",
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final nameController = TextEditingController(
                                text: user?["name"],
                              );
                              return AlertDialog(
                                title: Text('Edit Name'),
                                content: TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Name',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await UserService().updatedProfile(
                                        nameController.text,
                                      );
                                      refreshProfile();

                                      Navigator.of(context).pop();
                                      // setState(() {});
                                    },
                                    child: Text('Save'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) {
                  //         final nameController = TextEditingController(
                  //           text: user?["name"],
                  //         );
                  //         return AlertDialog(
                  //           title: Text('Edit Name'),
                  //           content: TextField(
                  //             controller: nameController,
                  //             decoration: InputDecoration(labelText: 'Name'),
                  //           ),
                  //           actions: [
                  //             TextButton(
                  //               onPressed: () => Navigator.of(context).pop(),
                  //               child: Text('Cancel'),
                  //             ),
                  //             ElevatedButton(
                  //               onPressed: () {
                  //                 // Save logic here
                  //                 // For example, call an API to update the name
                  //                 UserService().updateProfile(
                  //                   name: nameController.text,
                  //                 );

                  //                 Navigator.of(context).pop();
                  //                 setState(() {});
                  //               },
                  //               child: Text('Save'),
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     );
                  //   },
                  //   child: Text(user?["name"] ?? "belum sesuai"),
                  // ),
                  // Text(user?["email"] ?? "belum sesuai"),
                ],
              ),
            );
          } else {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
        },
      ),
    );
  }
}
