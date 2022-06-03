import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'calendarpage.dart';
import 'healthpage.dart';
import 'homepage.dart';
import 'loginpage.dart';
import 'package:healthcare_for_u/utils/appcredentials.dart';
import 'package:healthcare_for_u/utils/BMI.dart';

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
        children: [
          Container(
            color: Color.fromARGB(255, 130, 207, 243),
            height: 200,
            width: 450,
            child:
            Row( 
              children:[  
                SizedBox(width: 40),
                Text('Hello Bob!', style: TextStyle(fontSize: 30, ),),
                SizedBox(width: 80,),        
         ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: const Image(
                image: AssetImage('assets/trying.jpg'),
                width: 100,
                height: 100,
                fit: BoxFit.none,
          ),),],)),
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
                            SizedBox(width: 15,),
                            Icon(MdiIcons.account, size: 30,),
                           SizedBox(width: 50,),
                           TextButton(child: const Text('Profile', style: TextStyle(fontSize: 20, color: Colors.black),), onPressed: () {
                             showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 80),
                                          child:AlertDialog( 
                                            title: const Text('Profile'),
                                           content: SingleChildScrollView(
                                                   child: ListBody(
                                                  children:  <Widget>[
                                                    Row( children: [
                                                      Icon(MdiIcons.account),
                                                      Text('Name: ${sp.getString('name')}'),]),
                                                      SizedBox(height: 15,),
                                                    Row(children: [
                                                      Icon(MdiIcons.cakeVariantOutline),
                                                      Text('Date of Birth: ${sp.getString('dob')}'),
                                                    ],)
                                                  ],
                                                  ),
                                                 ),
                                           actions: <Widget>[
                                            TextButton(
                                            onPressed: () => Navigator.pop(context, 'Cancel'),
                                           child: const Text('Cancel'),
                                           ),]
                                            
                                            )),);
                      },),
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
                            SizedBox(width: 15,),
                            Icon(MdiIcons.heart, size: 30,),
                           SizedBox(width: 50,),
                           TextButton(child: const Text('Health Status', style: TextStyle(fontSize: 20, color: Colors.black),), onPressed: () {
                             showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 80),
                                          child:AlertDialog( 
                                            title: const Text('Health Status'),
                                           content: SingleChildScrollView(
                                                   child: ListBody(
                                                  children:  <Widget>[
                                                    Row( children: [
                                                      Icon(MdiIcons.weight),
                                                      Text('Weight: ${sp.getString('weight')} kg'),]),
                                                      SizedBox(height: 15,),
                                                    Row(children: [
                                                      Icon(MdiIcons.humanMaleHeightVariant),
                                                      Text('Height: ${sp.getString('height')} cm'),
                                                    ],),
                                                    SizedBox(height: 15,),
                                                    Row(children: [
                                                      Icon(MdiIcons.heart),
                                                      Text('BMI $bmi'),
                                                    ],)
                                                  ],
                                                  ),
                                                 ),
                                           actions: <Widget>[
                                            TextButton(
                                            onPressed: () => Navigator.pop(context, 'Cancel'),
                                           child: const Text('Cancel'),
                                           ),]
                                            
                                            )),);
                      },),
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

    Navigator.pushNamedAndRemoveUntil(
        context, LoginPage.route, (Route<dynamic> route) => false);
  }
} //ProfilePage
