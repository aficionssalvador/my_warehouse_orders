import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '/models/configuracion_model.dart';
import '/providers/flutter_secure_storage.dart' as Myhttp;

class ConfiguracionScreen extends StatefulWidget {
  @override
  _ConfiguracionScreenState createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  final TextEditingController _idClienteController = TextEditingController();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();

  String fileNameConfig = 'my_warehouse_orders_config.json';

  @override
  void initState() {
    super.initState();
    _loadConfigData();
  }

  @override
  void dispose() {
    _idClienteController.dispose();
    _usuarioController.dispose();
    _urlController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadConfigData() async {
    final Configuracion data = await _readDataFromLocal();
    _idClienteController.text = data.idCliente;
    _usuarioController.text = data.usuario;
    _urlController.text = data.url;
    _apiKeyController.text = data.apiKey;
    //_apiKeyController.text = (await Myhttp.getToken()) ?? "";
  }

  Future<Configuracion> _readDataFromLocal() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileNameConfig';
      final file = File(filePath);
      if (await file.exists()) {
        final jsonData = await file.readAsString();
        final data = Configuracion.fromMap(json.decode(jsonData));
        return data;
      } else {
        return Configuracion(idCliente: '', usuario: '', url: '', apiKey: '');
      }
    } catch (e) {
      return Configuracion(idCliente: '', usuario: '', url: '', apiKey: '');
    }
  }

  Future<void> _saveDataToLocal(Configuracion configuracion) async {
    String tk = configuracion.apiKey;
    await Myhttp.setToken(tk);
    configuracion.apiKey = "";
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileNameConfig';
    final file = File(filePath);
    final jsonData = json.encode(configuracion.toMap());
    await file.writeAsString(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idClienteController,
              readOnly: _idClienteController.text.isNotEmpty,
              decoration: InputDecoration(labelText: 'ID Cliente'),
            ),
            TextField(
              controller: _usuarioController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _urlController,
              readOnly: _urlController.text.isNotEmpty,
              decoration: InputDecoration(labelText: 'URL base'),
              obscureText: true,
            ),
            TextField(
              controller: _apiKeyController,
              readOnly: _apiKeyController.text.isNotEmpty,
              decoration: InputDecoration(labelText: 'ApiKey'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final configuracion = Configuracion(
                  idCliente: _idClienteController.text,
                  usuario: _usuarioController.text,
                  url: _urlController.text,
                  apiKey: _apiKeyController.text,
                );
                await _saveDataToLocal(configuracion);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Configuración guardada')),
                );
                Navigator.pop(context);
              },
              child: Text('  Guardar  ', style: TextStyle(fontSize: 20.0)),
            ),
          ],
        ),
      ),
    );
  }
}
