import 'package:flutter/material.dart';
import '../models/mesa_model.dart';
import 'mesa_icon_widget.dart';

class MesaCardWidget extends StatelessWidget {
  final MesaModel mesa;
  final bool isSelected;
  final VoidCallback onTap;

  const MesaCardWidget({
    super.key,
    required this.mesa,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Colores según estado (Verde esmeralda para ocupada, gris para disponible)
    final Color colorEstado = mesa.isOcupada
        ? const Color(0xFF28A745)
        : const Color(0xFFA0AEC0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF28A745)
                  : Colors.black.withValues(alpha: 0.05),
              width: isSelected ? 2.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? const Color(0xFF28A745).withValues(alpha: 0.18)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: isSelected ? 14 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Cabecera con tiempo transcurrido
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 10, right: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time_filled_rounded,
                      size: 15,
                      color: colorEstado,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      mesa.tiempo,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: colorEstado,
                      ),
                    ),
                    const Spacer(),
                    if (mesa.isOcupada && mesa.orden.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF28A745).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "${mesa.orden.length} items",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF28A745),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // 2. Iconografía gráfica de la mesa y sillas
              Expanded(
                child: Center(
                  child: MesaIconWidget(
                    isOcupada: mesa.isOcupada,
                    width: 100,
                    height: 60,
                  ),
                ),
              ),

              // 3. Franja inferior oscura con el número de la mesa
              Container(
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E2530),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  mesa.numero,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

