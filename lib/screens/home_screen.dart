import 'package:flutter/material.dart';
import '/providers/general.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my_warehouse_orders'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16.0),
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        children: [
          /*_buildButton(context, 'Escaner F', Colors.red, () {
            modoScanner = 0;
            tractametCodiBarresSeleccionat = TractametCodiBarresSeleccionat.llegirProducte;
            Navigator.pushNamed(context, '/order_line_scan');
          }),
          _buildButton(context, 'Escaner A', Colors.green, () {
            modoScanner = 1;
            tractametCodiBarresSeleccionat = TractametCodiBarresSeleccionat.llegirProducte;
            Navigator.pushNamed(context, '/order_line_scan');
          }),*/
          _buildButton(context, 'Sincroni-\nzación', Colors.purple, () {
            Navigator.pushNamed(context, '/sincronizacion');
          }),
          _buildButton(context, 'Productos', Colors.blue, () {
            modoScanner = 0;
            tractametCodiBarresSeleccionat = TractametCodiBarresSeleccionat.llegirProducte;
            Navigator.pushNamed(context, '/productos');
          }),
          _buildButton(context, 'Configu-\nración', Colors.orange, () {
            Navigator.pushNamed(context, '/configuracion');
          }),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Color color, void Function() onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        //primary: color,
        //onPrimary: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.0),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}
