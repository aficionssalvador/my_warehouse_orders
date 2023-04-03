import 'package:flutter/material.dart';
import '/screens/home_screen.dart';
import '/screens/order_line_scan.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => MyHomePage(),
        '/order_line_scan': (context) => ScannerScreen(),
        //'/pantalla2': (context) => Pantalla2Screen(),
        //'/pantalla3': (context) => Pantalla3Screen(),
        //'/pantalla4': (context) => Pantalla4Screen(),
      },
    );
  }
}
