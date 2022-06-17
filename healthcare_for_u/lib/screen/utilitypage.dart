import 'package:fitbitter/fitbitter.dart';
import 'package:flutter/material.dart';
import 'package:healthcare_for_u/repository/databaseRepository.dart';
import 'package:healthcare_for_u/screen/homepage.dart';
import 'package:healthcare_for_u/utils/appcredentials.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UtilPage extends StatelessWidget {
  UtilPage({Key? key}) : super(key: key);

  static const route = '/';
  static const routename = 'Utility Page';

  @override
  Widget build(BuildContext context) {
    print('${UtilPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: const Text(UtilPage.routename),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, HomePage.route, (route) => false);
              },
              icon: const Icon(MdiIcons.home))
        ],
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // Authorize the app
                  String? userId = await FitbitConnector.authorize(
                      context: context,
                      clientID: AppCredentials.fitbitClientID,
                      clientSecret: AppCredentials.fitbitClientSecret,
                      redirectUri: AppCredentials.fitbitRedirectUri,
                      callbackUrlScheme: AppCredentials.fitbitCallbackScheme);
                  final sp = await SharedPreferences.getInstance();
                  sp.setString('userId', userId!);
                  print('User authorized');
                },
                child: const Text('Authorize'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    // Authorize the app
                    await Provider.of<DatabaseRepository>(context,
                            listen: false)
                        .clearActivityTable();
                    print('Cleared Activity table');
                  },
                  child: const Text('Clear entire activity DB')),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    final sp = await SharedPreferences.getInstance();
                    DateTime day = DateTime(2022, 01, 01);
                    sp.setString('lastUpdate',
                        DateFormat("yyyy-MM-dd HH:mm:ss").format(day));
                    print('Last Update reset to January 1st');
                  },
                  child: const Text('Reset lastUpdate to JAN 1st')),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    final sp = await SharedPreferences.getInstance();
                    DateTime day = DateTime(2022, 06, 01);
                    sp.setString('lastUpdate',
                        DateFormat("yyyy-MM-dd HH:mm:ss").format(day));
                    print('Last Update reset to June 1st');
                  },
                  child: const Text('Reset lastUpdate to JUN 1st'))
            ]),
      ),
    );
  } //build

} //UtilPage