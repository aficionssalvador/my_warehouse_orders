import 'dart:async';
import 'package:sqflite/sqflite.dart';
// import 'package:flutter/foundation.dart';
import '/providers/http_controller.dart' as httpmy;
import 'dart:convert';
import '/models/productos_model.dart';
import 'general.dart';
import '/u2/u2_string_utils.dart';

// ok
ProductoDataProvider currentProductoDataProvider = ProductoDataProvider();

String FiltroDeProductos(String filtro){
  if (filtro == "*") {
    return "true";
  }
  return  "id = ${U2StringUtils.u2SQuoteEscaped(filtro)} or id2 = ${U2StringUtils.u2SQuoteEscaped(filtro)}";
}

//class ProductoDataProvider extends ChangeNotifier {
class ProductoDataProvider {
  List<Producto> _productos = [];
  List<Producto> get productos => _productos;

  Future<int> insertProducto(Producto producto) async {
    final db = await database;
    return await db.insert('productos', producto.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Producto>> getProductos(String filtro) async {
    //print("getProductos 1: $filtro");
    final db = await database;
    //print("getProductos 2: $filtro");
    final List<Map<String, dynamic>> maps;
    //print("getProductos 3: $filtro");
    if (filtro == "") {
      _productos = [];
      return _productos;
      //maps = await db.query('productos');
    } else {
      maps = await db.query(
        'productos',
        where: filtro,
      );
    }
    _productos =  List.generate(maps.length, (i) {
      return Producto.fromMap(maps[i]);
    });
    // notifyListeners();
    return _productos;
  }

  Future<Producto> getLookup(String key) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;
    maps = await db.query(
      'productos',
      where: 'id = ${U2StringUtils.u2SQuoteEscaped(key)}',
    );
    return Producto.fromMap(maps[0]);
  }

  Future<int> updateProducto(Producto producto) async {
    final db = await database;
    return await db.update(
      'productos',
      producto.toMap(),
      where: 'id = ?',
      whereArgs: [producto.id],
    );
  }

  Future<int> deleteProducto(String id) async {
    final db = await database;
    return await db.delete(
      'productos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllProductos() async {
    final db = await database;
    return await db.delete('productos');
  }

  Future<void> deleteTable() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS productos');
  }

  Future<void> createTable(Database db) async {
    //final db = await database;
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

  Future<void> fetchAndStoreProductos([Map<String,dynamic>? parametrosGet]) async {
    Uri? url = httpmy.getMiUrl('/api/productos',parametrosGet);
    if (url == null) {
      throw Exception('Falta configurar la URL');
    }
    try {
      final response = await httpmy.getHttpWithAuth(url!);
      if (response.statusCode == 200) {
        List<dynamic> productosJson = json.decode(response.body);
        print("total productos: ${productosJson.length}");
        // deleteAllProductos();
        // var l = await getProductos("true");    print("antes de cargar: ${l.length}");
        for (var productoJson in productosJson) {
          Producto producto = Producto.fromMap(productoJson);
          try {
            int cnt;
            cnt = await updateProducto(producto);
            if (cnt == 0) {
              int cnt = await insertProducto(producto);
              // print("insert ${producto.id}, $cnt");
            } else {
              // print("update ${producto.id}, $cnt");
            }
          } catch (e) {
            throw Exception('Error al guardar productos en local ${e.toString()}');
          }
        }
        var l2 = await getProductos("true");
        print("despues de update: ${l2.length}");
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
