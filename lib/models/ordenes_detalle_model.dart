class OrdenDetalleModel {
  final String idOrden;
  final int idLineaOrden;
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

  OrdenDetalleModel({
    required this.idOrden,
    required this.idLineaOrden,
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
      'idOrden':idOrden,
      'idLineaOrden': idLineaOrden,
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

  factory OrdenDetalleModel.fromMap(Map<String, dynamic> map) {
    return OrdenDetalleModel(
      idOrden: map['idOrden'],
      idLineaOrden: map['idLineaOrden'],
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
