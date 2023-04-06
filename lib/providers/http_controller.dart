import 'dart:core';
import 'package:http/http.dart' as http;
import '/providers/general.dart';

Future<String?> _getToken() async {
  String? token;
  return await currentConfiguracion!.apiKey;
}

Future<http.Response> getHttpWithAuth(String url) async {
  http.Response response;
  // Obtenemos el token de autenticación
  String token = (await _getToken()) ?? "";
  String urlBase = currentConfiguracion!.apiKey;
  if (token.isEmpty) {
    response = await http.get(Uri.parse(urlBase+url));
  } else {
    // Agregamos el token de autenticación en el encabezado de la solicitud HTTP
    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    // Enviamos la solicitud HTTP con el encabezado de autenticación
    response = await http.get(Uri.parse(urlBase+url), headers: headers);
  }
  return response;
}

Future<http.Response> postHttpWithAuth(String url, dynamic body) async {
  http.Response response;
  // Obtenemos el token de autenticación
  String token = (await _getToken()) ?? "";
  String urlBase = currentConfiguracion!.apiKey;
  if (token.isEmpty) {
    response = await http.post(Uri.parse(urlBase+url), body: body);
  } else {
    // Agregamos el token de autenticación en el encabezado de la solicitud HTTP
    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    // Enviamos la solicitud HTTP con el encabezado de autenticación y el cuerpo de la solicitud
    response = await http.post(Uri.parse(urlBase+url), headers: headers, body: body);
  }
  return response;
}