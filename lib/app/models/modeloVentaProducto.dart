import 'package:star_mesas_app/app/config/constantes.dart';

class ModeloVentaProducto {
  final int id;
  final String fecha;
  final String rif;
  final String documento;
  final String codigoa;
  final String codigob;
  final String detalle1;
  final String detalle2;
  final double imp;
  final double cantidad;
  final double costoA;
  final double precio;
  final double subtotal;
  final String nrofiscal;
  final String nrodocreg;
  final String numgeneral;
  final String vendedor;
  final String deposito;
  final String activo;
  final String serial;
  final double preciofact;
  final double preciodif;
  final double subtotal2;
  final String usuario;
  final String pos;
  final String nrozeta;
  final String maquinanro;
  final String codeEmp;
  final double subtotalt;
  final String fracc;
  final double preciobase;
  final double precioiva;
  final double unidad;
  final double pieza;
  final String server;
  final String ntarjeta;
  final double costoR;
  final int dias;
  final double costoOp;
  final String lote;
  final String subgrupo;
  final double porcecomi;
  final String tipocomi;
  final double comision;
  final String tipoEmpaque;
  final double pesoequiv;
  final double totalpeso;
  final double totaldescontar;
  final double porcdescuento;
  final double priceDolar;
  final double priceCop;
  final double subtotalDolar;
  final double subtotalCop;
  final double costoDolar;
  final double costoCop;
  final String NomImag;

  ModeloVentaProducto({
    this.id = 0,
    this.fecha = '',
    this.rif = '',
    this.documento = '',
    this.codigoa = '',
    this.codigob = '',
    this.detalle1 = '',
    this.detalle2 = '',
    this.imp = 0.0,
    this.cantidad = 0.0,
    this.costoA = 0.0,
    this.precio = 0.0,
    this.subtotal = 0.0,
    this.nrofiscal = '',
    this.nrodocreg = '',
    this.numgeneral = '',
    this.vendedor = '',
    this.deposito = '',
    this.activo = '',
    this.serial = '',
    this.preciofact = 0.0,
    this.preciodif = 0.0,
    this.subtotal2 = 0.0,
    this.usuario = '',
    this.pos = '',
    this.nrozeta = '',
    this.maquinanro = '',
    this.codeEmp = '',
    this.subtotalt = 0.0,
    this.fracc = '',
    this.preciobase = 0.0,
    this.precioiva = 0.0,
    this.unidad = 1.0,
    this.pieza = 1.0,
    this.server = '',
    this.ntarjeta = '',
    this.costoR = 0.0,
    this.dias = 0,
    this.costoOp = 0.0,
    this.lote = '',
    this.subgrupo = '',
    this.porcecomi = 0.0,
    this.tipocomi = '',
    this.comision = 0.0,
    this.tipoEmpaque = 'UNIDAD',
    this.pesoequiv = 0.0,
    this.totalpeso = 0.0,
    this.totaldescontar = 0.0,
    this.porcdescuento = 0.0,
    this.priceDolar = 0.0,
    this.priceCop = 0.0,
    this.subtotalDolar = 0.0,
    this.subtotalCop = 0.0,
    this.costoDolar = 0.0,
    this.costoCop = 0.0,
    this.NomImag = '',
  });

  /// Construye un ModeloVentaProducto desde un Map (respuesta DB o JSON).
  factory ModeloVentaProducto.fromMap(Map<String, dynamic> m) {
    return ModeloVentaProducto(
      id: parseInt(m['id']),
      fecha: m['fecha']?.toString() ?? '',
      rif: m['rif']?.toString() ?? '',
      documento: m['documento']?.toString() ?? '',
      codigoa: m['codigoa']?.toString() ?? '',
      codigob: m['codigob']?.toString() ?? '',
      detalle1: m['detalle1']?.toString() ?? '',
      detalle2: m['detalle2']?.toString() ?? '',
      imp: parseValue(m['imp']),
      cantidad: parseValue(m['cantidad']),
      costoA: parseValue(m['costo_a'] ?? m['costoA']),
      precio: parseValue(m['precio']),
      subtotal: parseValue(m['subtotal']),
      nrofiscal: m['nrofiscal']?.toString() ?? '',
      nrodocreg: m['nrodocreg']?.toString() ?? '',
      numgeneral: m['numgeneral']?.toString() ?? '',
      vendedor: m['vendedor']?.toString() ?? '',
      deposito: m['deposito']?.toString() ?? '',
      activo: m['activo']?.toString() ?? '',
      serial: m['serial']?.toString() ?? '',
      preciofact: parseValue(m['preciofact']),
      preciodif: parseValue(m['preciodif']),
      subtotal2: parseValue(m['subtotal2']),
      usuario: m['usuario']?.toString() ?? '',
      pos: m['pos']?.toString() ?? '',
      nrozeta: m['nrozeta']?.toString() ?? '',
      maquinanro: m['maquinanro']?.toString() ?? '',
      codeEmp: m['code_emp']?.toString() ?? m['codeEmp']?.toString() ?? '',
      subtotalt: parseValue(m['subtotalt']),
      fracc: m['fracc']?.toString() ?? '',
      preciobase: parseValue(m['preciobase']),
      precioiva: parseValue(m['precioiva']),
      unidad: parseValue(m['unidad'] ?? 1.0),
      pieza: parseValue(m['pieza'] ?? 1.0),
      server: m['server']?.toString() ?? '',
      ntarjeta: m['ntarjeta']?.toString() ?? '',
      costoR: parseValue(m['costo_r'] ?? m['costoR']),
      dias: parseInt(m['dias']),
      costoOp: parseValue(m['costo_op'] ?? m['costoOp']),
      lote: m['lote']?.toString() ?? '',
      subgrupo: m['subgrupo']?.toString() ?? '',
      porcecomi: parseValue(m['porcecomi']),
      tipocomi: m['tipocomi']?.toString() ?? '',
      comision: parseValue(m['comision']),
      tipoEmpaque:
          m['tipo_empaque']?.toString() ??
          m['tipoEmpaque']?.toString() ??
          'UNIDAD',
      pesoequiv: parseValue(m['pesoequiv']),
      totalpeso: parseValue(m['totalpeso']),
      totaldescontar: parseValue(m['totaldescontar']),
      porcdescuento: parseValue(m['porcdescuento']),
      priceDolar: (() {
        double pd = parseValue(
          m['price_dolar'] ?? m['Price_dolar'] ?? m['price_Dolar'],
        );
        double subD = parseValue(m['subtotal_dolar'] ?? m['subtotal_Dolar']);
        double c = parseValue(m['cantidad']);
        if (pd == 0 && subD > 0 && c > 0) return subD / c;
        return pd;
      })(),
      priceCop: (() {
        double pc = parseValue(
          m['price_cop'] ?? m['Price_Cop'] ?? m['price_Cop'],
        );
        double subC = parseValue(
          m['subtotal_cop'] ?? m['subtotal_Cop'] ?? m['subtotal_COP'],
        );
        double c = parseValue(m['cantidad']);
        if (pc == 0 && subC > 0 && c > 0) return subC / c;
        return pc;
      })(),
      subtotalDolar: parseValue(m['subtotal_dolar'] ?? m['subtotal_Dolar']),
      subtotalCop: parseValue(
        m['subtotal_cop'] ?? m['subtotal_Cop'] ?? m['subtotal_COP'],
      ),
      costoDolar: parseValue(
        m['costo_dolar'] ?? m['Costo_Dolar'] ?? m['costo_Dolar'],
      ),
      costoCop: parseValue(m['costo_cop'] ?? m['Costo_Cop'] ?? m['costo_Cop']),
      NomImag: m['NomImag']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha,
      'rif': rif,
      'documento': documento,
      'codigoa': codigoa,
      'codigob': codigob,
      'detalle1': detalle1,
      'detalle2': detalle2,
      'imp': imp,
      'cantidad': cantidad,
      'costo_a': costoA,
      'precio': precio,
      'subtotal': subtotal,
      'nrofiscal': nrofiscal,
      'nrodocreg': nrodocreg,
      'numgeneral': numgeneral,
      'vendedor': vendedor,
      'deposito': deposito,
      'activo': activo,
      'serial': serial,
      'preciofact': preciofact,
      'preciodif': preciodif,
      'subtotal2': subtotal2,
      'usuario': usuario,
      'pos': pos,
      'nrozeta': nrozeta,
      'maquinanro': maquinanro,
      'code_emp': codeEmp,
      'subtotalt': subtotalt,
      'fracc': fracc,
      'preciobase': preciobase,
      'precioiva': precioiva,
      'unidad': unidad,
      'pieza': pieza,
      'server': server,
      'ntarjeta': ntarjeta,
      'costo_r': costoR,
      'dias': dias,
      'costo_op': costoOp,
      'lote': lote,
      'subgrupo': subgrupo,
      'porcecomi': porcecomi,
      'tipocomi': tipocomi,
      'comision': comision,
      'tipo_empaque': tipoEmpaque,
      'pesoequiv': pesoequiv,
      'totalpeso': totalpeso,
      'totaldescontar': totaldescontar,
      'porcdescuento': porcdescuento,
      'Price_dolar': priceDolar,
      'Price_Cop': priceCop,
      'subtotal_dolar': subtotalDolar,
      'subtotal_Cop': subtotalCop,
      'Costo_Dolar': costoDolar,
      'Costo_Cop': costoCop,
      'NomImag': NomImag,
    };
  }

  ModeloVentaProducto copyWith({
    int? id,
    String? fecha,
    String? rif,
    String? documento,
    String? codigoa,
    String? codigob,
    String? detalle1,
    String? detalle2,
    double? imp,
    double? cantidad,
    double? costoA,
    double? precio,
    double? subtotal,
    String? nrofiscal,
    String? nrodocreg,
    String? numgeneral,
    String? vendedor,
    String? deposito,
    String? activo,
    String? serial,
    double? preciofact,
    double? preciodif,
    double? subtotal2,
    String? usuario,
    String? pos,
    String? nrozeta,
    String? maquinanro,
    String? codeEmp,
    double? subtotalt,
    String? fracc,
    double? preciobase,
    double? precioiva,
    double? unidad,
    double? pieza,
    String? server,
    String? ntarjeta,
    double? costoR,
    int? dias,
    double? costoOp,
    String? lote,
    String? subgrupo,
    double? porcecomi,
    String? tipocomi,
    double? comision,
    String? tipoEmpaque,
    double? pesoequiv,
    double? totalpeso,
    double? totaldescontar,
    double? porcdescuento,
    double? priceDolar,
    double? priceCop,
    double? subtotalDolar,
    double? subtotalCop,
    double? costoDolar,
    double? costoCop,
    String? NomImag,
  }) {
    return ModeloVentaProducto(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      rif: rif ?? this.rif,
      documento: documento ?? this.documento,
      codigoa: codigoa ?? this.codigoa,
      codigob: codigob ?? this.codigob,
      detalle1: detalle1 ?? this.detalle1,
      detalle2: detalle2 ?? this.detalle2,
      imp: imp ?? this.imp,
      cantidad: cantidad ?? this.cantidad,
      costoA: costoA ?? this.costoA,
      precio: precio ?? this.precio,
      subtotal: subtotal ?? this.subtotal,
      nrofiscal: nrofiscal ?? this.nrofiscal,
      nrodocreg: nrodocreg ?? this.nrodocreg,
      numgeneral: numgeneral ?? this.numgeneral,
      vendedor: vendedor ?? this.vendedor,
      deposito: deposito ?? this.deposito,
      activo: activo ?? this.activo,
      serial: serial ?? this.serial,
      preciofact: preciofact ?? this.preciofact,
      preciodif: preciodif ?? this.preciodif,
      subtotal2: subtotal2 ?? this.subtotal2,
      usuario: usuario ?? this.usuario,
      pos: pos ?? this.pos,
      nrozeta: nrozeta ?? this.nrozeta,
      maquinanro: maquinanro ?? this.maquinanro,
      codeEmp: codeEmp ?? this.codeEmp,
      subtotalt: subtotalt ?? this.subtotalt,
      fracc: fracc ?? this.fracc,
      preciobase: preciobase ?? this.preciobase,
      precioiva: precioiva ?? this.precioiva,
      unidad: unidad ?? this.unidad,
      pieza: pieza ?? this.pieza,
      server: server ?? this.server,
      ntarjeta: ntarjeta ?? this.ntarjeta,
      costoR: costoR ?? this.costoR,
      dias: dias ?? this.dias,
      costoOp: costoOp ?? this.costoOp,
      lote: lote ?? this.lote,
      subgrupo: subgrupo ?? this.subgrupo,
      porcecomi: porcecomi ?? this.porcecomi,
      tipocomi: tipocomi ?? this.tipocomi,
      comision: comision ?? this.comision,
      tipoEmpaque: tipoEmpaque ?? this.tipoEmpaque,
      pesoequiv: pesoequiv ?? this.pesoequiv,
      totalpeso: totalpeso ?? this.totalpeso,
      totaldescontar: totaldescontar ?? this.totaldescontar,
      porcdescuento: porcdescuento ?? this.porcdescuento,
      priceDolar: priceDolar ?? this.priceDolar,
      priceCop: priceCop ?? this.priceCop,
      subtotalDolar: subtotalDolar ?? this.subtotalDolar,
      subtotalCop: subtotalCop ?? this.subtotalCop,
      costoDolar: costoDolar ?? this.costoDolar,
      costoCop: costoCop ?? this.costoCop,
      NomImag: NomImag ?? this.NomImag,
    );
  }

  Map<String, dynamic> toJson() => toMap();
}
