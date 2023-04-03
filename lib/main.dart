import 'package:flutter/material.dart';
import 'package:my_chat_friend/screens/home_screen.dart';
import 'package:my_chat_friend/screens/order_line_scan.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      initialRoute: '/',
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
