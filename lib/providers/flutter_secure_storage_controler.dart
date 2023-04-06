import 'dart:core';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '/providers/general.dart';

final storage = new FlutterSecureStorage();

Future<String?> getToken() async {
  String? token = "";
  // Obtenemos el token de autenticación almacenado en la aplicación
  try {
    String? token = await storage.read(key: 'token');
  } catch(e) {
    token = "";
  }
  return token;
}

Future<void> setToken(String token) async {
  // Almacenamos el token de autenticación en la aplicación
  await storage.write(key: 'token', value: token);
}
