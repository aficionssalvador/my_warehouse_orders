class Stock {
  final String id;
  final String id2;
  final String ubicacion;
  final double cantidad;
  final String unidadMedida;
  final int embalaje;
  final String tipoEmbalaje;
  final String idSerialLote;
  final String tdhrCaduca;
  final String tdhr;

  Stock({
    required this.id,
    required this.id2,
    required this.ubicacion,
    required this.cantidad,
    required this.unidadMedida,
    required this.embalaje,
    required this.tipoEmbalaje,
    required this.idSerialLote,
    required this.tdhrCaduca,
    required this.tdhr,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id2': id2,
      'ubicacion': ubicacion,
      'cantidad': cantidad,
      'unidad_medida': unidadMedida,
      'embalaje': embalaje,
      'tipo_embalaje': tipoEmbalaje,
      'id_serial_lote': idSerialLote,
      'tdhr_caduca': tdhrCaduca,
      'tdhr': tdhr,
    };
  }

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      id: map['id'],
      id2: map['id2'],
      ubicacion: map['ubicacion'],
      cantidad: map['cantidad'],
      unidadMedida: map['unidad_medida'],
      embalaje: map['embalaje'],
      tipoEmbalaje: map['tipo_embalaje'],
      idSerialLote: map['id_serial_lote'],
      tdhrCaduca: map['tdhr_caduca'],
      tdhr: map['tdhr'],
    );
  }
}
