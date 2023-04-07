import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/stocks_model.dart';
import '/providers/stocks_provider.dart';
import '/screens/stock_detalle_screen.dart';

Future<String> showStockListaScreenModal(BuildContext context, List<Stock> stocks) async {
  final result = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: StockListaScreen(stocks: stocks),
        ),
      );
    },
  );
  return result ?? '';
}

class StockListaScreen extends StatelessWidget {
  final List<Stock> stocks;

  StockListaScreen({required this.stocks}){}

  @override
  Widget build(BuildContext context) {
    // _filtroController.text = codiBarresSeleccionat;
    return Scaffold(
      appBar: AppBar(
        title: Text('Stocks'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: stocks!.length,
              itemBuilder: (context, index) {
                Stock stock = stocks![index];
                return ListTile(
                  title: Text("${stock.ubicacion}"),
                  subtitle: Text('ID: ${stock.id} Clave: ${stock.id2} Ser/Lote: ${stock.idSerialLote}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /*
                        IconButton(
                          icon: Text("[ P ]"),
                          onPressed: () async {
                            Producto p = await currentProductoDataProvider.getLookup(stock.id);
                            String xx = await showProductoDetalleScreenModal(context, p);
                          },
                        ),
                        */
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
            ),
          ),
        ],
      ),
    );
  }
}
