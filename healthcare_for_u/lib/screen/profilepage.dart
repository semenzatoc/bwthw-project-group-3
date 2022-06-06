import 'dart:io';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repository/databaseRepository.dart';
import 'calendarpage.dart';
import 'healthpage.dart';
import 'homepage.dart';
import 'loginpage.dart';
import 'package:healthcare_for_u/utils/BMI.dart';
import 'package:provider/provider.dart';
import 'package:healthcare_for_u/database/database.dart';

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
                onPressed: () async {
                  // await Provider.of<DatabaseRepository>(context, listen: false)
                  //   .clearActivityTable();
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
        children: [
          //imageProfile(),
          Container(
              color: const Color.fromARGB(255, 130, 207, 243),
              height: 200,
              width: 450,
              child: Row(
                children: [
                  const SizedBox(width: 40),
                  const Text(
                    'Hello Bob!',
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  imageProfile(),
                  /*ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: const Image(
                image: AssetImage('assets/trying.jpg'),
                width: 100,
                height: 100,
                fit: BoxFit.none,
          ),),*/
                ],
              )),
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
                            const SizedBox(
                              width: 15,
                            ),
                            const Icon(
                              MdiIcons.account,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            TextButton(
                              child: const Text(
                                'Profile',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                              onPressed: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 80),
                                      child: AlertDialog(
                                          title: const Text('Profile'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Row(children: [
                                                  const Icon(MdiIcons.account),
                                                  Text(
                                                      'Name: ${sp.getString('name')}'),
                                                ]),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(MdiIcons
                                                        .cakeVariantOutline),
                                                    Text(
                                                        'Date of Birth: ${sp.getString('dob')}'),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                          ])),
                                );
                              },
                            ),
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
                        var bmi = BMI(sp);
                        return Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            const Icon(
                              MdiIcons.heart,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            TextButton(
                              child: const Text(
                                'Health Status',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                              onPressed: () {
                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 80),
                                      child: AlertDialog(
                                          title: const Text('Health Status'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Row(children: [
                                                  const Icon(MdiIcons.weight),
                                                  Text(
                                                      'Weight: ${sp.getString('weight')} kg'),
                                                ]),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(MdiIcons
                                                        .humanMaleHeightVariant),
                                                    Text(
                                                        'Height: ${sp.getString('height')} cm'),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                Row(
                                                  children: [
                                                    const Icon(MdiIcons.heart),
                                                    Text('BMI $bmi'),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                          ])),
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        return const Text('No data available');
                      }
                    }),
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
    sp.setInt('usercode', -1);

// RIMUOVERE A FINE DEBUG
    await Provider.of<DatabaseRepository>(context, listen: false)
        .clearActivityTable();
    // unauthorize Fitbit connection
    await FitbitConnector.unauthorize(
        clientID: '<OAuth 2.0 Client ID>', clientSecret: '<Client Secret>');

    // return to login page
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
            return Stack(children: <Widget>[
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
                  child: const Icon(Icons.camera_alt,
                      color: Colors.teal, size: 28),
                ),
              ),
            ]);
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
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(children: <Widget>[
          const Text(
            "Choose profile photo",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            IconButton(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                icon: const Icon(Icons.camera),
                tooltip: "Camera"),
            IconButton(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                icon: const Icon(Icons.image),
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
