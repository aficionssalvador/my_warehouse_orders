import 'dart:core';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final storage = new FlutterSecureStorage();

Future<String?> getToken() async {
  String? token;
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

Future<http.Response> getHttpWithAuth(String url) async {
  http.Response response;
  // Obtenemos el token de autenticaci�n
  String token = (await getToken()) ?? "";
  if (token.isEmpty) {
    response = await http.get(Uri.parse(url));
  } else {
    // Agregamos el token de autenticaci�n en el encabezado de la solicitud HTTP
    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    // Enviamos la solicitud HTTP con el encabezado de autenticaci�n
    response = await http.get(Uri.parse(url), headers: headers);
  }
  return response;
}

Future<http.Response> postHttpWithAuth(String url, dynamic body) async {
  http.Response response;
  // Obtenemos el token de autenticaci�n
  String token = (await getToken()) ?? "";

  if (token.isEmpty) {
    response = await http.post(Uri.parse(url), body: body);
  } else {
    // Agregamos el token de autenticaci�n en el encabezado de la solicitud HTTP
    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    // Enviamos la solicitud HTTP con el encabezado de autenticaci�n y el cuerpo de la solicitud
    response = await http.post(Uri.parse(url), headers: headers, body: body);
  }
  return response;
}