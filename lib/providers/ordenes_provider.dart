import 'package:sqflite/sqflite.dart';
import 'general.dart';
import '/models/ordenes_model.dart';
import 'dart:async';

OrdenesDataProvider currentOrdenesDataProvider = OrdenesDataProvider();

// Dentro de la clase OrdenesDataProvider
class OrdenesDataProvider {

  // Agregar al import existente
// import 'orden.dart';

// Dentro de la clase ProductoDataProvider

// Método para crear la tabla de ordenes
  Future<void> createOrdenTable(Database db) async {
    //final db = await database;
    await db.execute('''
    CREATE TABLE IF NOT EXISTS ordenes (
      id_orden TEXT PRIMARY KEY,
      tipo_movimiento TEXT,
      origen TEXT,
      destino TEXT,
      tdhr_inicio TEXT,
      tdhr_final TEXT,
      tdhr TEXT
    );
  ''');
  }

// Operaciones CRUD para ordenes
  Future<void> insertOrden(Orden orden) async {
    final db = await database;
    await db.insert('ordenes', orden.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Orden>> getOrdenes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ordenes');

    return List.generate(maps.length, (i) {
      return Orden.fromMap(maps[i]);
    });
  }

  Future<void> updateOrden(Orden orden) async {
    final db = await database;
    await db.update(
      'ordenes',
      orden.toMap(),
      where: 'id_orden = ?',
      whereArgs: [orden.idOrden],
    );
  }

  Future<void> deleteOrden(String idOrden) async {
    final db = await database;
    await db.delete(
      'ordenes',
      where: 'id_orden = ?',
      whereArgs: [idOrden],
    );
  }

  Future<void> deleteAllOrdenes() async {
    final db = await database;
    await db.delete('ordenes');
  }

  Future<void> deleteOrdenTable() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS ordenes');
  }
}