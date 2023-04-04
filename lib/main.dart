import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/screens/home_screen.dart';
import '/screens/order_line_scan.dart';
import '/screens/productos_screen.dart';
import '/providers/productos_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ProductoDataProvider>(
          create: (_) => ProductoDataProvider(),
          // Elimina la siguiente línea ya que la clase ProductoDataProvider no tiene un método dispose()
          // dispose: (_, productoDataProvider) => productoDataProvider.dispose(),
        ),
      ],
      child: MaterialApp(
        title: 'Mi Aplicación',
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => MyHomePage(),
          '/order_line_scan': (context) => ScannerScreen(),
          '/productos': (context) => ProductosScreen(),
          //'/pantalla3': (context) => Pantalla3Screen(),
          //'/pantalla4': (context) => Pantalla4Screen(),
        },
      )
    );
  }
}
