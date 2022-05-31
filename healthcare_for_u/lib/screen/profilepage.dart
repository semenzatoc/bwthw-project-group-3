import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calendarpage.dart';
import 'healthpage.dart';
import 'homepage.dart';
import 'loginpage.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  static const route = '/profile';
  static const routename = 'Profile Page';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(ProfilePage.routename),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  _toLoginPage(context);
                },
                icon: const Icon(Icons.logout))
          ]),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              tooltip: 'Calendar',
              icon: const Icon(Icons.calendar_month),
              onPressed: () {
                Navigator.pushReplacementNamed(context, CalendarPage.route);
              },
            ),
            IconButton(
              tooltip: 'Home',
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacementNamed(context, HomePage.route);
              },
            ),
            IconButton(
              tooltip: 'Check your health status',
              icon: const Icon(MdiIcons.heartFlash),
              onPressed: () {
                Navigator.pushReplacementNamed(context, HealthPage.route);
              },
            ),
            IconButton(
              tooltip: 'Profile',
              icon: const Icon(Icons.person),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageProfile(),
          const SizedBox(
            height: 20,
          ),
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder(
                    future: SharedPreferences.getInstance(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final sp = snapshot.data as SharedPreferences;
                        return Row(
                          children: [
                            const Icon(MdiIcons.account),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              '${sp.getString('name')}',
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        );
                      } else {
                        return const Text('No data available');
                      }
                    }),
                const SizedBox(height: 10),
                const Divider(
                    height: 10,
                    thickness: 1,
                    indent: 10,
                    endIndent: 0,
                    color: Colors.grey),
                const SizedBox(height: 10),
                FutureBuilder(
                    future: SharedPreferences.getInstance(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final sp = snapshot.data as SharedPreferences;
                        return Row(
                          children: [
                            const Icon(MdiIcons.cakeVariantOutline),
                            const SizedBox(width: 15),
                            Text(
                              '${sp.getString('dob')}',
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        );
                      } else {
                        return const Text('No data available');
                      }
                    }),
                const SizedBox(height: 10),
                const Divider(
                    height: 10,
                    thickness: 1,
                    indent: 10,
                    endIndent: 0,
                    color: Colors.grey),
                const SizedBox(height: 10),
                FutureBuilder(
                    future: SharedPreferences.getInstance(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final sp = snapshot.data as SharedPreferences;
                        return Row(
                          children: [
                            const Icon(MdiIcons.weight),
                            const SizedBox(width: 15),
                            Text(
                              '${sp.getString('weight')} kg ',
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        );
                      } else {
                        return const Text('No data available');
                      }
                    }),
                const SizedBox(height: 10),
                const Divider(
                    height: 10,
                    thickness: 1,
                    indent: 10,
                    endIndent: 0,
                    color: Colors.grey),
                const SizedBox(height: 10),
                FutureBuilder(
                    future: SharedPreferences.getInstance(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final sp = snapshot.data as SharedPreferences;
                        return Row(
                          children: [
                            const Icon(MdiIcons.humanMaleHeightVariant),
                            const SizedBox(width: 15),
                            Text(
                              '${sp.getString('height')} cm',
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        );
                      } else {
                        return const Text('No data available');
                      }
                    }),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toLoginPage(BuildContext context) async {
    //Unset the 'username' filed in SharedPreference
    final sp = await SharedPreferences.getInstance();
    sp.remove('username');

    Navigator.pushNamedAndRemoveUntil(
        context, LoginPage.route, (Route<dynamic> route) => false);
  }

  Widget imageProfile() {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var sp = snapshot.data as SharedPreferences;
            String? path = sp.getString('imagepath');
            return Center(
              child: Stack(children: <Widget>[
                CircleAvatar(
                    radius: 80,
                    backgroundImage: path == ''
                        ? const AssetImage("assets/trying.jpg")
                        : FileImage(File(path!)) as ImageProvider),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: ((BuildContext context) => bottomSheet()),
                      );
                    },
                    child: Icon(Icons.camera_alt, color: Colors.teal, size: 28),
                  ),
                ),
              ]),
            );
          } else {
            return const Text(
                'Not enough data available'); // se non ho fatto il sign up form
          }
        });
  }

  Widget bottomSheet() {
    return Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(children: <Widget>[
          Text(
            "Choose profile photo",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            IconButton(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: Icon(Icons.camera),
                tooltip: "Camera"),
            IconButton(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: Icon(Icons.image),
                tooltip: "Gallery")
          ])
        ]));
  }

  void takePhoto(ImageSource source) async {
    XFile? _imagefile;
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: source);
    final sp = await SharedPreferences.getInstance();
    setState(() {
      sp.setString('imagepath', pickedFile!.path);
    });
  }
} //ProfilePage
