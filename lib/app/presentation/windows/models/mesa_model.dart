import 'package:star_mesas_app/app/models/modeloFactura.dart';
import 'package:star_mesas_app/app/models/modeloVentaProducto.dart';

enum EstadoMesa { disponible, ocupada, reservada, enCuenta }

class MesaModel {
  final String id;
  final String numero; // Mapea con ventaf.nroMesa y star_rest_mesas.nombre_mesa
  final String zona;
  final EstadoMesa estado;
  final String tiempo; // e.g. "02:40", "15:20"
  final int capacidad;
  final String? mesero;
  final String? nrodocreg; // Mapea con ventaf.nrodocreg y venta.nrodocreg
  final String? numPedido; // Mapea con ventaf.numPedido
  final ModeloFactura? factura;
  final List<ModeloVentaProducto> orden;

  const MesaModel({
    required this.id,
    required this.numero,
    required this.zona,
    required this.estado,
    required this.tiempo,
    this.capacidad = 4,
    this.mesero,
    this.nrodocreg,
    this.numPedido,
    this.factura,
    this.orden = const [],
  });

  bool get isOcupada =>
      estado == EstadoMesa.ocupada || estado == EstadoMesa.enCuenta;

  /// Subtotal en dólares según ModeloVentaProducto / ModeloFactura
  double get subtotal {
    if (orden.isNotEmpty) {
      return orden.fold(
        0.0,
        (sum, item) =>
            sum + (item.subtotalDolar > 0 ? item.subtotalDolar : item.subtotal),
      );
    }
    if (factura != null && factura!.dolares > 0) {
      return factura!.dolares;
    }
    return 0.0;
  }

  double get impuestos => factura?.impuesto1 ?? 0.0;

  double get total => subtotal + impuestos;

  factory MesaModel.fromMap(
    Map<String, dynamic> map, {
    ModeloFactura? factura,
    List<ModeloVentaProducto> orden = const [],
  }) {
    final estadoStr = (map['estado']?.toString() ?? 'disponible').toLowerCase();
    EstadoMesa estado = EstadoMesa.disponible;
    if (estadoStr == 'ocupada') {
      estado = EstadoMesa.ocupada;
    } else if (estadoStr == 'en_cuenta') {
      estado = EstadoMesa.enCuenta;
    } else if (estadoStr == 'reservada') {
      estado = EstadoMesa.reservada;
    }

    String tiempoFormateado = '00:00';
    final minutos = int.tryParse(
      map['minutos_transcurridos']?.toString() ?? '',
    );
    if (minutos != null) {
      final horas = minutos ~/ 60;
      final mins = minutos % 60;
      tiempoFormateado =
          "${horas.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}";
    }

    return MesaModel(
      id: map['id_mesa']?.toString() ?? map['id']?.toString() ?? '',
      numero:
          map['nombre_mesa']?.toString() ??
          map['nroMesa']?.toString() ??
          map['codigo_mesa']?.toString() ??
          '',
      zona:
          map['nombre_zona']?.toString() ?? map['zona']?.toString() ?? 'SALÓN',
      estado: estado,
      tiempo: map['tiempo']?.toString() ?? tiempoFormateado,
      capacidad: int.tryParse(map['capacidad']?.toString() ?? '4') ?? 4,
      mesero: map['nombre_mesero']?.toString() ?? map['vendedor']?.toString(),
      nrodocreg: map['nrodocreg']?.toString(),
      numPedido: map['numPedido']?.toString(),
      factura: factura,
      orden: orden,
    );
  }

  MesaModel copyWith({
    String? id,
    String? numero,
    String? zona,
    EstadoMesa? estado,
    String? tiempo,
    int? capacidad,
    String? mesero,
    String? nrodocreg,
    String? numPedido,
    ModeloFactura? factura,
    List<ModeloVentaProducto>? orden,
  }) {
    return MesaModel(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      zona: zona ?? this.zona,
      estado: estado ?? this.estado,
      tiempo: tiempo ?? this.tiempo,
      capacidad: capacidad ?? this.capacidad,
      mesero: mesero ?? this.mesero,
      nrodocreg: nrodocreg ?? this.nrodocreg,
      numPedido: numPedido ?? this.numPedido,
      factura: factura ?? this.factura,
      orden: orden ?? this.orden,
    );
  }
}

class ZonaRestaurante {
  final String id;
  final String nombre;
  final String? colorHex;

  const ZonaRestaurante({
    required this.id,
    required this.nombre,
    this.colorHex,
  });

  factory ZonaRestaurante.fromMap(Map<String, dynamic> map) {
    return ZonaRestaurante(
      id:
          map['codigo']?.toString() ??
          map['id']?.toString() ??
          map['id_zona']?.toString() ??
          '',
      nombre: map['nombre']?.toString() ?? '',
      colorHex: map['color_hex']?.toString(),
    );
  }
}
