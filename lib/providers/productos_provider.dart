import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '/models/productos_model.dart';
import 'general.dart';


ProductoDataProvider currentProductoDataProvider = ProductoDataProvider();

class ProductoDataProvider {

  Future<void> insertProducto(Producto producto) async {
    final db = await database;
    await db.insert('productos', producto.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Producto>> getProductos(String filtro) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;
    if (filtro == "") {
      maps = await db.query('productos');
    } else {
      maps = await db.query(
        'stocks',
        where: filtro,
      );
    }
    return List.generate(maps.length, (i) {
      return Producto.fromMap(maps[i]);
    });
  }

  Future<void> updateProducto(Producto producto) async {
    final db = await database;
    await db.update(
      'productos',
      producto.toMap(),
      where: 'id = ?',
      whereArgs: [producto.id],
    );
  }

  Future<void> deleteProducto(String id) async {
    final db = await database;
    await db.delete(
      'productos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllProductos() async {
    final db = await database;
    await db.delete('productos');
  }

  Future<void> deleteTable() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS productos');
  }

  Future<void> createTable() async {
    final db = await database;
    await db.execute('''
CREATE TABLE IF NOT EXISTS productos (
id TEXT PRIMARY KEY,
id2 TEXT,
grp1 TEXT,
grp2 TEXT,
grp3 TEXT,
grp4 TEXT,
descripcion TEXT,
tdhr TEXT
);
''');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_productos_id2 ON productos(id2);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_productos_grp1 ON productos(grp1);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_productos_grp2 ON productos(grp2);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_productos_grp3 ON productos(grp3);');
    await db.execute('CREATE INDEX IF NOT EXISTS idx_productos_grp4 ON productos(grp4);');
  }
}