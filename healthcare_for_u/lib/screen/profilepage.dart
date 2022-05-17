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
      body: Center(
        child: Column(
          children: [
            FutureBuilder(
              future:  SharedPreferences.getInstance(),
              builder: (context, snapshot) {
             
              if(snapshot.hasData){
                final sp = snapshot.data as SharedPreferences;
                return Text('Hello ${sp.getString('name')}');
              } else {
                return Text('You have failed');
              } 
              
            }),
            
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

                //Fetch data
                final stepsData = await fitbitActivityTimeseriesDataManager
                    .fetch(FitbitActivityTimeseriesAPIURL.dayWithResource(
                  date: DateTime.now().subtract(Duration(days: 1)),
                  userID: userId,
                  resource: fitbitActivityTimeseriesDataManager.type,
                )) as List<FitbitActivityTimeseriesData>;

                // Use them as you want
                final snackBar = SnackBar(
                    content:
                        Text('Yesterday you walked ${stepsData[0].value} steps!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text('Tap to authorize'),
            ),
          ],
        ),
      ),
    );
  }  } //ProfilePage

  