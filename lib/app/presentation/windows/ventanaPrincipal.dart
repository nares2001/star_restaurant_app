import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:star_mesas_app/app/components/alertas.dart';
import 'package:star_mesas_app/app/components/flushBar.dart';
import 'package:star_mesas_app/app/config/constantes.dart';
import 'package:star_mesas_app/app/config/provider/conexionProvider.dart';
import 'package:star_mesas_app/app/config/provider/providerDatosPos.dart';
import 'package:star_mesas_app/app/models/modeloFactura.dart';
import 'package:star_mesas_app/app/models/modeloProducto.dart';
import 'package:star_mesas_app/app/models/modeloVentaProducto.dart';

import 'models/mesa_model.dart';
import 'models/mock_data.dart';
import 'services/services_mesas.dart';
import 'widgets/catalogo_productos_dialog.dart';
import 'widgets/mesa_card_widget.dart';
import 'widgets/orden_sidebar_widget.dart';
import 'widgets/zona_selector_widget.dart';

class VentanaPrincipal extends ConsumerStatefulWidget {
  const VentanaPrincipal({super.key});

  @override
  ConsumerState<VentanaPrincipal> createState() => _VentanaPrincipalState();
}

class _VentanaPrincipalState extends ConsumerState<VentanaPrincipal> {
  late List<MesaModel> _mesas;
  List<ZonaRestaurante> _zonas = MockDataRestaurante.zonas;
  List<ModeloProductoVenta> _catalogoProductos =
      MockDataRestaurante.getCatalogoProductos();
  String _zonaSeleccionada = 'SALÓN';
  MesaModel? _mesaSeleccionada;
  late TextEditingController _searchController;
  String _filtroBusqueda = '';

  @override
  void initState() {
    super.initState();
    _mesas = MockDataRestaurante.getMesasIniciales();
    _searchController = TextEditingController();

    // Seleccionar la Mesa 1 por defecto (como en la captura)
    _mesaSeleccionada = _mesas.firstWhere(
      (m) => m.numero == 'MESA 1',
      orElse: () => _mesas.first,
    );

    // Intentar sincronizar datos reales de la BD MySQL
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatosBD();
    });
  }

  Future<void> _cargarDatosBD({bool mostrarMensaje = false}) async {
    try {
      final services = ref.read(servicesMesasProvider);
      final zonasDb = await services.obtenerZonas();
      final mesasDb = await services.obtenerMesas();
      final prodsDb = await services.obtenerProductos();

      if (!mounted) return;

      setState(() {
        if (zonasDb.isNotEmpty) {
          _zonas = zonasDb;
          if (!_zonas.any((z) => z.nombre == _zonaSeleccionada)) {
            _zonaSeleccionada = _zonas.first.nombre;
          }
        }
        if (mesasDb.isNotEmpty) {
          _mesas = mesasDb;
          if (_mesaSeleccionada != null) {
            _mesaSeleccionada = _mesas.firstWhere(
              (m) => m.id == _mesaSeleccionada!.id,
              orElse: () => _mesas.first,
            );
          }
        }
        if (prodsDb.isNotEmpty) {
          _catalogoProductos = prodsDb;
        }
      });

      if (mostrarMensaje && mounted) {
        InfoFlush.mostrarMensajeImportante(
          context,
          titulo: "Actualizado",
          mensaje: "Mesas y catálogo sincronizados desde la base de datos.",
        );
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MesaModel> get _mesasFiltradas {
    return _mesas.where((mesa) {
      final coincideZona =
          mesa.zona.toUpperCase() == _zonaSeleccionada.toUpperCase();
      if (!coincideZona) return false;

      if (_filtroBusqueda.isEmpty) return true;

      final query = _filtroBusqueda.toLowerCase();
      final coincideNumero = mesa.numero.toLowerCase().contains(query);
      final coincidePlatos = mesa.orden.any(
        (item) => item.detalle1.toLowerCase().contains(query),
      );

      return coincideNumero || coincidePlatos;
    }).toList();
  }

  void _seleccionarMesa(MesaModel mesa) {
    setState(() {
      _mesaSeleccionada = mesa;
    });
  }

  void _cambiarZona(String nuevaZona) {
    setState(() {
      _zonaSeleccionada = nuevaZona;
      // Mantener o ajustar selección según la nueva zona
      final mesasEnZona = _mesas.where(
        (m) => m.zona.toUpperCase() == nuevaZona.toUpperCase(),
      );
      if (mesasEnZona.isNotEmpty &&
          (_mesaSeleccionada == null || _mesaSeleccionada!.zona != nuevaZona)) {
        _mesaSeleccionada = mesasEnZona.first;
      }
    });
  }

  Future<void> _usarMesa(MesaModel mesa) async {
    final posData = ref.read(providerDatosPos);
    final mesero = posData.usuario.isNotEmpty ? posData.usuario : "Cajero 01";
    final nrodocreg =
        "REG-${DateTime.now().millisecondsSinceEpoch % 100000000}";

    final nuevaFactura = ModeloFactura(
      documento: 'PEDIDO',
      nroMesa: mesa.numero,
      nrodocreg: nrodocreg,
      vendedor: mesero,
      usuario: posData.usuario,
      pos: posData.estacion,
      fecha: DateTime.now().toString(),
      activo: '1',
    );

    final mesaOcupada = mesa.copyWith(
      estado: EstadoMesa.ocupada,
      tiempo: '00:01',
      mesero: mesero,
      nrodocreg: nrodocreg,
      factura: nuevaFactura,
      orden: [],
    );

    setState(() {
      final idx = _mesas.indexWhere((m) => m.id == mesa.id);
      if (idx != -1) {
        _mesas[idx] = mesaOcupada;
      }
      _mesaSeleccionada = mesaOcupada;
    });

    // Sincronizar apertura en BD
    try {
      await ref
          .read(servicesMesasProvider)
          .abrirMesa(
            nombreMesa: mesa.numero,
            vendedor: mesero,
            usuario: posData.usuario,
            pos: posData.estacion,
          );
    } catch (_) {}

    if (mounted) {
      InfoFlush.mostrarMensajeImportante(
        context,
        titulo: "Mesa Abierta",
        mensaje: "${mesa.numero} ha sido ocupada. Agrega los platos al pedido.",
        color: false,
      );
      // Abrir catálogo inmediatamente para agilidad del usuario
      _abrirDialogoCatalogo();
    }
  }

  void _abrirDialogoCatalogo() {
    if (_mesaSeleccionada == null) return;
    if (!_mesaSeleccionada!.isOcupada) {
      _usarMesa(_mesaSeleccionada!);
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CatalogoProductosDialog(
          mesa: _mesaSeleccionada!,
          productos: _catalogoProductos,
          onAgregarProducto: (producto) {
            _agregarProductoAOrden(producto);
          },
        );
      },
    );
  }

  void _agregarProductoAOrden(ModeloProductoVenta producto) {
    if (_mesaSeleccionada == null) return;

    final posData = ref.read(providerDatosPos);
    final ordenActual = List<ModeloVentaProducto>.from(
      _mesaSeleccionada!.orden,
    );
    final idxExistente = ordenActual.indexWhere(
      (item) => item.codigoa == producto.codigoa,
    );

    if (idxExistente != -1) {
      final item = ordenActual[idxExistente];
      final nuevaCantidad = item.cantidad + 1.0;
      ordenActual[idxExistente] = item.copyWith(
        cantidad: nuevaCantidad,
        subtotal: nuevaCantidad * item.precio,
        subtotalDolar: nuevaCantidad * item.priceDolar,
      );
    } else {
      final nuevoItem = ModeloVentaProducto(
        id: DateTime.now().millisecondsSinceEpoch % 1000000,
        codigoa: producto.codigoa,
        detalle1: producto.detalle1,
        cantidad: 1.0,
        precio: producto.priceA,
        subtotal: producto.priceA,
        priceDolar: producto.priceDolar,
        subtotalDolar: producto.priceDolar,
        documento: 'PEDIDO',
        nrodocreg:
            _mesaSeleccionada?.factura?.nrodocreg ??
            _mesaSeleccionada?.nrodocreg ??
            '',
        vendedor: _mesaSeleccionada?.mesero ?? posData.usuario,
        usuario: posData.usuario,
        pos: posData.estacion,
        deposito: producto.deposito,
        activo: '1',
        fecha: DateTime.now().toString().substring(0, 10),
        NomImag: producto.nomImag,
      );
      ordenActual.add(nuevoItem);
    }

    final mesaActualizada = _mesaSeleccionada!.copyWith(orden: ordenActual);

    setState(() {
      final idx = _mesas.indexWhere((m) => m.id == _mesaSeleccionada!.id);
      if (idx != -1) {
        _mesas[idx] = mesaActualizada;
      }
      _mesaSeleccionada = mesaActualizada;
    });

    final nrodocreg =
        _mesaSeleccionada?.factura?.nrodocreg ??
        _mesaSeleccionada?.nrodocreg ??
        '';
    if (nrodocreg.isNotEmpty) {
      ref
          .read(servicesMesasProvider)
          .agregarOIncrementarProducto(
            nrodocreg: nrodocreg,
            producto: producto,
            cantidad: 1.0,
            vendedor: _mesaSeleccionada?.mesero ?? posData.usuario,
            usuario: posData.usuario,
            pos: posData.estacion,
          );
    }
  }

  void _incrementarCantidadItem(ModeloVentaProducto item) {
    if (_mesaSeleccionada == null) return;

    final ordenActual = List<ModeloVentaProducto>.from(
      _mesaSeleccionada!.orden,
    );
    final idx = ordenActual.indexWhere((i) => i.codigoa == item.codigoa);
    if (idx == -1) return;

    final nuevaCantidad = item.cantidad + 1.0;
    ordenActual[idx] = item.copyWith(
      cantidad: nuevaCantidad,
      subtotal: nuevaCantidad * item.precio,
      subtotalDolar: nuevaCantidad * item.priceDolar,
    );

    final mesaActualizada = _mesaSeleccionada!.copyWith(orden: ordenActual);

    setState(() {
      final mIdx = _mesas.indexWhere((m) => m.id == _mesaSeleccionada!.id);
      if (mIdx != -1) {
        _mesas[mIdx] = mesaActualizada;
      }
      _mesaSeleccionada = mesaActualizada;
    });

    final nrodocreg = item.nrodocreg.isNotEmpty
        ? item.nrodocreg
        : (_mesaSeleccionada?.factura?.nrodocreg ??
              _mesaSeleccionada?.nrodocreg ??
              '');
    if (nrodocreg.isNotEmpty) {
      ref
          .read(servicesMesasProvider)
          .modificarCantidadItem(
            nrodocreg: nrodocreg,
            codigoa: item.codigoa,
            delta: 1.0,
          );
    }
  }

  void _decrementarCantidadItem(ModeloVentaProducto item) {
    if (_mesaSeleccionada == null) return;

    if (item.cantidad <= 1.0) {
      _eliminarItem(item);
      return;
    }

    final ordenActual = List<ModeloVentaProducto>.from(
      _mesaSeleccionada!.orden,
    );
    final idx = ordenActual.indexWhere((i) => i.codigoa == item.codigoa);
    if (idx == -1) return;

    final nuevaCantidad = item.cantidad - 1.0;
    ordenActual[idx] = item.copyWith(
      cantidad: nuevaCantidad,
      subtotal: nuevaCantidad * item.precio,
      subtotalDolar: nuevaCantidad * item.priceDolar,
    );

    final mesaActualizada = _mesaSeleccionada!.copyWith(orden: ordenActual);

    setState(() {
      final mIdx = _mesas.indexWhere((m) => m.id == _mesaSeleccionada!.id);
      if (mIdx != -1) {
        _mesas[mIdx] = mesaActualizada;
      }
      _mesaSeleccionada = mesaActualizada;
    });

    final nrodocreg = item.nrodocreg.isNotEmpty
        ? item.nrodocreg
        : (_mesaSeleccionada?.factura?.nrodocreg ??
              _mesaSeleccionada?.nrodocreg ??
              '');
    if (nrodocreg.isNotEmpty) {
      ref
          .read(servicesMesasProvider)
          .modificarCantidadItem(
            nrodocreg: nrodocreg,
            codigoa: item.codigoa,
            delta: -1.0,
          );
    }
  }

  void _eliminarItem(ModeloVentaProducto item) {
    if (_mesaSeleccionada == null) return;

    final ordenActual = List<ModeloVentaProducto>.from(_mesaSeleccionada!.orden)
      ..removeWhere((i) => i.codigoa == item.codigoa);

    final mesaActualizada = _mesaSeleccionada!.copyWith(orden: ordenActual);

    setState(() {
      final mIdx = _mesas.indexWhere((m) => m.id == _mesaSeleccionada!.id);
      if (mIdx != -1) {
        _mesas[mIdx] = mesaActualizada;
      }
      _mesaSeleccionada = mesaActualizada;
    });

    final nrodocreg = item.nrodocreg.isNotEmpty
        ? item.nrodocreg
        : (_mesaSeleccionada?.factura?.nrodocreg ??
              _mesaSeleccionada?.nrodocreg ??
              '');
    if (nrodocreg.isNotEmpty) {
      ref
          .read(servicesMesasProvider)
          .modificarCantidadItem(
            nrodocreg: nrodocreg,
            codigoa: item.codigoa,
            delta: -item.cantidad,
          );
    }
  }

  void _procesarPago() {
    if (_mesaSeleccionada == null || _mesaSeleccionada!.orden.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildModalPago(context, _mesaSeleccionada!);
      },
    );
  }

  void _imprimirComanda() {
    if (_mesaSeleccionada == null) return;
    InfoFlush.mostrarMensajeImportante(
      context,
      titulo: "Imprimiendo Ticket",
      mensaje:
          "Enviando comanda de ${_mesaSeleccionada!.numero} a la impresora...",
      color: false,
    );
  }

  void _mostrarMasOpciones() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.swap_horiz_rounded,
                  color: Color(0xFF1E2530),
                ),
                title: const Text(
                  "Cambiar de Mesa",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  InfoFlush.mostrarMensajeImportante(
                    context,
                    titulo: "Cambio de Mesa",
                    mensaje: "Selecciona la nueva mesa destino",
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.call_split_rounded,
                  color: Color(0xFF1E2530),
                ),
                title: const Text(
                  "Dividir Cuenta",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.cleaning_services_rounded,
                  color: Colors.orange,
                ),
                title: const Text(
                  "Liberar Mesa Actual",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  if (_mesaSeleccionada != null) {
                    setState(() {
                      final idx = _mesas.indexWhere(
                        (m) => m.id == _mesaSeleccionada!.id,
                      );
                      if (idx != -1) {
                        _mesas[idx] = _mesas[idx].copyWith(
                          estado: EstadoMesa.disponible,
                          orden: [],
                          tiempo: '00:00',
                        );
                        _mesaSeleccionada = _mesas[idx];
                      }
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.lock_outline_rounded,
                  color: Colors.red,
                ),
                title: const Text(
                  "Bloquear Pantalla / Cerrar Turno",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/login');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktopScreen = size.width >= 1100;
    final isTabletScreen = size.width >= 750 && size.width < 1100;
    final posData = ref.watch(providerDatosPos);
    final hasInternet = ref.watch(connectivityProvider);

    return Scaffold(
      backgroundColor: const Color(
        0xFFF1F5F9,
      ), // Fondo claro idéntico a referencia
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior informativa y utilitaria para Desktop y Tablet
            _buildTopBar(posData, hasInternet),

            // Contenedor principal responsivo
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- ÁREA IZQUIERDA: Zonas y Cuadrícula de Mesas ---
                  Expanded(
                    flex: isDesktopScreen ? 7 : (isTabletScreen ? 6 : 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Selector de Zonas (SALÓN, TERRAZA, BARRA)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: ZonaSelectorWidget(
                            zonas: _zonas,
                            zonaSeleccionada: _zonaSeleccionada,
                            onZonaChanged: _cambiarZona,
                          ),
                        ),

                        // Cuadrícula de Mesas
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _mesasFiltradas.isEmpty
                                ? _buildEmptyZoneState()
                                : LayoutBuilder(
                                    builder: (context, constraints) {
                                      // Cálculo de columnas responsivo para tablet y windows
                                      int crossAxisCount = 4;
                                      if (constraints.maxWidth < 650) {
                                        crossAxisCount = 2;
                                      } else if (constraints.maxWidth < 950) {
                                        crossAxisCount = 3;
                                      } else {
                                        crossAxisCount = 4;
                                      }

                                      return GridView.builder(
                                        padding: const EdgeInsets.only(
                                          bottom: 24,
                                        ),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: crossAxisCount,
                                              crossAxisSpacing: 16,
                                              mainAxisSpacing: 16,
                                              childAspectRatio: 1.18,
                                            ),
                                        itemCount: _mesasFiltradas.length,
                                        itemBuilder: (context, index) {
                                          final mesa = _mesasFiltradas[index];
                                          final bool isSelected =
                                              _mesaSeleccionada?.id == mesa.id;

                                          return MesaCardWidget(
                                            mesa: mesa,
                                            isSelected: isSelected,
                                            onTap: () => _seleccionarMesa(mesa),
                                          );
                                        },
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- ÁREA DERECHA: Sidebar de la Orden ---
                  if (size.width >= 750)
                    SizedBox(
                      width: isDesktopScreen ? 360 : 310,
                      child: OrdenSidebarWidget(
                        mesaSeleccionada: _mesaSeleccionada,
                        searchController: _searchController,
                        onSearchChanged: (val) {
                          setState(() {
                            _filtroBusqueda = val;
                          });
                        },
                        onPagar: _procesarPago,
                        onImprimir: _imprimirComanda,
                        onMasOpciones: _mostrarMasOpciones,
                        onUsarMesa: () {
                          if (_mesaSeleccionada != null) {
                            _usarMesa(_mesaSeleccionada!);
                          }
                        },
                        onAgregarProducto: _abrirDialogoCatalogo,
                        onIncrementarCantidad: _incrementarCantidadItem,
                        onDecrementarCantidad: _decrementarCantidadItem,
                        onEliminarItem: _eliminarItem,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Botón flotante para ver la orden en pantallas más estrechas o tabletas verticales
      floatingActionButton: size.width < 750
          ? FloatingActionButton.extended(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.85,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: OrdenSidebarWidget(
                          mesaSeleccionada: _mesaSeleccionada,
                          searchController: _searchController,
                          onSearchChanged: (val) {
                            setState(() {
                              _filtroBusqueda = val;
                            });
                          },
                          onPagar: () {
                            Navigator.pop(context);
                            _procesarPago();
                          },
                          onImprimir: () {
                            Navigator.pop(context);
                            _imprimirComanda();
                          },
                          onMasOpciones: () {
                            Navigator.pop(context);
                            _mostrarMasOpciones();
                          },
                          onUsarMesa: () {
                            if (_mesaSeleccionada != null) {
                              _usarMesa(_mesaSeleccionada!);
                            }
                          },
                          onAgregarProducto: () {
                            Navigator.pop(context);
                            _abrirDialogoCatalogo();
                          },
                          onIncrementarCantidad: _incrementarCantidadItem,
                          onDecrementarCantidad: _decrementarCantidadItem,
                          onEliminarItem: _eliminarItem,
                        ),
                      ),
                    );
                  },
                );
              },
              backgroundColor: const Color(0xFF28A745),
              icon: const Icon(Icons.receipt_rounded, color: Colors.white),
              label: Text(
                _mesaSeleccionada != null
                    ? "${_mesaSeleccionada!.numero} (${formatDolar(_mesaSeleccionada!.total)})"
                    : "Ver Orden",
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildTopBar(ProviderDatosPos posData, bool hasInternet) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          // Conexión y estado del sistema
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: hasInternet
                  ? const Color(0xFF28A745).withValues(alpha: 0.12)
                  : Colors.red.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Icon(
                  hasInternet ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                  size: 14,
                  color: hasInternet ? const Color(0xFF28A745) : Colors.red,
                ),
                const SizedBox(width: 5),
                Text(
                  hasInternet ? "EN LÍNEA" : "MODO LOCAL",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: hasInternet ? const Color(0xFF28A745) : Colors.red,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Cajero / Operador
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 16,
                color: colorGeneralStar,
              ),
              const SizedBox(width: 6),
              Text(
                posData.usuario.isNotEmpty ? posData.usuario : "Cajero 01",
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Tasas activas si están habilitadas
          if (posData.tasaDolar > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                "BCV: ${posData.tasaDolar.toStringAsFixed(2)} Bs.",
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
            ),

          // Botón de recarga de mesas
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              size: 20,
              color: Color(0xFF64748B),
            ),
            tooltip: "Actualizar mesas",
            onPressed: () async {
              await _cargarDatosBD(mostrarMensaje: true);
            },
          ),

          // Botón de salir / cerrar sesión
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              size: 20,
              color: Colors.redAccent,
            ),
            tooltip: "Cerrar sesión",
            onPressed: () {
              MostrarMensajeAceptacion.mostrarMensajeAceptacion(
                context,
                icono: Icons.logout_rounded,
                titulo: "¿Cerrar Sesión?",
                subtitulo: "¿Estás seguro que deseas salir del punto de venta?",
                dosBotones: true,
                textoBotonAceptar: "Salir",
                accion: (confirmado) {
                  if (confirmado) {
                    context.go('/login');
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyZoneState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.table_restaurant_outlined,
            size: 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 14),
          Text(
            "No hay mesas en $_zonaSeleccionada",
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModalPago(BuildContext context, MesaModel mesa) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        width: 480,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cobrar ${mesa.numero}",
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total a pagar:",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Color(0xFF475569),
                  ),
                ),
                Text(
                  formatDolar(mesa.total),
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF28A745),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Método de Pago",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildMetodoPagoItem(
                  r"Efectivo ($)",
                  Icons.attach_money_rounded,
                  true,
                ),
                const SizedBox(width: 10),
                _buildMetodoPagoItem(
                  "Tarjeta POS",
                  Icons.credit_card_rounded,
                  false,
                ),
                const SizedBox(width: 10),
                _buildMetodoPagoItem(
                  "Pago Móvil",
                  Icons.phone_android_rounded,
                  false,
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF28A745),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await ref
                      .read(servicesMesasProvider)
                      .liberarMesa(nombreMesa: mesa.numero);
                  setState(() {
                    final idx = _mesas.indexWhere((m) => m.id == mesa.id);
                    if (idx != -1) {
                      _mesas[idx] = _mesas[idx].copyWith(
                        estado: EstadoMesa.disponible,
                        orden: [],
                        tiempo: '00:00',
                      );
                      _mesaSeleccionada = _mesas[idx];
                    }
                  });
                  if (context.mounted) {
                    InfoFlush.mostrarMensajeImportante(
                      context,
                      titulo: "Pago Procesado con Éxito",
                      mensaje:
                          "La mesa ${mesa.numero} ha sido liberada e impresa la factura fiscal.",
                      color: false,
                    );
                  }
                },
                child: const Text(
                  "CONFIRMAR PAGO Y FACTURAR",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetodoPagoItem(String titulo, IconData icon, bool seleccionado) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: seleccionado
              ? const Color(0xFF28A745).withValues(alpha: 0.1)
              : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: seleccionado
                ? const Color(0xFF28A745)
                : const Color(0xFFE2E8F0),
            width: seleccionado ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: seleccionado
                  ? const Color(0xFF28A745)
                  : const Color(0xFF64748B),
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              titulo,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: seleccionado
                    ? const Color(0xFF28A745)
                    : const Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
