class Configuracion {
  String idCliente;
  String usuario;
  String url;
  String apiKey;

  Configuracion({
    required this.idCliente,
    required this.usuario,
    required this.url,
    required this.apiKey,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'idCliente': idCliente,
      'usuario': usuario,
      'url': url,
      'apiKey': apiKey,
    };
  }

  factory Configuracion.fromMap(Map<dynamic, dynamic> map) {
    try {
      return Configuracion(
        idCliente: map['idCliente'],
        usuario: map['usuario'],
        url: map['url'],
        apiKey: map['apiKey'],
      );
    } catch(e) {
      return Configuracion(
        idCliente: "",
        usuario: "",
        url: "",
        apiKey: "",
      );
    }
  }
}
