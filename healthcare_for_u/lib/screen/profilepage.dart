import 'dart:io';
import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_for_u/screen/utilitypage.dart';
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

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  static const route = '/profile';
  static const routename = 'Profile Page';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double? bmi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(ProfilePage.routename), actions: [
        IconButton(
            onPressed: () async {
              Navigator.pushNamed(context, UtilityPage.route);
            },
            icon: const Icon(MdiIcons.hammerWrench)),
        IconButton(
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 80),
                  child: AlertDialog(
                      content: const Text(
                          'Are you sure you want to delete your account?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Delete my account'),
                          onPressed: () async {
                            SharedPreferences sp =
                                await SharedPreferences.getInstance();
                            // delete all data of a user from the DB
                            await Provider.of<DatabaseRepository>(context,
                                    listen: false)
                                .deleteUserActivty(sp.getInt('usercode')!);
                            await Provider.of<DatabaseRepository>(context,
                                    listen: false)
                                .removeUser(sp.getInt('usercode')!);
                            _toLoginPage(context);
                          },
                        ),
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context, 'Cancel');
                          },
                        )
                      ]),
                ),
              );
            },
            icon: const Icon(Icons.delete)),
        IconButton(
            onPressed: () async {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                color: const Color.fromARGB(255, 130, 207, 243),
                height: 200,
                width: 450,
                child: Row(
                  children: [
                    const SizedBox(width: 40),
                    FutureBuilder(
                        future: SharedPreferences.getInstance(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var sp = snapshot.data as SharedPreferences;
                            var user = sp.getString('name');
                            return Text(
                              'Hello, $user!',
                              style: const TextStyle(fontSize: 30),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }),
                    const SizedBox(
                      width: 20,
                    ),
                    imageProfile(),
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
                                                    const Icon(
                                                        MdiIcons.account),
                                                    const SizedBox(width: 5),
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
                  const SizedBox(height: 15),
                  FutureBuilder(
                      future: SharedPreferences.getInstance(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final sp = snapshot.data as SharedPreferences;
                          bmi = BMI(sp);
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
                                  'My measurement',
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
                                            title: const Text('My measurement'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Row(children: [
                                                    const Icon(MdiIcons.weight),
                                                    const SizedBox(width: 5),
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
                                                      const SizedBox(width: 5),
                                                      Text(
                                                          'Height: ${sp.getString('height')} cm'),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          MdiIcons.heart),
                                                      const SizedBox(width: 5),
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
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(MdiIcons.pencil),
          onPressed: () async {
            var sp = await SharedPreferences.getInstance();
            String? updateGoal = sp.getString('goal');
            String? updateWeight = sp.getString('weight');
            String? updateHeight = sp.getString('height');
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: AlertDialog(
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Insert your new weight (in kg)'),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return null;
                                } else {
                                  updateWeight = value;
                                  return null;
                                }
                              },
                              onChanged: (value) => updateWeight = value,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Insert your new height (in cm)'),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return null;
                                } else {
                                  updateHeight = value;
                                  return null;
                                }
                              },
                              onChanged: (value) => updateHeight = value,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Insert your new step goal'),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return null;
                                } else {
                                  updateGoal = value;
                                  return null;
                                }
                              },
                              onChanged: (value) => updateGoal = value,
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                            child: const Text('Update'),
                            onPressed: () async {
                              var sp = await SharedPreferences.getInstance();
                              // update the weight
                              sp.setString('weight', updateWeight!);
                              await Provider.of<DatabaseRepository>(context,
                                      listen: false)
                                  .updateWeight(
                                      sp.getInt('usercode')!, updateWeight!);
                              // update the height
                              sp.setString('height', updateHeight!);
                              await Provider.of<DatabaseRepository>(context,
                                      listen: false)
                                  .updateHeight(
                                      sp.getInt('usercode')!, updateHeight!);
                              // update the step goal
                              sp.setString('goal', updateGoal!);
                              await Provider.of<DatabaseRepository>(context,
                                      listen: false)
                                  .updateGoal(sp.getInt('usercode')!,
                                      int.parse(updateGoal!));
                              setState(() {
                                bmi = BMI(sp);
                              });
                              Navigator.pop(context, 'Update');
                            }),
                      ],
                    )));
          }),
    );
  }

  void _toLoginPage(BuildContext context) async {
    //Unset the personal information filed in SharedPreference
    final sp = await SharedPreferences.getInstance();
    final spToRemove = [
      'name',
      'gender',
      'dob',
      'weight',
      'height',
      'goal',
      'lastUpdate'
    ];
    for (var i = 0; i < spToRemove.length; i++) {
      sp.remove(spToRemove[i]);
    }
    sp.remove('username');
    sp.setInt('usercode', -1);

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
            return const Text('Not enough data available');
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
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: source);
    final sp = await SharedPreferences.getInstance();
    setState(() {
      sp.setString('imagepath', pickedFile!.path);
    });
    await Provider.of<DatabaseRepository>(context, listen: false)
        .updatePicture(sp.getInt('usercode')!, pickedFile!.path);
  }
} //ProfilePage
