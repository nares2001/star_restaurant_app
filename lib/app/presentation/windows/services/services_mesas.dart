import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_client_plus/mysql_client_plus.dart';
import 'package:star_mesas_app/app/config/database/mysql.dart';
import 'package:star_mesas_app/app/config/preferences/datosEmpresa.dart';
import 'package:star_mesas_app/app/models/modeloFactura.dart';
import 'package:star_mesas_app/app/models/modeloProducto.dart';
import 'package:star_mesas_app/app/models/modeloVentaProducto.dart';
import '../models/mesa_model.dart';

class ServicesMesas {
  final MySQLConnectionPool? _conexion;

  ServicesMesas(this._conexion);

  String get _codeEmp => DatosEmpresa().rifEmp;

  // ---------------------------------------------------------------------------
  // 1. OBTENER ZONAS ACTIVAS (star_rest_zonas)
  // ---------------------------------------------------------------------------
  Future<List<ZonaRestaurante>> obtenerZonas() async {
    if (_conexion == null) return [];

    try {
      const sql = """
        SELECT id, codigo, nombre, color_hex 
        FROM star_rest_zonas 
        WHERE code_emp = :code_emp AND activo = '1' 
        ORDER BY orden ASC, nombre ASC
      """;
      final result = await _conexion.execute(sql, {'code_emp': _codeEmp});

      return result.rows.map((row) {
        return ZonaRestaurante.fromMap(row.assoc());
      }).toList();
    } catch (_) {
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // 2. OBTENER MESAS Y COMANDAS ACTIVAS EN `ventaf` Y `venta`
  // ---------------------------------------------------------------------------
  Future<List<MesaModel>> obtenerMesas() async {
    if (_conexion == null) return [];

    try {
      const sql = """
        SELECT 
          m.id AS id_mesa,
          m.codigo_mesa,
          m.nombre_mesa,
          m.capacidad,
          m.estado,
          z.nombre AS nombre_zona,
          m.nrodocreg_actual,
          m.numPedido_actual,
          f.id AS ventaf_id,
          f.vendedor AS nombre_mesero,
          f.fecha AS fecha_apertura,
          TIMESTAMPDIFF(MINUTE, f.fecha, NOW()) AS minutos_transcurridos,
          f.dolares AS total_dolar,
          f.total AS total_bs
        FROM star_rest_mesas m
        INNER JOIN star_rest_zonas z ON m.id_zona = z.id AND m.code_emp = z.code_emp
        LEFT JOIN ventaf f ON m.code_emp = f.code_emp 
                          AND m.nombre_mesa = f.nroMesa 
                          AND f.documento = 'PEDIDO' 
                          AND f.activo = '1'
        WHERE m.code_emp = :code_emp AND m.activo = '1'
        ORDER BY z.orden ASC, m.id ASC
      """;

      final result = await _conexion.execute(sql, {'code_emp': _codeEmp});
      final List<MesaModel> lista = [];

      for (final row in result.rows) {
        final map = row.assoc();
        final nrodocreg = map['nrodocreg_actual'];
        List<ModeloVentaProducto> orden = [];
        ModeloFactura? factura;

        if (nrodocreg != null && nrodocreg.toString().isNotEmpty) {
          orden = await obtenerDetallesComanda(nrodocreg.toString());
          factura = await obtenerCabeceraComanda(nrodocreg.toString());
        }

        lista.add(MesaModel.fromMap(
          map,
          factura: factura,
          orden: orden,
        ));
      }

      return lista;
    } catch (_) {
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // 3. OBTENER RENGLONES DE LA COMANDA DESDE TABLA `venta`
  // ---------------------------------------------------------------------------
  Future<List<ModeloVentaProducto>> obtenerDetallesComanda(String nrodocreg) async {
    if (_conexion == null) return [];

    try {
      const sql = """
        SELECT v.*, p.NomImag 
        FROM venta v
        LEFT JOIN productos p ON v.codigoa = p.codigoa AND v.code_emp = p.code_emp
        WHERE v.code_emp = :code_emp 
          AND v.nrodocreg = :nrodocreg 
          AND v.documento = 'PEDIDO' 
          AND v.activo = '1'
        ORDER BY v.id ASC
      """;

      final result = await _conexion.execute(sql, {
        'code_emp': _codeEmp,
        'nrodocreg': nrodocreg,
      });

      return result.rows.map((row) {
        return ModeloVentaProducto.fromMap(row.assoc());
      }).toList();
    } catch (_) {
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // 4. OBTENER CABECERA DE LA COMANDA DESDE TABLA `ventaf`
  // ---------------------------------------------------------------------------
  Future<ModeloFactura?> obtenerCabeceraComanda(String nrodocreg) async {
    if (_conexion == null) return null;

    try {
      const sql = """
        SELECT * 
        FROM ventaf 
        WHERE code_emp = :code_emp 
          AND nrodocreg = :nrodocreg 
          AND documento = 'PEDIDO' 
          AND activo = '1' 
        LIMIT 1
      """;
      final result = await _conexion.execute(sql, {
        'code_emp': _codeEmp,
        'nrodocreg': nrodocreg,
      });

      if (result.rows.isNotEmpty) {
        return ModeloFactura.fromMap(result.rows.first.assoc());
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // 5. ABRIR MESA: INSERTA CABECERA EN `ventaf` Y ACTUALIZA `star_rest_mesas`
  // ---------------------------------------------------------------------------
  Future<bool> abrirMesa({
    required String nombreMesa,
    required String vendedor,
    required String usuario,
    required String pos,
    String numPedido = '1',
  }) async {
    if (_conexion == null) return false;

    try {
      final nrodocreg = "REG-${DateTime.now().millisecondsSinceEpoch % 100000000}";

      // 1. Insertar cabecera de comanda en `ventaf`
      const sqlVentaf = """
        INSERT INTO ventaf (
          code_emp, documento, nroMesa, numPedido, nrodocreg, vendedor, usuario, pos,
          fecha, total, subtotal1, dolares, valordolares, activo, nomb, rif
        ) VALUES (
          :code_emp, 'PEDIDO', :nroMesa, :numPedido, :nrodocreg, :vendedor, :usuario, :pos,
          NOW(), 0.0000, 0.0000, 0.0000, 0.0000, '1', 'CONSUMIDOR FINAL', 'V-00000000-0'
        )
      """;

      await _conexion.execute(sqlVentaf, {
        'code_emp': _codeEmp,
        'nroMesa': nombreMesa,
        'numPedido': numPedido,
        'nrodocreg': nrodocreg,
        'vendedor': vendedor,
        'usuario': usuario,
        'pos': pos,
      });

      // 2. Actualizar estado de mesa en `star_rest_mesas`
      const sqlMesa = """
        UPDATE star_rest_mesas SET 
          estado = 'ocupada',
          nrodocreg_actual = :nrodocreg,
          numPedido_actual = :numPedido,
          vendedor_actual = :vendedor,
          fecha_apertura = NOW()
        WHERE code_emp = :code_emp AND nombre_mesa = :nroMesa
      """;

      await _conexion.execute(sqlMesa, {
        'code_emp': _codeEmp,
        'nrodocreg': nrodocreg,
        'numPedido': numPedido,
        'vendedor': vendedor,
        'nroMesa': nombreMesa,
      });

      return true;
    } catch (_) {
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // 6. LIBERAR MESA TRAS PAGO (ACTUALIZA `ventaf` Y LIBERA `star_rest_mesas`)
  // ---------------------------------------------------------------------------
  Future<bool> liberarMesa({
    required String nombreMesa,
  }) async {
    if (_conexion == null) return false;

    try {
      // 1. Marcar como procesada/cerrada en ventaf
      await _conexion.execute("""
        UPDATE ventaf SET 
          activo = '0',
          updated_at = NOW()
        WHERE code_emp = :code_emp 
          AND nroMesa = :nroMesa 
          AND documento = 'PEDIDO' 
          AND activo = '1'
      """, {
        'code_emp': _codeEmp,
        'nroMesa': nombreMesa,
      });

      // 2. Liberar la mesa
      await _conexion.execute("""
        UPDATE star_rest_mesas SET 
          estado = 'disponible',
          nrodocreg_actual = '',
          numPedido_actual = '',
          vendedor_actual = '',
          fecha_apertura = NULL
        WHERE code_emp = :code_emp AND nombre_mesa = :nroMesa
      """, {
        'code_emp': _codeEmp,
        'nroMesa': nombreMesa,
      });

      return true;
    } catch (_) {
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // 7. OBTENER CATÁLOGO DE PRODUCTOS / PLATOS (productos)
  // ---------------------------------------------------------------------------
  Future<List<ModeloProductoVenta>> obtenerProductos() async {
    if (_conexion == null) return [];

    try {
      const sql = """
        SELECT * 
        FROM productos 
        WHERE code_emp = :code_emp 
        ORDER BY detalle1 ASC
      """;
      final result = await _conexion.execute(sql, {'code_emp': _codeEmp});

      return result.rows.map((row) {
        return ModeloProductoVenta.fromMap(row.assoc());
      }).toList();
    } catch (_) {
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // 8. AGREGAR O INCREMENTAR PRODUCTO EN COMANDA (`venta`)
  // ---------------------------------------------------------------------------
  Future<bool> agregarOIncrementarProducto({
    required String nrodocreg,
    required ModeloProductoVenta producto,
    double cantidad = 1.0,
    required String vendedor,
    required String usuario,
    required String pos,
  }) async {
    if (_conexion == null) return false;

    try {
      final checkSql = """
        SELECT id, cantidad, subtotal, subtotal_dolar 
        FROM venta 
        WHERE code_emp = :code_emp 
          AND nrodocreg = :nrodocreg 
          AND codigoa = :codigoa 
          AND documento = 'PEDIDO' 
          AND activo = '1' 
        LIMIT 1
      """;
      final res = await _conexion.execute(checkSql, {
        'code_emp': _codeEmp,
        'nrodocreg': nrodocreg,
        'codigoa': producto.codigoa,
      });

      if (res.rows.isNotEmpty) {
        final row = res.rows.first.assoc();
        final idVenta = row['id'];
        final cantActual = double.tryParse(row['cantidad']?.toString() ?? '1') ?? 1.0;
        final nuevaCant = cantActual + cantidad;
        final nuevoSubtotal = nuevaCant * producto.priceA;
        final nuevoSubtotalDolar = nuevaCant * producto.priceDolar;

        await _conexion.execute("""
          UPDATE venta SET 
            cantidad = :cant,
            subtotal = :sub,
            subtotal_dolar = :subD
          WHERE code_emp = :code_emp AND id = :id
        """, {
          'code_emp': _codeEmp,
          'id': idVenta,
          'cant': nuevaCant,
          'sub': nuevoSubtotal,
          'subD': nuevoSubtotalDolar,
        });
      } else {
        final subtotal = cantidad * producto.priceA;
        final subtotalDolar = cantidad * producto.priceDolar;

        await _conexion.execute("""
          INSERT INTO venta (
            code_emp, documento, nrodocreg, codigoa, detalle1, cantidad,
            precio, subtotal, price_dolar, subtotal_dolar, fecha,
            vendedor, usuario, pos, activo
          ) VALUES (
            :code_emp, 'PEDIDO', :nrodocreg, :codigoa, :detalle1, :cant,
            :precio, :sub, :priceD, :subD, CURDATE(),
            :vendedor, :usuario, :pos, '1'
          )
        """, {
          'code_emp': _codeEmp,
          'nrodocreg': nrodocreg,
          'codigoa': producto.codigoa,
          'detalle1': producto.detalle1,
          'cant': cantidad,
          'precio': producto.priceA,
          'sub': subtotal,
          'priceD': producto.priceDolar,
          'subD': subtotalDolar,
          'vendedor': vendedor,
          'usuario': usuario,
          'pos': pos,
        });
      }

      await _actualizarTotalesVentaf(nrodocreg);
      return true;
    } catch (_) {
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // 9. MODIFICAR O ELIMINAR CANTIDAD DE UN ÍTEM EN LA COMANDA
  // ---------------------------------------------------------------------------
  Future<bool> modificarCantidadItem({
    required String nrodocreg,
    required String codigoa,
    required double delta,
  }) async {
    if (_conexion == null) return false;

    try {
      final res = await _conexion.execute("""
        SELECT id, cantidad, precio, price_dolar 
        FROM venta 
        WHERE code_emp = :code_emp 
          AND nrodocreg = :nrodocreg 
          AND codigoa = :codigoa 
          AND documento = 'PEDIDO' 
          AND activo = '1' 
        LIMIT 1
      """, {
        'code_emp': _codeEmp,
        'nrodocreg': nrodocreg,
        'codigoa': codigoa,
      });

      if (res.rows.isEmpty) return false;
      final row = res.rows.first.assoc();
      final idVenta = row['id'];
      final cantActual = double.tryParse(row['cantidad']?.toString() ?? '1') ?? 1.0;
      final precio = double.tryParse(row['precio']?.toString() ?? '0') ?? 0.0;
      final priceDolar = double.tryParse(row['price_dolar']?.toString() ?? '0') ?? 0.0;
      final nuevaCant = cantActual + delta;

      if (nuevaCant <= 0) {
        await _conexion.execute("""
          DELETE FROM venta 
          WHERE code_emp = :code_emp AND id = :id
        """, {'code_emp': _codeEmp, 'id': idVenta});
      } else {
        await _conexion.execute("""
          UPDATE venta SET 
            cantidad = :cant,
            subtotal = :sub,
            subtotal_dolar = :subD
          WHERE code_emp = :code_emp AND id = :id
        """, {
          'code_emp': _codeEmp,
          'id': idVenta,
          'cant': nuevaCant,
          'sub': nuevaCant * precio,
          'subD': nuevaCant * priceDolar,
        });
      }

      await _actualizarTotalesVentaf(nrodocreg);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _actualizarTotalesVentaf(String nrodocreg) async {
    try {
      await _conexion?.execute("""
        UPDATE ventaf f SET 
          dolares = (
            SELECT COALESCE(SUM(subtotal_dolar), 0) 
            FROM venta v 
            WHERE v.code_emp = f.code_emp AND v.nrodocreg = f.nrodocreg AND v.activo = '1'
          ),
          total = (
            SELECT COALESCE(SUM(subtotal), 0) 
            FROM venta v 
            WHERE v.code_emp = f.code_emp AND v.nrodocreg = f.nrodocreg AND v.activo = '1'
          )
        WHERE f.code_emp = :code_emp AND f.nrodocreg = :nrodocreg
      """, {'code_emp': _codeEmp, 'nrodocreg': nrodocreg});
    } catch (_) {}
  }
}

final servicesMesasProvider = Provider<ServicesMesas>((ref) {
  final conn = ref.watch(mysqlProvider);
  return ServicesMesas(conn);
});
