import 'dart:core';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '/providers/general.dart';

final storage = new FlutterSecureStorage();

Future<String?> getToken() async {
  String? token = "";
  // Obtenemos el token de autenticaci�n almacenado en la aplicaci�n
  try {
    String? token = await storage.read(key: 'token');
  } catch(e) {
    token = "";
  }
  return token;
}

Future<void> setToken(String token) async {
  // Almacenamos el token de autenticaci�n en la aplicaci�n
  await storage.write(key: 'token', value: token);
}
