import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/productos_model.dart';
import '/providers/productos_provider.dart';
import '/providers/general.dart';

class ProductosScreen extends StatefulWidget {
  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  TextEditingController _filtroController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Agrega un GlobalKey para el Form

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner),
            onPressed: () {
              modoScanner = 1;
              Navigator.pushNamed(context, '/order_line_scan');
            },
          ),
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              modoScanner = 0;
              Navigator.pushNamed(context, '/order_line_scan');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form( // Envuelve el TextField en un Form
              key: _formKey,
              child: TextFormField(
                controller: _filtroController,
                onFieldSubmitted: (value) { // Cambia onChanged a onFieldSubmitted
                  setState(() {
                    currentProductoDataProvider.getProductos(_filtroController.text);
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Filtrar',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton( // Agrega un botón al final del TextField
                    icon: Icon(Icons.search),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          currentProductoDataProvider.getProductos(_filtroController.text);
                        });
                      }
                    },
                  ),
                ),
              ),
            ),



          ),

          Expanded(
            child: Consumer<ProductoDataProvider>(
              builder: (context, currentProductoDataProvider, child) {
                return FutureBuilder<List<Producto>>(
                  future: currentProductoDataProvider.getProductos(_filtroController.text),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Producto producto = snapshot.data![index];
                            return ListTile(
                              title: Text(producto.descripcion),
                              subtitle: Text('ID: ${producto.id}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.slideshow),
                                    onPressed: () {
                                      // Navegar a la pantalla de edición
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.warehouse),
                                    onPressed: () {
                                      // Eliminar producto
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
