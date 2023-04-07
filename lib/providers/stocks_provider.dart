// Agregar al import existente
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '/providers/http_controller.dart' as httpmy;
import 'dart:convert';
import '/models/stocks_model.dart';
import 'general.dart';
import '/u2/u2_string_utils.dart';

// import 'stock.dart';

StocksDataProvider currentStocksDataProvider = StocksDataProvider();

String FiltroDeStocks(String filtro){
  if (filtro == "*") {
    return "true";
  }
  return  "id = ${U2StringUtils.u2SQuoteEscaped(filtro)} or " +
      "id2 = ${U2StringUtils.u2SQuoteEscaped(filtro)} or " +
      "ubicacion = ${U2StringUtils.u2SQuoteEscaped(filtro)} or " +
      "idSerialLote = ${U2StringUtils.u2SQuoteEscaped(filtro)}";
}

// Dentro de la clase StocksDataProvider
class StocksDataProvider {
  List<Stock> _stocks = [];
  List<Stock> get stocks => _stocks;

// Operaciones CRUD para stocks
  Future<int> insertStock(Stock stock) async {
    final db = await database;
    return await db
        .insert('stocks', stock.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Stock>> getStocks(String filtro) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;
    if (filtro == "") {
      _stocks = [];
      return _stocks;
      // maps = await db.query('stocks');
    } else {
      maps = await db.query(
        'stocks',
        where: filtro,
      );
    }
    _stocks = List.generate(maps.length, (i) {
      return Stock.fromMap(maps[i]);
    });
    return _stocks;
  }
  Future<Stock> getLookup(String key) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;
    maps = await db.query(
      'stocks',
      where: 'idStock = ${U2StringUtils.u2SQuoteEscaped(key)}',
    );
    return Stock.fromMap(maps[0]);
  }

  Future<int> updateStock(Stock stock) async {
    final db = await database;
    return await db.update(
      'stocks',
      stock.toMap(),
      where: 'idStock = ?',
      whereArgs: [stock.idStock],
    );
  }

  Future<int> deleteStock(String idStock) async {
    final db = await database;
    return await db.delete(
      'stocks',
      where: 'idStock = ?',
      whereArgs: [idStock],
    );
  }

  Future<int> deleteAllStocks() async {
    final db = await database;
    return await db.delete('stocks');
  }

  Future<void> deleteStockTable() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS stocks');
  }

  Future<void> fetchAndStoreStocks([Map<String,dynamic>? parametrosGet]) async {
    Uri? url = httpmy.getMiUrl('/api/stocks',parametrosGet);
    if (url == null) {
      throw Exception('Falta configurar la URL');
    }
    try {
      final response = await httpmy.getHttpWithAuth(url!);
      if (response.statusCode == 200) {
        List<dynamic> stocksJson = json.decode(response.body);
        print("total stocks: ${stocksJson.length}");
        // deleteAllStocks();
        // var l = await getStocks("true");    print("antes de cargar: ${l.length}");
        for (var stockJson in stocksJson) {
          Stock producto = Stock.fromMap(stockJson);
          try {
            int cnt;
            cnt = await updateStock(producto);
            if (cnt == 0) {
              int cnt = await insertStock(producto);
              //print("insert ${producto.id}, $cnt");
            } else {
              //print("update ${producto.id}, $cnt");
            }
          } catch (e) {
            throw Exception('Error al guardar Stocks en local ${e.toString()}');
          }
        }
        // var l2 = await getStocks("true"); print("despues de update: ${l2.length}");
      } else {
        throw Exception('Error al obtener productos del servidor');
      }
    } catch (error) {
      throw error;
    }
  }

  // Método para crear la tabla de stocks
  Future<void> createStockTable(Database db) async {
    // final db = await database;
    await db.execute('''
    CREATE TABLE IF NOT EXISTS stocks (
      idStock TEXT PRIMARY KEY,
      id TEXT,
      id2 TEXT,
      ubicacion TEXT,
      cantidad REAL,
      unidadMedida TEXT,
      unidadesEmbalaje REAL,
      tipoEmbalaje TEXT,
      idSerialLote TEXT,
      tdhrCaduca TEXT,
      tdhr TEXT
    );
  ''');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_stocks_id ON stocks(id);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_stocks_id2 ON stocks(id2);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_stocks_ubicacion ON stocks(ubicacion);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_stocks_idSerialLote ON stocks(idSerialLote);');
  }
}

