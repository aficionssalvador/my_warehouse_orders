import 'package:sqflite/sqflite.dart';
import 'general.dart';
import '/models/ordenes_detalle_model.dart';
import 'dart:async';

OrdenesDetalleDataProvider currentOrdenesDetalleDataProvider = OrdenesDetalleDataProvider();

// Dentro de la clase OrdenesDataProvider
class OrdenesDetalleDataProvider {

// Método para crear la tabla de ordenes_detalle
  Future<void> createOrdenDetalleTable() async {
    final db = await database;
    await db.execute('''
    CREATE TABLE IF NOT EXISTS ordenes_detalle (
      id_orden TEXT,
      id_linea_orden INTEGER,
      id TEXT,
      id2 TEXT,
      ubicacion TEXT,
      cantidad REAL,
      unidad_medida TEXT,
      embalaje INTEGER,
      tipo_embalaje TEXT,
      id_serial_lote TEXT,
      tdhr_caduca TEXT,
      tdhr TEXT,
      PRIMARY KEY (id_orden, id_linea_orden)
    );
  ''');
  }

// Operaciones CRUD para ordenes_detalle
  Future<void> insertOrdenDetalle(OrdenDetalleModel ordenDetalle) async {
    final db = await database;
    await db.insert('ordenes_detalle', ordenDetalle.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<OrdenDetalleModel>> getOrdenesDetalle() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ordenes_detalle');

    return List.generate(maps.length, (i) {
      return OrdenDetalleModel.fromMap(maps[i]);
    });
  }

  Future<void> updateOrdenDetalle(OrdenDetalleModel ordenDetalle) async {
    final db = await database;
    await db.update(
      'ordenes_detalle',
      ordenDetalle.toMap(),
      where: 'id_orden = ? AND id_linea_orden = ?',
      whereArgs: [ordenDetalle.idOrden, ordenDetalle.idLineaOrden],
    );
  }

  Future<void> deleteOrdenDetalle(String idOrden, int idLineaOrden) async {
    final db = await database;
    await db.delete(
      'ordenes_detalle',
      where: 'id_orden = ? AND id_linea_orden = ?',
      whereArgs: [idOrden, idLineaOrden],
    );
  }

  Future<void> deleteAllOrdenesDetalle() async {
    final db = await database;
    await db.delete('ordenes_detalle');
  }

  Future<void> deleteOrdenDetalleTable() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS ordenes_detalle');
  }

}