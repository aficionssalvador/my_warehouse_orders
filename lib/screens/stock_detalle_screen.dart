import 'package:flutter/material.dart';
import '/providers/stocks_provider.dart';
import '/models/stocks_model.dart';


Future<String> showStockDetalleScreenModal(BuildContext context, Stock stock) async {
  final result = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: StockDetalleScreen(stock: stock),
        ),
      );
    },
  );
  return result ?? '';
}

class StockDetalleScreen extends StatelessWidget {
  final Stock stock;

  StockDetalleScreen({required this.stock});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stock"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${stock.id}', style: TextStyle(fontSize: 18)),
            Text('ID2: ${stock.id2}', style: TextStyle(fontSize: 18)),
            Text('idSerialLote: ${stock.idSerialLote}', style: TextStyle(fontSize: 18)),
            Text('ubicacion: ${stock.ubicacion}', style: TextStyle(fontSize: 18)),
            Text('cantidad: ${stock.cantidad}', style: TextStyle(fontSize: 18)),
            Text('unidadMedida: ${stock.unidadMedida}', style: TextStyle(fontSize: 18)),
            Text('unidadesEmbalaje: ${stock.unidadesEmbalaje}', style: TextStyle(fontSize: 18)),
            Text('tipoEmbalaje: ${stock.tipoEmbalaje}', style: TextStyle(fontSize: 18)),
            Text('TDHR Caduca: ${stock.tdhrCaduca}', style: TextStyle(fontSize: 18)),
            Text('TDHR: ${stock.tdhr}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
