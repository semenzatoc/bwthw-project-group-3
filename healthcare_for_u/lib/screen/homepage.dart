import 'package:flutter/material.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Card per ogni attività. Le attività si aggiorneranno a seconda dei dati
// Ogni Card porta alla pagina di dettaglio dell'attività scelta.
// Link a profile page
// pulasnte di logout? Oppure su profile page?
class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  static const route = '/';
  static const routename = 'Home Page';

  @override
  Widget build(BuildContext context) {
    print('${HomePage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text(HomePage.routename),
      ),
      body: Center(
        child: Text('Hello, world!'),
      ),
    );
  } //build

} //HomePage