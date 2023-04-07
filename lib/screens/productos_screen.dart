import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:my_wharehouse_orders/providers/stocks_provider.dart';
import 'package:my_wharehouse_orders/screens/order_line_scan.dart';
import 'package:my_wharehouse_orders/u2/u2_string_utils.dart';
import 'package:provider/provider.dart';
import '/models/productos_model.dart';
import '/providers/productos_provider.dart';
import '/providers/general.dart';
import '/screens/producto_detalle_screen.dart';
import '/screens/stock_lista_screen.dart';
import '/models/stocks_model.dart';

class ProductosScreen extends StatefulWidget {
  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  TextEditingController _filtroController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Agrega un GlobalKey para el Form

  @override
  Widget build(BuildContext context) {
    // _filtroController.text = codiBarresSeleccionat;
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: () async {
              modoScanner = 1;
              // Navigator.pushNamed(context, '/order_line_scan');
              String resultado = await showScannerModal(context);
              _filtroController.text = resultado;
              await currentProductoDataProvider.getProductos(FiltroDeProductos(_filtroController.text));
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () async {
              modoScanner = 0;
              // Navigator.pushNamed(context, '/order_line_scan');
              String resultado = await showScannerModal(context);
              _filtroController.text = resultado;
              await currentProductoDataProvider.getProductos(FiltroDeProductos(_filtroController.text));
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form( // Envuelve el TextField en un Form
              key: _formKey,
              child: TextFormField(
                controller: _filtroController,
                onFieldSubmitted: (value) async { // Cambia onChanged a onFieldSubmitted
                  await currentProductoDataProvider.getProductos(FiltroDeProductos(_filtroController.text));
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: 'Filtrar',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton( // Agrega un botón al final del TextField
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await currentProductoDataProvider.getProductos(FiltroDeProductos(_filtroController.text));
                        setState(() {});
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ProductoDataProvider>(
              builder: (context, currentProductoDataProvider, child) {
                return FutureBuilder<List<Producto>>(
                  future: currentProductoDataProvider.getProductos(FiltroDeProductos(_filtroController.text)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Producto producto = snapshot.data![index];
                            return ListTile(
                              title: Text(producto.descripcion),
                              subtitle: Text('ID: ${producto.id} Clave: ${producto.id2}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Text("[ P ]"),
                                    onPressed: () async {
                                      String resultado = await showProductoDetalleScreenModal(context, producto);
                                      //Navigator.pushNamed(context, "/producto_detalle", arguments: producto);
                                      // Navegar a la pantalla de edición
                                    },
                                  ),
                                  IconButton(
                                    icon: Text("[ S ]"),
                                    onPressed: () async {
                                      // Eliminar producto
                                      List<Stock> stocks = await currentStocksDataProvider.getStocks("id = ${U2StringUtils.u2SQuoteEscaped(producto.id)}");
                                      String resultado = await showStockListaScreenModal(context, stocks);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
