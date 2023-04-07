import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:my_wharehouse_orders/models/productos_model.dart';

import '/u2/u2_string_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'productos_provider.dart';
import 'stocks_provider.dart';
import 'inventarios_provider.dart';
import 'ordenes_provider.dart';
import 'ordenes_detalle_provider.dart';
import '/models/configuracion_model.dart';
import '/models/stocks_model.dart';
import 'stocks_provider.dart';

/// variables estaticas globales
int modoScanner = 0;
String codiBarresSeleccionat = '';

String codiBarresProducte = '';
String codiBarresSerialLot = '';
String codiBarresDataCaducitat = '';
String codiBarresFabricant = '';

TractametCodiBarresSeleccionat tractametCodiBarresSeleccionat = TractametCodiBarresSeleccionat.llegirProducte;

// Agregue esta variable al principio de general.dart
bool _isOpeningDatabase = false;
Database? _database;

String fileNameStat = 'my_warehouse_orders_state_recepcion.json';
String configFileName = 'my_warehouse_orders_config.json';
Map<dynamic, dynamic> currentFileStat = {};
Configuracion? currentConfiguracion;

/// coleccions de operacions
enum TractametCodiBarresSeleccionat {
  cap,
  llegirProducte,
  llegirStrock,
  llegirDocument,

}

enum AccioBarresSeleccionat {
  cap,
  llegitCodi,
  intentLectura,

}

// Agregar al método get database existente
Future<Database> get database async {
  // print("get database 1");
  if (_database != null) return _database!;
  // print("get database 2");
  // Agregue esta condición para evitar abrir la base de datos varias veces
  if (_isOpeningDatabase) {
    throw Exception('La base de datos ya se está abriendo.');
  }

  final dbPath = await getDatabasesPath();
  // print("get database 4");
  _isOpeningDatabase = true;
  _database = await openDatabase(
    p.join(dbPath, 'my_warehouse_order.db'),
    onCreate: (db, version) async {
      // print("get database creando 1");
      await currentProductoDataProvider.createTable(db);
      // print("get database creando 2");
      await currentStocksDataProvider.createStockTable(db);
      // print("get database creando 3");
      await currentInvetariosDataProvider.createInvetarioTable(db);
      // print("get database creando 4");
      await currentOrdenesDataProvider.createOrdenTable(db);
      // print("get database creando 5");
      await currentOrdenesDetalleDataProvider.createOrdenDetalleTable(db);
      // print("get database todo");
    },
    version: 1,
  );
  _isOpeningDatabase = false;

  return _database!;
}

// Método para cerrar la base de datos
Future<void> closeDatabase() async {
  if (_database != null) {
    await _database!.close();
    _database = null;
  }
}

Future<String> codiBarresLLegit(AccioBarresSeleccionat accioBarresSeleccionat, String codi) async {
  String s = codi;
  switch (tractametCodiBarresSeleccionat) {
    case TractametCodiBarresSeleccionat.cap:
      break;
    case TractametCodiBarresSeleccionat.llegirStrock:
      switch (accioBarresSeleccionat){
        case AccioBarresSeleccionat.cap:
          break;
        case AccioBarresSeleccionat.llegitCodi:
          // codi llegit
          // llegir el codi a la taula de stocks
          String filtre = FiltroDeStocks(codi);
          final List<Stock> lstStk = await currentStocksDataProvider.getStocks(filtre);
          final int count = await (lstStk).length;
          if (count == 1) {
            s = await lstStk[0].id; codiBarresSeleccionat = s;
          }
          break;
        case AccioBarresSeleccionat.intentLectura:
          // codi escanejat
          String filtre = FiltroDeStocks(codi);
          final List<Stock> lstStk = await currentStocksDataProvider.getStocks(filtre);
          final int count = await (lstStk).length;
          if (count > 1) {
            s = 'Encontrados ${lstStk.length} estocs con el codigo: $codi';
          } else if (count == 1) {
            s = "Encontrado: ${lstStk[0].id}, ubicado:  ${lstStk[0].ubicacion}, Ser/Lote: ${lstStk[0].idSerialLote}";
          }
          break;
        default:
          break;
      }
      break;
    case TractametCodiBarresSeleccionat.llegirProducte:
      switch (accioBarresSeleccionat){
        case AccioBarresSeleccionat.cap:
          break;
        case AccioBarresSeleccionat.llegitCodi:
        // codi llegit
        // llegir el codi a la taula de productes
          String filtre = FiltroDeProductos(codi);
          final List<Producto> lstProd = await currentProductoDataProvider.getProductos(filtre);
          final int count = await (lstProd).length;
          if (count == 1) {
            s = await lstProd[0].id; codiBarresSeleccionat = s;
          }
          break;
        case AccioBarresSeleccionat.intentLectura:
        // codi escanejat
          String filtre = FiltroDeProductos(codi);
          final List<Producto> lstProd = await currentProductoDataProvider.getProductos(filtre);
          final int count = await (lstProd).length;
          if (count > 1) {
            s = 'Encontrados ${lstProd.length} productos con el codigo: $codi';
          } else if (count == 1) {
            s = "Encontrado: ${lstProd[0].id} - ${lstProd[0].descripcion}";
          }
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
  final filePath = '${directory.path}/$localFile';
  final file = File(filePath);
  final jsonData = json.encode(data);
  await file.writeAsString(jsonData);
  return data;
}

Future<Map<dynamic, dynamic>> readFromLocal(String localFile) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$localFile';
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
  currentConfiguracion = await Configuracion.fromMap(await readFromLocal(configFileName));
}

