class Orden {
  final String idOrden;
  final String tipoMovimiento;
  final String origen;
  final String destino;
  final String tdhrInicio;
  final String tdhrFinal;
  final String tdhr;

  Orden({
    required this.idOrden,
    required this.tipoMovimiento,
    required this.origen,
    required this.destino,
    required this.tdhrInicio,
    required this.tdhrFinal,
    required this.tdhr,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_orden': idOrden,
      'tipo_movimiento': tipoMovimiento,
      'origen': origen,
      'destino': destino,
      'tdhr_inicio': tdhrInicio,
      'tdhr_final': tdhrFinal,
      'tdhr': tdhr,
    };
  }

  factory Orden.fromMap(Map<String, dynamic> map) {
    return Orden(
      idOrden: map['id_orden'],
      tipoMovimiento: map['tipo_movimiento'],
      origen: map['origen'],
      destino: map['destino'],
      tdhrInicio: map['tdhr_inicio'],
      tdhrFinal: map['tdhr_final'],
      tdhr: map['tdhr'],
    );
  }
}
