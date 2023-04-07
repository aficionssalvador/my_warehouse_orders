import 'package:flutter/material.dart';
import 'package:my_wharehouse_orders/providers/stocks_provider.dart';
import 'package:provider/provider.dart';
import '/providers/productos_provider.dart';
import '/models/productos_model.dart';
import '/providers/general.dart';
import '/screens/home_screen.dart';
import '/screens/order_line_scan.dart';
import '/screens/productos_screen.dart';
import '/screens/sincronizacion_screen.dart';
import '/screens/producto_detalle_screen.dart';
import '/screens/configuracion_screen.dart';
import '/screens/stocks_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegúrate de inicializar los bindings aquí.

  await initializeGlobalData();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ProductoDataProvider>(
          create: (context) => ProductoDataProvider(),
          // Elimina la siguiente línea ya que la clase ProductoDataProvider no tiene un método dispose()
          // dispose: (_, productoDataProvider) => productoDataProvider.dispose(),
        ),
        Provider<StocksDataProvider>(
          create: (context) => StocksDataProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Mi Aplicación',
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => MyHomePage(),
          '/order_line_scan': (context) => ScannerScreen(),
          '/productos': (context) => ProductosScreen(),
          '/sincronizacion': (context) => SincronizacionScreen(),
          '/producto_detalle': (context) => ProductoDetalleScreen(producto: ModalRoute.of(context)!.settings.arguments as Producto), // Añade esta líne
          '/configuracion': (context) => ConfiguracionScreen(),
          '/stocks': (context) => StocksScreen(),
        },
      )
    );
  }
}
