import 'package:star_mesas_app/app/config/constantes.dart';
import 'package:star_mesas_app/app/models/modeloVentaProducto.dart';

class ModeloFactura {
  final int id;
  final String fecha;
  final String rif;
  final String nomb;
  final String documento;
  final String numgeneral;
  final String numcontrol;
  final String fechageneral;
  final String fechadecl;
  final String numFAC;
  final String numNC;
  final String numND;
  final String numafect;
  final String numafectND;
  final String fechaafect;
  final String nrofiscal;
  final String nrodocreg;
  final String tipo;
  final double total;
  final double exento;
  final double subtotal1;
  final double impuesto1;
  final double subtotal2;
  final double impuesto2;
  final double subtotal3;
  final double impuesto3;
  final double subtotal4;
  final double impuesto4;
  final String activo;
  final String vendedor;
  final double efectivo;
  final double transvarias;
  final double tickets;
  final double credito;
  final String historico;
  final String contri;
  final String usuario;
  final String pos;
  final String nrozeta;
  final String maquinanro;
  final String codeEmp;
  final double excedente;
  final String dir1;
  final String horaNC;
  final String observacioncli;
  final String server;
  final String ntarjeta;
  final String nvendedor;
  final String transportista;
  final String vehiculo;
  final String conductor;
  final String placa;
  final String citransp;
  final String licenlic;
  final String fechavence;
  final String nroMesa;
  final int dias;
  final double porcecomi;
  final String tipocomi;
  final double comision;
  final String estatuscomi;
  final String planillacomi;
  final String fechaenvio;
  final String guiadespacho;
  final double valordolares;
  final double dolares;
  final double valorpesos;
  final double pesos;
  final double efectivoCop;
  final double efectivoDolar;
  final double efectivoCopConcil;
  final double efectivoDolarConcil;
  final double baseIGTFDolar;
  final double igtfDolar;
  final double baseIGTFCop;
  final double igtfCop;
  final double porcIGTF;
  final double igtfDolarBs;
  final double igtfCopBs;
  final double totBaseIGTFBs;
  final double totIGTFBs;
  final double bioPago;
  final double cashea;
  final double casheaBs;
  final String casheaRef;
  final String nroCompCash;
  final String origen;
  final String numPedido;
  final List<ModeloVentaProducto> productos;

  ModeloFactura({
    this.id = 0,
    this.fecha = '',
    this.rif = '',
    this.nomb = '',
    this.documento = '',
    this.numgeneral = '',
    this.numcontrol = '',
    this.fechageneral = '',
    this.fechadecl = '',
    this.numFAC = '',
    this.numNC = '',
    this.numND = '',
    this.numafect = '',
    this.numafectND = '',
    this.fechaafect = '',
    this.nrofiscal = '',
    this.nrodocreg = '',
    this.tipo = '',
    this.total = 0.0,
    this.exento = 0.0,
    this.subtotal1 = 0.0,
    this.impuesto1 = 0.0,
    this.subtotal2 = 0.0,
    this.impuesto2 = 0.0,
    this.subtotal3 = 0.0,
    this.impuesto3 = 0.0,
    this.subtotal4 = 0.0,
    this.impuesto4 = 0.0,
    this.activo = '',
    this.vendedor = '',
    this.efectivo = 0.0,
    this.transvarias = 0.0,
    this.tickets = 0.0,
    this.credito = 0.0,
    this.historico = '',
    this.contri = '',
    this.usuario = '',
    this.pos = '',
    this.nrozeta = '',
    this.maquinanro = '',
    this.codeEmp = '',
    this.excedente = 0.0,
    this.dir1 = '',
    this.horaNC = '',
    this.observacioncli = '',
    this.server = '',
    this.ntarjeta = '',
    this.nvendedor = '',
    this.transportista = '',
    this.vehiculo = '',
    this.conductor = '',
    this.placa = '',
    this.citransp = '',
    this.licenlic = '',
    this.fechavence = '',
    this.nroMesa = '',
    this.dias = 0,
    this.porcecomi = 0.0,
    this.tipocomi = '',
    this.comision = 0.0,
    this.estatuscomi = 'Pendiente',
    this.planillacomi = '',
    this.fechaenvio = '',
    this.guiadespacho = '',
    this.valordolares = 0.0,
    this.dolares = 0.0,
    this.valorpesos = 0.0,
    this.pesos = 0.0,
    this.efectivoCop = 0.0,
    this.efectivoDolar = 0.0,
    this.efectivoCopConcil = 0.0,
    this.efectivoDolarConcil = 0.0,
    this.baseIGTFDolar = 0.0,
    this.igtfDolar = 0.0,
    this.baseIGTFCop = 0.0,
    this.igtfCop = 0.0,
    this.porcIGTF = 0.0,
    this.igtfDolarBs = 0.0,
    this.igtfCopBs = 0.0,
    this.totBaseIGTFBs = 0.0,
    this.totIGTFBs = 0.0,
    this.bioPago = 0.0,
    this.cashea = 0.0,
    this.casheaBs = 0.0,
    this.casheaRef = '',
    this.nroCompCash = '',
    this.origen = '',
    this.numPedido = '',
    this.productos = const [],
  });

  /// Constructor vacío por defecto
  factory ModeloFactura.empty() {
    return ModeloFactura();
  }

  /// Construye un ModeloFactura desde un Map (respuesta DB o JSON).
  factory ModeloFactura.fromMap(Map<String, dynamic> m) {
    return ModeloFactura(
      id: parseInt(m['id']),
      fecha: m['fecha']?.toString() ?? '',
      rif: m['rif']?.toString() ?? '',
      nomb: m['nomb']?.toString() ?? '',
      documento: m['documento']?.toString() ?? '',
      numgeneral: m['numgeneral']?.toString() ?? '',
      numcontrol: m['numcontrol']?.toString() ?? '',
      fechageneral: m['fechageneral']?.toString() ?? '',
      fechadecl: m['fechadecl']?.toString() ?? '',
      numFAC: m['numFAC']?.toString() ?? '',
      numNC: m['numNC']?.toString() ?? '',
      numND: m['numND']?.toString() ?? '',
      numafect: m['numafect']?.toString() ?? '',
      numafectND: m['numafectND']?.toString() ?? '',
      fechaafect: m['fechaafect']?.toString() ?? '',
      nrofiscal: m['nrofiscal']?.toString() ?? '',
      nrodocreg: m['nrodocreg']?.toString() ?? '',
      tipo: m['tipo']?.toString() ?? '',
      total: parseValue(m['total']),
      exento: parseValue(m['exento']),
      subtotal1: parseValue(m['subtotal1']),
      impuesto1: parseValue(m['impuesto1']),
      subtotal2: parseValue(m['subtotal2']),
      impuesto2: parseValue(m['impuesto2']),
      subtotal3: parseValue(m['subtotal3']),
      impuesto3: parseValue(m['impuesto3']),
      subtotal4: parseValue(m['subtotal4']),
      impuesto4: parseValue(m['impuesto4']),
      activo: m['activo']?.toString() ?? '',
      vendedor: m['vendedor']?.toString() ?? '',
      efectivo: parseValue(m['efectivo']),
      transvarias: parseValue(m['transvarias']),
      tickets: parseValue(m['tickets']),
      credito: parseValue(m['credito']),
      historico: m['historico']?.toString() ?? '',
      contri: m['contri']?.toString() ?? '',
      usuario: m['usuario']?.toString() ?? '',
      pos: m['pos']?.toString() ?? '',
      nrozeta: m['nrozeta']?.toString() ?? '',
      maquinanro: m['maquinanro']?.toString() ?? '',
      codeEmp: m['code_emp']?.toString() ?? m['codeEmp']?.toString() ?? '',
      excedente: parseValue(m['excedente']),
      dir1: m['dir1']?.toString() ?? '',
      horaNC: m['horaNC']?.toString() ?? '',
      observacioncli: m['observacioncli']?.toString() ?? '',
      server: m['server']?.toString() ?? '',
      ntarjeta: m['ntarjeta']?.toString() ?? '',
      nvendedor: m['nvendedor']?.toString() ?? '',
      transportista: m['transportista']?.toString() ?? '',
      vehiculo: m['vehiculo']?.toString() ?? '',
      conductor: m['conductor']?.toString() ?? '',
      placa: m['placa']?.toString() ?? '',
      citransp: m['citransp']?.toString() ?? '',
      licenlic: m['licenlic']?.toString() ?? '',
      fechavence: m['fechavence']?.toString() ?? '',
      nroMesa: m['nroMesa']?.toString() ?? '',
      dias: parseInt(m['dias']),
      porcecomi: parseValue(m['porcecomi']),
      tipocomi: m['tipocomi']?.toString() ?? '',
      comision: parseValue(m['comision']),
      estatuscomi: m['estatuscomi']?.toString() ?? 'Pendiente',
      planillacomi: m['planillacomi']?.toString() ?? '',
      fechaenvio: m['fechaenvio']?.toString() ?? '',
      guiadespacho: m['guiadespacho']?.toString() ?? '',
      valordolares: parseValue(m['valordolares']),
      dolares: parseValue(m['dolares']),
      valorpesos: parseValue(m['valorpesos']),
      pesos: parseValue(m['pesos']),
      efectivoCop: parseValue(m['efectivo_cop'] ?? m['efectivoCop']),
      efectivoDolar: parseValue(m['efectivo_dolar'] ?? m['efectivoDolar']),
      efectivoCopConcil: parseValue(
        m['efectivo_cop_concil'] ?? m['efectivoCopConcil'],
      ),
      efectivoDolarConcil: parseValue(
        m['efectivo_dolar_concil'] ?? m['efectivoDolarConcil'],
      ),
      baseIGTFDolar: parseValue(m['BaseIGTFDolar'] ?? m['baseIGTFDolar']),
      igtfDolar: parseValue(m['IGTFDolar'] ?? m['igtfDolar']),
      baseIGTFCop: parseValue(m['BaseIGTFCop'] ?? m['baseIGTFCop']),
      igtfCop: parseValue(m['IGTFCop'] ?? m['igtfCop']),
      porcIGTF: parseValue(m['PorcIGTF'] ?? m['porcIGTF']),
      igtfDolarBs: parseValue(m['IGTFDolarBs'] ?? m['igtfDolarBs']),
      igtfCopBs: parseValue(m['IGTFCopBs'] ?? m['igtfCopBs']),
      totBaseIGTFBs: parseValue(m['TotBaseIGTFBs'] ?? m['totBaseIGTFBs']),
      totIGTFBs: parseValue(m['TotIGTFBs'] ?? m['totIGTFBs']),
      bioPago: parseValue(m['BioPago'] ?? m['bioPago']),
      cashea: parseValue(m['Cashea'] ?? m['cashea']),
      casheaBs: parseValue(m['CasheaBs'] ?? m['casheaBs']),
      casheaRef: m['CasheaRef']?.toString() ?? m['casheaRef']?.toString() ?? '',
      nroCompCash:
          m['nroCompCash']?.toString() ?? m['NroCompCash']?.toString() ?? '',
      origen: m['origen']?.toString() ?? '',
      numPedido: m['numPedido']?.toString() ?? m['numPedido']?.toString() ?? '',
      productos:
          (m['productos'] as List<dynamic>?)
              ?.map(
                (e) => ModeloVentaProducto.fromMap(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha,
      'rif': rif,
      'nomb': nomb,
      'documento': documento,
      'numgeneral': numgeneral,
      'numcontrol': numcontrol,
      'fechageneral': fechageneral,
      'fechadecl': fechadecl,
      'numFAC': numFAC,
      'numNC': numNC,
      'numND': numND,
      'numafect': numafect,
      'numafectND': numafectND,
      'fechaafect': fechaafect,
      'nrofiscal': nrofiscal,
      'nrodocreg': nrodocreg,
      'tipo': tipo,
      'total': total,
      'exento': exento,
      'subtotal1': subtotal1,
      'impuesto1': impuesto1,
      'subtotal2': subtotal2,
      'impuesto2': impuesto2,
      'subtotal3': subtotal3,
      'impuesto3': impuesto3,
      'subtotal4': subtotal4,
      'impuesto4': impuesto4,
      'activo': activo,
      'vendedor': vendedor,
      'efectivo': efectivo,
      'transvarias': transvarias,
      'tickets': tickets,
      'credito': credito,
      'historico': historico,
      'contri': contri,
      'usuario': usuario,
      'pos': pos,
      'nrozeta': nrozeta,
      'maquinanro': maquinanro,
      'code_emp': codeEmp,
      'excedente': excedente,
      'dir1': dir1,
      'horaNC': horaNC,
      'observacioncli': observacioncli,
      'server': server,
      'ntarjeta': ntarjeta,
      'nvendedor': nvendedor,
      'transportista': transportista,
      'vehiculo': vehiculo,
      'conductor': conductor,
      'placa': placa,
      'citransp': citransp,
      'licenlic': licenlic,
      'fechavence': fechavence,
      'nroMesa': nroMesa,
      'dias': dias,
      'porcecomi': porcecomi,
      'tipocomi': tipocomi,
      'comision': comision,
      'estatuscomi': estatuscomi,
      'planillacomi': planillacomi,
      'fechaenvio': fechaenvio,
      'guiadespacho': guiadespacho,
      'valordolares': valordolares,
      'dolares': dolares,
      'valorpesos': valorpesos,
      'pesos': pesos,
      'efectivo_cop': efectivoCop,
      'efectivo_dolar': efectivoDolar,
      'efectivo_cop_concil': efectivoCopConcil,
      'efectivo_dolar_concil': efectivoDolarConcil,
      'BaseIGTFDolar': baseIGTFDolar,
      'IGTFDolar': igtfDolar,
      'BaseIGTFCop': baseIGTFCop,
      'IGTFCop': igtfCop,
      'PorcIGTF': porcIGTF,
      'IGTFDolarBs': igtfDolarBs,
      'IGTFCopBs': igtfCopBs,
      'TotBaseIGTFBs': totBaseIGTFBs,
      'TotIGTFBs': totIGTFBs,
      'BioPago': bioPago,
      'Cashea': cashea,
      'CasheaBs': casheaBs,
      'CasheaRef': casheaRef,
      'nroCompCash': nroCompCash,
      'origen': origen,
      'numPedido': numPedido,
      'productos': productos.map((e) => e.toJson()).toList(),
    };
  }

  Map<String, dynamic> toJson() => toMap();
}

/// Alias para compatibilidad con código existente que pueda importar ModeloFacEspera desde modeloFactura.dart
typedef ModeloFacEspera = ModeloFactura;
