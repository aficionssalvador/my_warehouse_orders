// Agregar al import existente
import 'package:sqflite/sqflite.dart';
import 'general.dart';
import '/models/stocks_model.dart';
import 'dart:async';

// import 'stock.dart';

StocksDataProvider currentStocksDataProvider = StocksDataProvider();

// Dentro de la clase StocksDataProvider
class StocksDataProvider {
// Método para crear la tabla de stocks
  Future<void> createStockTable(Database db) async {
    // final db = await database;
    await db.execute('''
    CREATE TABLE IF NOT EXISTS stocks (
      id TEXT,
      id2 TEXT,
      ubicacion TEXT,
      cantidad REAL,
      unidad_medida TEXT,
      embalaje INTEGER,
      tipo_embalaje TEXT,
      id_serial_lote TEXT,
      tdhr_caduca TEXT,
      tdhr TEXT
    );
  ''');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_stocks_id ON stocks(id);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_stocks_id2 ON stocks(id2);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_stocks_ubicacion ON stocks(ubicacion);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_stocks_id_serial_lote ON stocks(id_serial_lote);');
  }

// Operaciones CRUD para stocks
  Future<void> insertStock(Stock stock) async {
    final db = await database;
    await db
        .insert('stocks', stock.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Stock>> getStocks(String filtro) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;
    if (filtro == "") {
       maps = await db.query('stocks');
    } else {
      maps = await db.query(
        'stocks',
        where: filtro,
      );
    }
    return List.generate(maps.length, (i) {
      return Stock.fromMap(maps[i]);
    });
  }

  Future<void> updateStock(Stock stock) async {
    final db = await database;
    await db.update(
      'stocks',
      stock.toMap(),
      where: 'id = ? AND id2 = ? AND ubicacion = ? AND id_serial_lote = ?',
      whereArgs: [stock.id, stock.id2, stock.ubicacion, stock.idSerialLote],
    );
  }

  Future<void> deleteStock(String id, String id2, String ubicacion, String idSerialLote) async {
    final db = await database;
    await db.delete(
      'stocks',
      where: 'id = ? AND id2 = ? AND ubicacion = ? AND id_serial_lote = ?',
      whereArgs: [id, id2, ubicacion, idSerialLote],
    );
  }

  Future<void> deleteAllStocks() async {
    final db = await database;
    await db.delete('stocks');
  }

  Future<void> deleteStockTable() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS stocks');
  }

}

