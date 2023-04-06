// Agregar al import existente
import 'package:sqflite/sqflite.dart';
import 'general.dart';
import '/models/inventarios_model.dart';
import 'dart:async';

InvetariosDataProvider currentInvetariosDataProvider = InvetariosDataProvider();

// Dentro de la clase InvetariosDataProvider
class InvetariosDataProvider {
// Método para crear la tabla de Invetarios
  Future<void> createInvetarioTable(Database db) async {
    //final db = await database;
    await db.execute('''
    CREATE TABLE IF NOT EXISTS inventarios (
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
    await db.execute('CREATE INDEX IF NOT EXISTS idx_inventarios_id ON inventarios(id);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_inventarios_id2 ON inventarios(id2);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_inventarios_ubicacion ON inventarios(ubicacion);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_inventarios_id_serial_lote ON inventarios(id_serial_lote);');
  }

// Operaciones CRUD para Inventarios
  Future<void> insertInventario(Inventario inventario) async {
    final db = await database;
    await db
        .insert('inventarios', inventario.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Inventario>> getInventarios(String filtro) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;
    if (filtro == "") {
      maps = await db.query('inventarios');
    } else {
      maps = await db.query(
        'stocks',
        where: filtro,
      );
    }

    return List.generate(maps.length, (i) {
      return Inventario.fromMap(maps[i]);
    });
  }

  Future<void> updateInventario(Inventario inventario) async {
    final db = await database;
    await db.update(
      'inventarios',
      inventario.toMap(),
      where: 'id = ? AND id2 = ? AND ubicacion = ? AND id_serial_lote = ?',
      whereArgs: [inventario.id, inventario.id2, inventario.ubicacion, inventario.idSerialLote],
    );
  }

  Future<void> deleteInventario(String id, String id2, String ubicacion, String idSerialLote) async {
    final db = await database;
    await db.delete(
      'inventarios',
      where: 'id = ? id2 = ? AND AND ubicacion = ? AND id_serial_lote = ?',
      whereArgs: [id, id2, ubicacion, idSerialLote],
    );
  }

  Future<void> deleteAllInventarios() async {
    final db = await database;
    await db.delete('inventarios');
  }

  Future<void> deleteInventarioTable() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS inventarios');
  }

}

