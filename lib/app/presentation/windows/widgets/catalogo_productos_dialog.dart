import 'package:flutter/material.dart';
import 'package:star_mesas_app/app/config/constantes.dart';
import 'package:star_mesas_app/app/models/modeloProducto.dart';
import '../models/mesa_model.dart';

class CatalogoProductosDialog extends StatefulWidget {
  final MesaModel mesa;
  final List<ModeloProductoVenta> productos;
  final Function(ModeloProductoVenta producto) onAgregarProducto;

  const CatalogoProductosDialog({
    super.key,
    required this.mesa,
    required this.productos,
    required this.onAgregarProducto,
  });

  @override
  State<CatalogoProductosDialog> createState() => _CatalogoProductosDialogState();
}

class _CatalogoProductosDialogState extends State<CatalogoProductosDialog> {
  late TextEditingController _searchController;
  String _filtroTexto = '';
  String _categoriaSeleccionada = 'TODOS';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _categorias {
    final Set<String> categorias = {'TODOS'};
    for (final p in widget.productos) {
      if (p.deposito.isNotEmpty) categorias.add(p.deposito.toUpperCase());
    }
    // Si no hay categorías en los datos, usamos categorías comunes
    if (categorias.length == 1) {
      return ['TODOS', 'COMIDA', 'BEBIDAS', 'ENTRADAS', 'PIZZAS', 'POSTRES'];
    }
    return categorias.toList();
  }

  List<ModeloProductoVenta> get _productosFiltrados {
    return widget.productos.where((p) {
      // Filtro de texto
      if (_filtroTexto.isNotEmpty) {
        final query = _filtroTexto.toLowerCase();
        final matchNombre = p.detalle1.toLowerCase().contains(query);
        final matchCodigo = p.codigoa.toLowerCase().contains(query);
        if (!matchNombre && !matchCodigo) return false;
      }

      // Filtro de categoría
      if (_categoriaSeleccionada != 'TODOS') {
        final rama = p.deposito.toUpperCase();
        if (!rama.contains(_categoriaSeleccionada)) {
          // Fallback por nombre si no está categorizado
          if (_categoriaSeleccionada == 'BEBIDAS' &&
              !p.detalle1.toLowerCase().contains('refresco') &&
              !p.detalle1.toLowerCase().contains('cerveza') &&
              !p.detalle1.toLowerCase().contains('jugo') &&
              !p.detalle1.toLowerCase().contains('mojito') &&
              !p.detalle1.toLowerCase().contains('café') &&
              !p.detalle1.toLowerCase().contains('tonic')) {
            return false;
          }
        }
      }

      return true;
    }).toList();
  }

  int _obtenerCantidadEnOrden(String codigoa) {
    for (final item in widget.mesa.orden) {
      if (item.codigoa == codigoa) {
        return item.cantidad.toInt();
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Container(
        width: size.width > 900 ? 820 : size.width * 0.95,
        height: size.height * 0.85,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Cabecera
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.restaurant_menu_rounded, color: colorGeneralStar, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          "Agregar a ${widget.mesa.numero}",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Selecciona productos del menú para añadirlos a la comanda",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 2. Buscador
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() => _filtroTexto = val);
                },
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 13.5),
                decoration: const InputDecoration(
                  hintText: "Buscar plato, bebida o código...",
                  prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 11),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 3. Pastillas de Categorías
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categorias.map((cat) {
                  final isSelected = cat == _categoriaSeleccionada;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : const Color(0xFF475569),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF28A745),
                      backgroundColor: const Color(0xFFF1F5F9),
                      side: BorderSide(
                        color: isSelected ? const Color(0xFF28A745) : const Color(0xFFE2E8F0),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _categoriaSeleccionada = cat);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 14),

            // 4. Cuadrícula de Productos
            Expanded(
              child: _productosFiltrados.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.no_meals_rounded, size: 48, color: Colors.grey.shade300),
                          const SizedBox(height: 10),
                          const Text(
                            "No se encontraron productos",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 3;
                        if (constraints.maxWidth < 500) {
                          crossAxisCount = 2;
                        } else if (constraints.maxWidth > 750) {
                          crossAxisCount = 4;
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.only(bottom: 10),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.15,
                          ),
                          itemCount: _productosFiltrados.length,
                          itemBuilder: (context, index) {
                            final prod = _productosFiltrados[index];
                            final cantEnOrden = _obtenerCantidadEnOrden(prod.codigoa);

                            return InkWell(
                              onTap: () {
                                widget.onAgregarProducto(prod);
                                setState(() {});
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: cantEnOrden > 0
                                        ? const Color(0xFF28A745)
                                        : const Color(0xFFE2E8F0),
                                    width: cantEnOrden > 0 ? 1.8 : 1.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.03),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Icono / Imagen y badge de cantidad si ya está agregada
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: colorGeneralStar.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.restaurant_rounded,
                                            size: 20,
                                            color: colorGeneralStar,
                                          ),
                                        ),
                                        if (cantEnOrden > 0)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF28A745),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              "${cantEnOrden}x",
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 11,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),

                                    const Spacer(),

                                    // Nombre del plato
                                    Text(
                                      prod.detalle1,
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1E293B),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    const SizedBox(height: 4),

                                    // Precio en Dólares
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formatDolar(prod.priceDolar > 0 ? prod.priceDolar : prod.priceA),
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF28A745),
                                          ),
                                        ),
                                        Container(
                                          width: 26,
                                          height: 26,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF28A745).withValues(alpha: 0.15),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.add_rounded,
                                            size: 18,
                                            color: Color(0xFF28A745),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),

            const SizedBox(height: 10),

            // 5. Pie de diálogo con botón de confirmación
            SizedBox(
              height: 46,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                label: Text(
                  "LISTO (${widget.mesa.orden.length} productos agregados)",
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2530),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

