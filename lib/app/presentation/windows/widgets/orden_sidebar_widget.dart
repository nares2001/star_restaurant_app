import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:star_mesas_app/app/config/constantes.dart';
import 'package:star_mesas_app/app/config/preferences/datosVarios.dart';
import 'package:star_mesas_app/app/models/modeloVentaProducto.dart';
import '../models/mesa_model.dart';

class OrdenSidebarWidget extends StatelessWidget {
  final MesaModel? mesaSeleccionada;
  final TextEditingController searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback onPagar;
  final VoidCallback onImprimir;
  final VoidCallback onMasOpciones;
  final VoidCallback? onUsarMesa;
  final VoidCallback? onAgregarProducto;
  final Function(ModeloVentaProducto item)? onIncrementarCantidad;
  final Function(ModeloVentaProducto item)? onDecrementarCantidad;
  final Function(ModeloVentaProducto item)? onEliminarItem;

  const OrdenSidebarWidget({
    super.key,
    required this.mesaSeleccionada,
    required this.searchController,
    this.onSearchChanged,
    required this.onPagar,
    required this.onImprimir,
    required this.onMasOpciones,
    this.onUsarMesa,
    this.onAgregarProducto,
    this.onIncrementarCantidad,
    this.onDecrementarCantidad,
    this.onEliminarItem,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMesaLibre = mesaSeleccionada != null && !mesaSeleccionada!.isOcupada;
    final List<ModeloVentaProducto> items = mesaSeleccionada?.orden ?? [];
    final double subtotal = mesaSeleccionada?.subtotal ?? 0.0;
    final double taxes = mesaSeleccionada?.impuestos ?? 0.0;
    final double total = mesaSeleccionada?.total ?? 0.0;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Color(0xFFE2E8F0), width: 1.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Cabecera con Logo StarSystem
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                _buildLogoStar(),
                const SizedBox(width: 10),
                Text(
                  "StarSystem",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: colorGeneralStar,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          // 2. Buscador de platos o mesas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.5,
                  color: Color(0xFF1E293B),
                ),
                decoration: const InputDecoration(
                  hintText: "Buscar plato o mesa...",
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.5,
                    color: Color(0xFF94A3B8),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Color(0xFF64748B),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 11),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 3. Título de la Mesa / Orden + Botón "+ Agregar" si está ocupada
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mesaSeleccionada != null
                            ? mesaSeleccionada!.numero
                            : "Sin Selección",
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      if (mesaSeleccionada != null)
                        Text(
                          isMesaLibre
                              ? "Mesa Disponible"
                              : "Comanda en servicio (${mesaSeleccionada!.zona})",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isMesaLibre
                                ? const Color(0xFF64748B)
                                : const Color(0xFF28A745),
                          ),
                        ),
                    ],
                  ),
                ),
                if (mesaSeleccionada != null && mesaSeleccionada!.isOcupada && onAgregarProducto != null)
                  ElevatedButton.icon(
                    onPressed: onAgregarProducto,
                    icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                    label: const Text(
                      "AGREGAR",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF28A745),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // 4. Contenido central:
          // SI LA MESA ESTÁ LIBRE -> Botón para "USAR MESA"
          // SI LA MESA ESTÁ OCUPADA -> Lista de productos con incremento/decremento y eliminación
          Expanded(
            child: isMesaLibre
                ? _buildMesaLibreState()
                : (items.isEmpty ? _buildMesaVaciaState() : _buildListaItems(items)),
          ),

          // 5. Sección de Totales (Subtotal, Taxas, Total)
          if (!isMesaLibre)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
              child: Column(
                children: [
                  const Divider(color: Color(0xFFE2E8F0), thickness: 1),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Subtotal:",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.5,
                          color: Color(0xFF475569),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        formatDolar(subtotal),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.5,
                          color: Color(0xFF0F172A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Taxas:",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.5,
                          color: Color(0xFF475569),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        formatDolar(taxes),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13.5,
                          color: Color(0xFF0F172A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "TOTAL:",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        formatDolar(total),
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // 6. Botones de Acción (PAGAR / IMPRIMIR / MÁS)
          if (!isMesaLibre)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  // Botón principal "PAGAR"
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: items.isEmpty ? null : onPagar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF28A745),
                        disabledBackgroundColor: const Color(0xFFE2E8F0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "PAGAR",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: items.isEmpty
                              ? const Color(0xFF94A3B8)
                              : Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Botones secundarios "IMPRIMIR" y "MÁS"
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: items.isEmpty ? null : onImprimir,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E2530),
                              disabledBackgroundColor: const Color(0xFFCBD5E1),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "IMPRIMIR",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            onPressed: onMasOpciones,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E2530),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "MÁS",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // VISTA CUANDO LA MESA ESTÁ LIBRE: BOTÓN PARA USAR MESA
  // ---------------------------------------------------------------------------
  Widget _buildMesaLibreState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF28A745).withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.table_restaurant_rounded,
                size: 44,
                color: Color(0xFF28A745),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "${mesaSeleccionada?.numero ?? 'Mesa'} Libre",
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Esta mesa se encuentra disponible para recibir comensales y tomar pedidos.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: onUsarMesa,
                icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 24),
                label: const Text(
                  "USAR MESA / ABRIR COMANDA",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF28A745),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // VISTA CUANDO LA MESA ESTÁ OCUPADA PERO SIN PLATOS
  // ---------------------------------------------------------------------------
  Widget _buildMesaVaciaState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu_rounded, size: 54, color: Colors.grey.shade300),
            const SizedBox(height: 14),
            const Text(
              "Mesa abierta sin platos",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF475569),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Comienza a agregar los pedidos solicitados por los clientes.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.5,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 20),
            if (onAgregarProducto != null)
              ElevatedButton.icon(
                onPressed: onAgregarProducto,
                icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                label: const Text(
                  "Agregar Primer Plato",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF28A745),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LISTA DE PRODUCTOS CON CONTROLES DE CANTIDAD (+ / -) Y CANCELAR (ELIMINAR)
  // ---------------------------------------------------------------------------
  Widget _buildListaItems(List<ModeloVentaProducto> items) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(color: Color(0xFFF1F5F9), height: 16),
      itemBuilder: (context, index) {
        final item = items[index];
        final double itemTotal = item.subtotalDolar > 0 ? item.subtotalDolar : item.subtotal;
        final double itemPrecio = item.priceDolar > 0 ? item.priceDolar : item.precio;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Nombre del plato y precio unitario
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.detalle1,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    formatDolar(itemPrecio),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // 2. Control de Cantidad: [-] [cant] [+]
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Botón decrementar
                  InkWell(
                    onTap: () {
                      if (onDecrementarCantidad != null) {
                        onDecrementarCantidad!(item);
                      }
                    },
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Icon(Icons.remove_rounded, size: 16, color: Color(0xFF475569)),
                    ),
                  ),

                  // Texto de cantidad
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      "${item.cantidad.toInt()}x",
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),

                  // Botón incrementar
                  InkWell(
                    onTap: () {
                      if (onIncrementarCantidad != null) {
                        onIncrementarCantidad!(item);
                      }
                    },
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Icon(Icons.add_rounded, size: 16, color: Color(0xFF28A745)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // 3. Monto total de la línea
            SizedBox(
              width: 60,
              child: Text(
                formatDolar(itemTotal),
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),

            // 4. Botón Cancelar / Eliminar ítem
            if (onEliminarItem != null)
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF94A3B8)),
                hoverColor: Colors.red.withValues(alpha: 0.1),
                splashRadius: 18,
                padding: const EdgeInsets.only(left: 6),
                constraints: const BoxConstraints(),
                tooltip: "Cancelar plato",
                onPressed: () => onEliminarItem!(item),
              ),
          ],
        );
      },
    );
  }

  Widget _buildLogoStar() {
    final logoUrl = DatosVarios().logoPrin;
    if (logoUrl.isNotEmpty) {
      return SizedBox(
        width: 32,
        height: 32,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: logoUrl,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) => _buildDefaultLogoIcon(),
          ),
        ),
      );
    }
    return _buildDefaultLogoIcon();
  }

  Widget _buildDefaultLogoIcon() {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: colorGeneralStar, width: 2),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant_menu_rounded,
          size: 18,
          color: colorGeneralStar,
        ),
      ),
    );
  }
}
