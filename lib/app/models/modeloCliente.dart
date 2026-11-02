class ModeloCliente {
  final String rif;
  final String nombre;
  final String direccion;
  final String telefono;
  final String nroVendedor;
  final String nombVendedor;
  final String correo;
  final String contribuyente;
  final String tipoConexionNCND;
  final String nroMesa;
  final int dias;
  final double ref;
  final bool validarCredito;
  final double restanteRef;
  ModeloCliente({
    required this.rif,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.nroVendedor,
    required this.nombVendedor,
    required this.correo,
    required this.contribuyente,
    required this.tipoConexionNCND,
    required this.nroMesa,
    required this.dias,
    required this.ref,
    required this.validarCredito,
    required this.restanteRef,
  });

  /// Constructor vacío por defecto
  factory ModeloCliente.empty() {
    return ModeloCliente(
      rif: '',
      nombre: '',
      direccion: '',
      telefono: '',
      nroVendedor: '',
      nombVendedor: '',
      correo: '',
      contribuyente: '',
      tipoConexionNCND: '',
      nroMesa: '',
      dias: 0,
      ref: 0.0,
      validarCredito: false,
      restanteRef: 0.0,
    );
  }

  /// Construye una TarjetaVenta desde la respuesta de la DB.
  factory ModeloCliente.fromMap(Map<String, dynamic> m) {
    return ModeloCliente(
      rif: m['rif']?.toString() ?? '',
      nombre: m['nombre']?.toString() ?? '',
      direccion: m['direccion']?.toString() ?? '',
      telefono: m['telefono']?.toString() ?? '',
      nroVendedor: m['vendedor']?.toString() ?? '',
      nombVendedor: m['nombVendedor']?.toString() ?? '',
      correo: m['correo']?.toString() ?? '',
      contribuyente: m['contribuyente']?.toString() ?? '',
      tipoConexionNCND: m['tipoConexionNC-ND']?.toString() ?? '',
      nroMesa: m['nroMesa']?.toString() ?? '',
      dias: int.tryParse(m['dias']?.toString() ?? '0') ?? 0,
      ref: double.tryParse(m['ref']?.toString() ?? '0') ?? 0.0,
      validarCredito: m['validarCredito']?.toString().toLowerCase() == 'true',
      restanteRef: double.tryParse(m['restanteRef']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rif': rif,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'vendedor': nroVendedor,
      'nombVendedor': nombVendedor,
      'correo': correo,
      'contribuyente': contribuyente,
      'tipoConexionNC-ND': tipoConexionNCND,
      'nroMesa': nroMesa,
      'dias': dias,
      'ref': ref,
      'validarCredito': validarCredito,
      'restanteRef': restanteRef,
    };
  }

  ModeloCliente copyWith({
    String? rif,
    String? nombre,
    String? direccion,
    String? telefono,
    String? vendedor,
    String? nombVendedor,
    String? correo,
    String? contribuyente,
    String? tipoConexionNCND,
    String? nroMesa,
    int? dias,
    double? ref,
    bool? validarCredito,
    double? restanteRef,
  }) {
    return ModeloCliente(
      rif: rif ?? this.rif,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      nroVendedor: vendedor ?? this.nroVendedor,
      nombVendedor: nombVendedor ?? this.nombVendedor,
      correo: correo ?? this.correo,
      contribuyente: contribuyente ?? this.contribuyente,
      tipoConexionNCND: tipoConexionNCND ?? this.tipoConexionNCND,
      nroMesa: nroMesa ?? this.nroMesa,
      dias: dias ?? this.dias,
      ref: ref ?? this.ref,
      validarCredito: validarCredito ?? this.validarCredito,
      restanteRef: restanteRef ?? this.restanteRef,
    );
  }
}
