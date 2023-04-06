import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:my_wharehouse_orders/u2/u2_string_utils.dart';
import '/providers/general.dart';

Future<String?> _getToken() async {
  String? token;
  return await currentConfiguracion!.apiKey;
}
Uri? getMiUrl(String ruta, [Map<String, dynamic>? queryParams ]){
  Uri? url;
  if (currentConfiguracion!.url.startsWith("https://")){
    url = Uri.https(
      U2StringUtils.u2Substr(currentConfiguracion!.url, 9, 999),
      ruta,
      queryParams
    );
  } else if (currentConfiguracion!.url.startsWith("http://")){
    url = Uri.http(
        U2StringUtils.u2Substr(currentConfiguracion!.url, 8, 999),
        ruta,
        queryParams
    );
  }
  return url;
}
Future<http.Response> getHttpWithAuth(Uri url) async {
  http.Response response;
  // Obtenemos el token de autenticación
  String token = (await _getToken()) ?? "";
  String urlBase = currentConfiguracion!.apiKey;
  if (token.isEmpty) {
    response = await http.get(url);
  } else {
    // Agregamos el token de autenticación en el encabezado de la solicitud HTTP
    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    // Enviamos la solicitud HTTP con el encabezado de autenticación
    response = await http.get(url, headers: headers);
  }
  return response;
}

Future<http.Response> postHttpWithAuth(Uri url, dynamic body) async {
  http.Response response;
  // Obtenemos el token de autenticación
  String token = (await _getToken()) ?? "";
  String urlBase = currentConfiguracion!.apiKey;
  if (token.isEmpty) {
    response = await http.post(url, body: body);
  } else {
    // Agregamos el token de autenticación en el encabezado de la solicitud HTTP
    Map<String, String> headers = {'Authorization': 'Bearer $token'};

    // Enviamos la solicitud HTTP con el encabezado de autenticación y el cuerpo de la solicitud
    response = await http.post(url, headers: headers, body: body);
  }
  return response;
}