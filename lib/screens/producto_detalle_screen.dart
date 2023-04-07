import 'package:flutter/material.dart';
import '/providers/productos_provider.dart'; // Reemplaza esto con la ruta correcta al archivo productos_model.dart
import '/models/productos_model.dart';


Future<String> showProductoDetalleScreenModal(BuildContext context, Producto producto) async {
  final result = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ProductoDetalleScreen(producto: producto),
        ),
      );
    },
  );
  return result ?? '';
}

class ProductoDetalleScreen extends StatelessWidget {
  final Producto producto;

  ProductoDetalleScreen({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Producto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${producto.id}', style: TextStyle(fontSize: 18)),
            Text('ID2: ${producto.id2}', style: TextStyle(fontSize: 18)),
            Text('Descripción: ${producto.descripcion}', style: TextStyle(fontSize: 18)),
            Text('GRP1: ${producto.grp1}', style: TextStyle(fontSize: 18)),
            Text('GRP2: ${producto.grp2}', style: TextStyle(fontSize: 18)),
            Text('GRP3: ${producto.grp3}', style: TextStyle(fontSize: 18)),
            Text('GRP4: ${producto.grp4}', style: TextStyle(fontSize: 18)),
            Text('TDHR: ${producto.tdhr}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
