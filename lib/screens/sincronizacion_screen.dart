import 'package:flutter/material.dart';
import '/providers/productos_provider.dart';
import '/providers/stocks_provider.dart';
import '/providers/inventarios_provider.dart';
import '/providers/ordenes_provider.dart';
import '/providers/ordenes_detalle_provider.dart';

class SincronizacionScreen extends StatefulWidget {
  @override
  _SincronizacionScreenState createState() => _SincronizacionScreenState();
}

class _SincronizacionScreenState extends State<SincronizacionScreen> {
  List<String> tablas = ['productos', 'stock', 'inventario', 'ordenes', 'ordenes_detalle'];
  List<String> tablas2 = ['inventario', 'ordenes', 'ordenes_detalle'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sincronización'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tablas.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(tablas[index]),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Llama aquí a la función para sincronizar los datos de cada tabla
                        print('Recuperar ${tablas[index]}');
                        Recuperar(tablas[index]);
                      },
                      child: Text('Recuperar'),
                    ),
                  ),
                );
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tablas2.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(tablas2[index]),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Llama aquí a la función para sincronizar los datos de cada tabla
                        print('Enviar ${tablas2[index]}');
                      },
                      child: Text('Enviar'),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> Recuperar(String nombreTabla) async {
    if (nombreTabla == tablas[0]) {
      currentProductoDataProvider.fetchAndStoreProductos();
    } else if (nombreTabla == tablas[1]) {
      currentStocksDataProvider.fetchAndStoreStocks();
    } else ;

  }
}
