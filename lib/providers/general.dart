import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:my_wharehouse_orders/u2/u2_string_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'productos_provider.dart';
import 'stocks_provider.dart';
import 'inventarios_provider.dart';
import 'ordenes_provider.dart';
import 'ordenes_detalle_provider.dart';
import 'package:my_wharehouse_orders/models/configuracion_model.dart';

/// variables estaticas globales
int modoScanner = 0;
String codiBarresSeleccionat = '';
TractametCodiBarresSeleccionat tractametCodiBarresSeleccionat = TractametCodiBarresSeleccionat.llegirProducte;

Database? _database;
String fileNameStat = 'my_warehouse_orders_state_recepcion.json';
String configFileName = 'my_warehouse_orders_config.json';
Map<dynamic, dynamic> currentFileStat = {};
Configuracion? currentConfiguracion;

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

Future<Map<dynamic, dynamic>> saveDataStatToLocal(String localFile, String tableName, Map<String, dynamic> data) async {
  DateTime dt = DateTime.now();
  data[tableName] = U2StringUtils.DateTime2u2TADA(dt)+U2StringUtils.DateTime2u2HHMMSS(dt);
  return saveToLocalFile(localFile,  data);
}

Future<Map<dynamic, dynamic>> saveToLocalFile(String localFile,  Map<String, dynamic> data) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/$fileNameStat';
  final file = File(filePath);
  final jsonData = json.encode(data);
  await file.writeAsString(jsonData);
  return data;
}

Future<Map<dynamic, dynamic>> readFromLocal(String localFile) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileNameStat';
    final file = File(filePath);
    if (await file.exists()) {
      final jsonData = await file.readAsString();
      final data = json.decode(jsonData) as Map<dynamic, dynamic>;
      return data;
    } else {
      return {} as Map<dynamic, dynamic>;
    }
  } catch (e) {
    return {} as Map<dynamic, dynamic>;
  }
}

Future<void> initializeGlobalData() async {
  currentFileStat = await readFromLocal(fileNameStat);
  currentConfiguracion = Configuracion.fromMap(await readFromLocal(configFileName));
}

