import 'package:star_mesas_app/app/config/constantes.dart';

class ModeloProductoVenta {
  // --- Identificadores y Catálogo ---
  final int? tempId;
  final String? id;
  final String codigoa;
  final String codigob;
  final String detalle1;
  final String detalle2;
  final String imp; // Porcentaje de IVA ('16.00', '8.00', '0.00', etc.)
  final String fracc; // 'Si' / 'No'
  final String unidad;
  final String pieza;
  final String deposito;

  // --- Costos y Existencia ---
  final double existencia;
  final double costoA;
  final double costoR;
  final double costoDolar;
  final double costoCop;

  // --- Precios de Catálogo ---
  final double priceA;
  final double priceB;
  final double priceC;
  final double priceD;
  final double priceDolar;
  final double priceCop;

  // --- Datos Transaccionales (Venta Actual) ---
  final double cantidadSele;

  // Precios Unitarios de Trabajo (según el tipo de precio activo: General, Mayorista, etc.)
  final double precioBsUnitario;
  final double precioDolarUnitario;
  final double precioPesosUnitario;

  // Precios Unitarios Sin IVA
  final double priceBsSinIva;
  final double priceDolarSinIva;
  final double priceCopSinIva;

  // Totales de IVA
  final double ivaBs;
  final double ivaD;
  final double ivaPesos;

  // Totales de Línea Sin IVA
  final double precioBsSele;
  final double precioDSele;
  final double precioPesosSele;

  // Totales de Línea Con IVA (Montos finales a pagar)
  final double precioBsSeleIva;
  final double precioDSeleIva;
  final double precioPesosSeleIva;

  final String activo;

  final String nomImag;

  ModeloProductoVenta({
    this.tempId,
    this.id,
    required this.codigoa,
    required this.codigob,
    required this.detalle1,
    required this.detalle2,
    required this.imp,
    required this.fracc,
    required this.unidad,
    required this.pieza,
    required this.deposito,
    required this.existencia,
    required this.costoA,
    required this.costoR,
    required this.costoDolar,
    required this.costoCop,
    required this.priceA,
    required this.priceB,
    required this.priceC,
    required this.priceD,
    required this.priceDolar,
    required this.priceCop,
    required this.cantidadSele,
    required this.precioBsUnitario,
    required this.precioDolarUnitario,
    required this.precioPesosUnitario,
    required this.priceBsSinIva,
    required this.priceDolarSinIva,
    required this.priceCopSinIva,
    required this.ivaBs,
    required this.ivaD,
    required this.ivaPesos,
    required this.precioBsSele,
    required this.precioDSele,
    required this.precioPesosSele,
    required this.precioBsSeleIva,
    required this.precioDSeleIva,
    required this.precioPesosSeleIva,
    required this.activo,
    this.nomImag = '',
  });

  /// Permite crear un producto desde un Map de la BD o Catálogo
  factory ModeloProductoVenta.fromMap(Map<String, dynamic> m) {
    final cantSele = parseValue(m['cantidadSele'] ?? m['cantidad'] ?? 1);
    final pA = parseValue(m['price_a'] ?? m['precio'] ?? 0);
    final pB = parseValue(m['price_b'] ?? m['Price_b'] ?? 0);
    final pC = parseValue(m['price_c'] ?? m['Price_c'] ?? 0);
    final pD = parseValue(m['price_d'] ?? m['Price_d'] ?? 0);
    final pDolar = parseValue(m['price_dolar'] ?? m['Price_dolar'] ?? 0);
    final pCop = parseValue(m['price_cop'] ?? m['Price_Cop'] ?? 0);

    final uBs = parseValue(m['precioBsUnitario'] ?? pA);
    final uD = parseValue(m['precioDolarUnitario'] ?? pDolar);
    final uCop = parseValue(m['precioPesosUnitario'] ?? pCop);

    return ModeloProductoVenta(
      tempId: parseInt(m['temp_id']),
      id: m['id']?.toString(),
      codigoa: m['codigoa']?.toString() ?? '',
      codigob: m['codigob']?.toString() ?? '',
      detalle1: m['detalle1']?.toString() ?? '',
      detalle2: m['detalle2']?.toString() ?? '',
      imp: m['imp']?.toString() ?? '16.00',
      fracc: m['fracc']?.toString() ?? 'No',
      unidad: m['unidad']?.toString() ?? '',
      pieza: m['pieza']?.toString() ?? '',
      deposito: m['deposito']?.toString() ?? m['dp']?.toString() ?? '',
      existencia: parseValue(m['existencia']),
      costoA: parseValue(m['costo_a']),
      costoR: parseValue(m['costo_r']),
      costoDolar: parseValue(m['costo_dolar']),
      costoCop: parseValue(m['costo_cop']),
      priceA: pA,
      priceB: pB,
      priceC: pC,
      priceD: pD,
      priceDolar: pDolar,
      priceCop: pCop,
      cantidadSele: cantSele,
      precioBsUnitario: uBs,
      precioDolarUnitario: uD,
      precioPesosUnitario: uCop,
      priceBsSinIva: parseValue(m['price_bsSinIva']),
      priceDolarSinIva: parseValue(m['price_dolarSinIva']),
      priceCopSinIva: parseValue(m['price_copSinIva']),
      ivaBs: parseValue(m['ivaBs'] ?? m['precioiva']),
      ivaD: parseValue(m['ivaD']),
      ivaPesos: parseValue(m['ivaPesos']),
      precioBsSele: parseValue(
        m['precioBsSele'] ?? m['subtotalt'] ?? m['preciobase'],
      ),
      precioDSele: parseValue(m['precioDSele']),
      precioPesosSele: parseValue(m['precioPesosSele']),
      precioBsSeleIva: parseValue(m['precioBsSeleIva'] ?? m['subtotal']),
      precioDSeleIva: parseValue(m['precioDSeleIva'] ?? m['subtotal_dolar']),
      precioPesosSeleIva: parseValue(
        m['precioPesosSeleIva'] ?? m['subtotal_cop'],
      ),
      activo: m['activo']?.toString() ?? 'Temporal',
      nomImag: m['NomImag']?.toString() ?? '',
    );
  }

  /// Acceso estilo mapa para 100% retrocompatibilidad con componentes legacy
  dynamic operator [](String key) => toMap()[key];

  /// Exporta el producto a Map con todas las llaves exactas que esperan los scripts de guardado e impresión
  Map<String, dynamic> toMap() {
    return {
      'temp_id': tempId,
      'id': id,
      'codigoa': codigoa,
      'codigob': codigob,
      'detalle1': detalle1,
      'detalle2': detalle2,
      'imp': imp,
      'fracc': fracc,
      'unidad': unidad,
      'pieza': pieza,
      'deposito': deposito,
      'dp': deposito,
      'existencia': existencia,
      'costo_a': costoA,
      'costo_r': costoR,
      'costo_dolar': costoDolar,
      'costo_cop': costoCop,
      'price_a': priceA,
      'price_b': priceB,
      'price_c': priceC,
      'price_d': priceD,
      'price_dolar': priceDolar,
      'price_cop': priceCop,
      'cantidadSele': cantidadSele,
      'cantidad': cantidadSele,
      'precioBsUnitario': precioBsUnitario,
      'precioDolarUnitario': precioDolarUnitario,
      'precioPesosUnitario': precioPesosUnitario,
      'price_bsSinIva': priceBsSinIva,
      'price_dolarSinIva': priceDolarSinIva,
      'price_copSinIva': priceCopSinIva,
      'ivaBs': ivaBs,
      'ivaD': ivaD,
      'ivaPesos': ivaPesos,
      'precioBsSele': precioBsSele,
      'precioDSele': precioDSele,
      'precioPesosSele': precioPesosSele,
      'precioBsSeleIva': precioBsSeleIva,
      'precioDSeleIva': precioDSeleIva,
      'precioPesosSeleIva': precioPesosSeleIva,
      'subtotal': precioBsSeleIva,
      'subtotal_dolar': precioDSeleIva,
      'subtotal_cop': precioPesosSeleIva,
      'subtotalt': precioBsSele,
      'preciobase': precioBsSele,
      'precioiva': ivaBs,
      'precio': precioBsUnitario,
      'activo': activo,
      'NomImag': nomImag,
    };
  }

  /// Permite modificar campos creando una nueva instancia inmutable
  ModeloProductoVenta copyWith({
    int? tempId,
    String? id,
    String? codigoa,
    String? codigob,
    String? detalle1,
    String? detalle2,
    String? imp,
    String? fracc,
    String? unidad,
    String? pieza,
    String? deposito,
    double? existencia,
    double? costoA,
    double? costoR,
    double? costoDolar,
    double? costoCop,
    double? priceA,
    double? priceB,
    double? priceC,
    double? priceD,
    double? priceDolar,
    double? priceCop,
    double? cantidadSele,
    double? precioBsUnitario,
    double? precioDolarUnitario,
    double? precioPesosUnitario,
    double? priceBsSinIva,
    double? priceDolarSinIva,
    double? priceCopSinIva,
    double? ivaBs,
    double? ivaD,
    double? ivaPesos,
    double? precioBsSele,
    double? precioDSele,
    double? precioPesosSele,
    double? precioBsSeleIva,
    double? precioDSeleIva,
    double? precioPesosSeleIva,
    String? activo,
    String? nomImag,
  }) {
    return ModeloProductoVenta(
      tempId: tempId ?? this.tempId,
      id: id ?? this.id,
      codigoa: codigoa ?? this.codigoa,
      codigob: codigob ?? this.codigob,
      detalle1: detalle1 ?? this.detalle1,
      detalle2: detalle2 ?? this.detalle2,
      imp: imp ?? this.imp,
      fracc: fracc ?? this.fracc,
      unidad: unidad ?? this.unidad,
      pieza: pieza ?? this.pieza,
      deposito: deposito ?? this.deposito,
      existencia: existencia ?? this.existencia,
      costoA: costoA ?? this.costoA,
      costoR: costoR ?? this.costoR,
      costoDolar: costoDolar ?? this.costoDolar,
      costoCop: costoCop ?? this.costoCop,
      priceA: priceA ?? this.priceA,
      priceB: priceB ?? this.priceB,
      priceC: priceC ?? this.priceC,
      priceD: priceD ?? this.priceD,
      priceDolar: priceDolar ?? this.priceDolar,
      priceCop: priceCop ?? this.priceCop,
      cantidadSele: cantidadSele ?? this.cantidadSele,
      precioBsUnitario: precioBsUnitario ?? this.precioBsUnitario,
      precioDolarUnitario: precioDolarUnitario ?? this.precioDolarUnitario,
      precioPesosUnitario: precioPesosUnitario ?? this.precioPesosUnitario,
      priceBsSinIva: priceBsSinIva ?? this.priceBsSinIva,
      priceDolarSinIva: priceDolarSinIva ?? this.priceDolarSinIva,
      priceCopSinIva: priceCopSinIva ?? this.priceCopSinIva,
      ivaBs: ivaBs ?? this.ivaBs,
      ivaD: ivaD ?? this.ivaD,
      ivaPesos: ivaPesos ?? this.ivaPesos,
      precioBsSele: precioBsSele ?? this.precioBsSele,
      precioDSele: precioDSele ?? this.precioDSele,
      precioPesosSele: precioPesosSele ?? this.precioPesosSele,
      precioBsSeleIva: precioBsSeleIva ?? this.precioBsSeleIva,
      precioDSeleIva: precioDSeleIva ?? this.precioDSeleIva,
      precioPesosSeleIva: precioPesosSeleIva ?? this.precioPesosSeleIva,
      activo: activo ?? this.activo,
      nomImag: nomImag ?? this.nomImag,
    );
  }
}
