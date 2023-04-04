import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

  Future<void> fetchAndStoreProductos() async {
    // Reemplaza esta URL con la URL de tu servicio REST
    final url = 'https://api.example.com/productos';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> productosJson = json.decode(response.body);
        for (var productoJson in productosJson) {
          Producto producto = Producto.fromMap(productoJson);
          await insertProducto(producto);
        }
      } else {
        throw Exception('Error al obtener productos del servidor');
      }
    } catch (error) {
      throw error;
    }
  }
/*
[
  {
    "id": "1",
    "id2": "1001",
    "grp1": "Electrónica",
    "grp2": "Computadoras",
    "grp3": "Laptops",
    "grp4": "Gaming",
    "descripcion": "Laptop Gamer XYZ",
    "tdhr": "2023-04-05T08:30:00"
  },
  {
    "id": "2",
    "id2": "1002",
    "grp1": "Electrónica",
    "grp2": "Computadoras",
    "grp3": "Laptops",
    "grp4": "Ultrabook",
    "descripcion": "Ultrabook ABC",
    "tdhr": "2023-04-05T10:45:00"
  },
  {
    "id": "3",
    "id2": "2001",
    "grp1": "Hogar",
    "grp2": "Cocina",
    "grp3": "Utensilios",
    "grp4": "Cuchillos",
    "descripcion": "Set de cuchillos de cocina",
    "tdhr": "2023-04-05T14:20:00"
  }
]
*/
}
