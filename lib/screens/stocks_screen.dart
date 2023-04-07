import 'package:flutter/material.dart';
import 'package:my_wharehouse_orders/screens/order_line_scan.dart';
import 'package:provider/provider.dart';
import '/models/stocks_model.dart';
import '/providers/stocks_provider.dart';
import '/providers/general.dart';
import '/providers/productos_provider.dart';
import '/models/productos_model.dart';
import '/screens/producto_detalle_screen.dart';
import '/screens/stock_detalle_screen.dart';

class StocksScreen extends StatefulWidget {
  @override
  _StocksScreenState createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  TextEditingController _filtroController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Agrega un GlobalKey para el Form

  @override
  Widget build(BuildContext context) {
    // _filtroController.text = codiBarresSeleccionat;
    return Scaffold(
      appBar: AppBar(
        title: Text('Stocks'),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: () async {
              modoScanner = 1;
              // Navigator.pushNamed(context, '/order_line_scan');
              String resultado = await showScannerModal(context);
              _filtroController.text = resultado;
              await currentStocksDataProvider.getStocks(FiltroDeStocks(_filtroController.text));
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
              await currentStocksDataProvider.getStocks(FiltroDeStocks(_filtroController.text));
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
                  await currentStocksDataProvider.getStocks(FiltroDeStocks(_filtroController.text));
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: 'Filtrar',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton( // Agrega un botón al final del TextField
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await currentStocksDataProvider.getStocks(FiltroDeStocks(_filtroController.text));
                        setState(() {});
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<StocksDataProvider>(
              builder: (context, currentStockDataProvider, child) {
                return FutureBuilder<List<Stock>>(
                  future: currentStocksDataProvider.getStocks(FiltroDeStocks(_filtroController.text)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Stock stock = snapshot.data![index];
                            return ListTile(
                              title: Text("${stock.ubicacion} ${stock.idSerialLote}"),
                              subtitle: Text('ID: ${stock.id} Clave: ${stock.id2} Ser/Lote: ${stock.idSerialLote}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Text("[ P ]"),
                                    onPressed: () async {
                                      Producto p = await currentProductoDataProvider.getLookup(stock.id);
                                      String xx = await showProductoDetalleScreenModal(context, p);
                                      // Navigator.pushNamed(context, "/stock_detalle", arguments: stock);
                                      // Navegar a la pantalla de edición
                                    },
                                  ),
                                  IconButton(
                                    icon: Text("[ S ]"),
                                    onPressed: () async {
                                      // Eliminar stock
                                      String xx = await showStockDetalleScreenModal(context, stock);
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
