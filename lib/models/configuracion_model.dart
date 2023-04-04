class Configuracion {
  String idCliente;
  String usuario;
  String contrasena;

  Configuracion({
    required this.idCliente,
    required this.usuario,
    required this.contrasena,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'idCliente': idCliente,
      'usuario': usuario,
      'contrasena': contrasena,
    };
  }

  factory Configuracion.fromMap(Map<dynamic, dynamic> map) {
    try {
      return Configuracion(
        idCliente: map['idCliente'],
        usuario: map['usuario'],
        contrasena: map['contrasena'],
      );
    } catch(e) {
      return Configuracion(
        idCliente: "",
        usuario: "",
        contrasena: "",
      );
    }
  }
}
