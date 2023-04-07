class Stock {
  final String idStock;
  final String id;
  final String id2;
  final String ubicacion;
  final num cantidad;
  final String unidadMedida;
  final num unidadesEmbalaje;
  final String tipoEmbalaje;
  final String idSerialLote;
  final String tdhrCaduca;
  final String tdhr;

  Stock({
    required this.idStock,
    required this.id,
    required this.id2,
    required this.ubicacion,
    required this.cantidad,
    required this.unidadMedida,
    required this.unidadesEmbalaje,
    required this.tipoEmbalaje,
    required this.idSerialLote,
    required this.tdhrCaduca,
    required this.tdhr,
  });

  Map<String, dynamic> toMap() {
    return {
      'idStock': idStock,
      'id': id,
      'id2': id2,
      'ubicacion': ubicacion,
      'cantidad': cantidad,
      'unidadMedida': unidadMedida,
      'unidadesEmbalaje': unidadesEmbalaje,
      'tipoEmbalaje': tipoEmbalaje,
      'idSerialLote': idSerialLote,
      'tdhrCaduca': tdhrCaduca,
      'tdhr': tdhr,
    };
  }

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      idStock: map['idStock'],
      id: map['id'],
      id2: map['id2'],
      ubicacion: map['ubicacion'],
      cantidad: map['cantidad'],
      unidadMedida: map['unidadMedida'],
      unidadesEmbalaje: map['unidadesEmbalaje'],
      tipoEmbalaje: map['tipoEmbalaje'],
      idSerialLote: map['idSerialLote'],
      tdhrCaduca: map['tdhrCaduca'],
      tdhr: map['tdhr'],
    );
  }
}
