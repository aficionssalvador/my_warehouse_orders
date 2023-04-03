class Producto {
  final String id;
  final String id2;
  final String grp1;
  final String grp2;
  final String grp3;
  final String grp4;
  final String descripcion;
  final String tdhr;

  Producto({
    required this.id,
    required this.id2,
    required this.grp1,
    required this.grp2,
    required this.grp3,
    required this.grp4,
    required this.descripcion,
    required this.tdhr,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id2': id2,
      'grp1': grp1,
      'grp2': grp2,
      'grp3': grp3,
      'grp4': grp4,
      'descripcion': descripcion,
      'tdhr': tdhr,
    };
  }

  factory Producto.fromMap(Map<String, dynamic> map) {
    return Producto(
      id: map['id'],
      id2: map['id2'],
      grp1: map['grp1'],
      grp2: map['grp2'],
      grp3: map['grp3'],
      grp4: map['grp4'],
      descripcion: map['descripcion'],
      tdhr: map['tdhr'],
    );
  }
}
