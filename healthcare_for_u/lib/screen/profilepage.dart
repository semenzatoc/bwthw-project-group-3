import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calendarpage.dart';
import 'healthpage.dart';
import 'homepage.dart';
import 'loginpage.dart';
import 'package:healthcare_for_u/utils/appcredentials.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Aggiungere popup menu button/bottom sheet per logout/edit/delete
// Riportare informazioni personali: Nome/età/peso/altezza/bmi/etc
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
    print('${ProfilePage.routename} built');
    return Scaffold(
      appBar: AppBar(
          title: Text(ProfilePage.routename),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, LoginPage.route,
                      (Route<dynamic> route) => false);
                },
                icon: Icon(Icons.logout))
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
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image( image: AssetImage('assets/trying.jpg'),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(height: 20,),
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
                              Icon(MdiIcons.account), SizedBox(width: 15,),
                              Text('${sp.getString('name')}', style: TextStyle(fontSize: 20),)
                            ],
                          );
                        } else {
                          return Text('No data available');
                        }
                      }),
                      SizedBox(height: 10,),Divider(height: 10, thickness: 1, indent: 10, endIndent: 0, color: Colors.grey,),SizedBox(height: 10,),
                      FutureBuilder(
                      future: SharedPreferences.getInstance(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final sp = snapshot.data as SharedPreferences;
                          return Row(
                            children: [
                              Icon(MdiIcons.cakeVariantOutline),SizedBox(width: 15,),
                              Text('${sp.getString('dob')}',style: TextStyle(fontSize: 20),)
                            ],
                          );
                        } else {
                          return Text('No data available');
                        }
                      }),
                      SizedBox(height: 10,),Divider(height: 10, thickness: 1, indent: 10, endIndent: 0, color: Colors.grey,),SizedBox(height: 10,),
                      FutureBuilder(
                      future: SharedPreferences.getInstance(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final sp = snapshot.data as SharedPreferences;
                          return Row(
                            children: [
                              Icon(MdiIcons.weight), SizedBox(width: 15,),
                              Text('${sp.getString('weight')} kg ',style: TextStyle(fontSize: 20),)
                            ],
                          );
                        } else {
                          return Text('No data available');
                        }
                      }),
                      SizedBox(height: 10,),Divider(height: 10, thickness: 1, indent: 10, endIndent: 0, color: Colors.grey,),SizedBox(height: 10,),
                      FutureBuilder(
                      future: SharedPreferences.getInstance(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final sp = snapshot.data as SharedPreferences;
                          return Row(
                            children: [
                              Icon(MdiIcons.humanMaleHeightVariant), SizedBox(width: 15,),
                              Text('${sp.getString('height')} cm',style: TextStyle(fontSize: 20),)
                            ],
                          );
                        } else {
                          return Text('No data available');
                        }
                      }),
                  SizedBox(height: 10,), 
                ],
              ),
            ),
            SizedBox(height: 40,),
            ElevatedButton(
              onPressed: () async {
                // Authorize the app
                String? userId = await FitbitConnector.authorize(
                    context: context,
                    clientID: AppCredentials.fitbitClientID,
                    clientSecret: AppCredentials.fitbitClientSecret,
                    redirectUri: AppCredentials.fitbitRedirectUri,
                    callbackUrlScheme: AppCredentials.fitbitCallbackScheme);

                //Instantiate a proper data manager
                FitbitActivityTimeseriesDataManager
                    fitbitActivityTimeseriesDataManager =
                    FitbitActivityTimeseriesDataManager(
                  clientID: AppCredentials.fitbitClientID,
                  clientSecret: AppCredentials.fitbitClientSecret,
                  type: 'steps',
                );
              },
              child: Text('Tap to authorize'),
            ),
          ],
        ),
      );
  }
} //ProfilePage

  