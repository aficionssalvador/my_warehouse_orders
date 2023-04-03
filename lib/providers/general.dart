import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart' as p;
import 'productos_provider.dart';
import 'stocks_provider.dart';
import 'inventarios_provider.dart';
import 'ordenes_provider.dart';
import 'ordenes_detalle_provider.dart';


/// variables estaticas globales
int modoScanner = 0;
String codiBarresSeleccionat = '';
TractametCodiBarresSeleccionat tractametCodiBarresSeleccionat = TractametCodiBarresSeleccionat.llegirProducte;
Database? _database;

/// coleccions de operacions
enum TractametCodiBarresSeleccionat {
  cap,
  llegirProducte,
  llegirDocument,

}

enum AccioBarresSeleccionat {
  cap,
  llegitCodi,
  intentLectura,

}

// Agregar al método get database existente
Future<Database> get database async {
  if (_database != null) return _database!;
  final dbPath = await getDatabasesPath();
  _database = await openDatabase(
    p.join(dbPath, 'my_warehouse_order.db'),
    onCreate: (db, version) async {
      await currentProductoDataProvider.createTable();
      await currentStocksDataProvider.createStockTable();
      await currentInvetariosDataProvider.createInvetarioTable();
      await currentOrdenesDataProvider.createOrdenTable();
      await currentOrdenesDetalleDataProvider.createOrdenDetalleTable();
    },
    version: 1,
  );
  return _database!;
}

// Método para cerrar la base de datos
Future<void> closeDatabase() async {
  if (_database != null) {
    await _database!.close();
    _database = null;
  }
}

String codiBarresLLegit(AccioBarresSeleccionat accioBarresSeleccionat, String codi) {
  String s = codi;
  switch (tractametCodiBarresSeleccionat) {
    case TractametCodiBarresSeleccionat.cap:
      break;
    case TractametCodiBarresSeleccionat.llegirProducte:
      switch (accioBarresSeleccionat){
        case AccioBarresSeleccionat.cap:
          break;
        case AccioBarresSeleccionat.llegitCodi:
          // todo: llegir el codi a la taula de productes
          s = 'Codi trobat: $codi';
          codiBarresSeleccionat = codi;
          break;
        default:
          break;
      }
      break;
    case TractametCodiBarresSeleccionat.llegirDocument:

      // todo: llegir el codi a la taula de documents

      break;
    default:
      break;
  }

  return s;
}