import 'package:flutter/material.dart';
import '../models/mesa_model.dart';

class ZonaSelectorWidget extends StatelessWidget {
  final List<ZonaRestaurante> zonas;
  final String zonaSeleccionada;
  final ValueChanged<String> onZonaChanged;

  const ZonaSelectorWidget({
    super.key,
    required this.zonas,
    required this.zonaSeleccionada,
    required this.onZonaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: zonas.map((zona) {
            final bool isSelected = zona.nombre == zonaSeleccionada;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: 170,
                height: 48,
                child: InkWell(
                  onTap: () => onZonaChanged(zona.nombre),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF28A745) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF28A745)
                            : const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? const Color(0xFF28A745).withValues(alpha: 0.22)
                              : Colors.black.withValues(alpha: 0.03),
                          blurRadius: isSelected ? 8 : 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      zona.nombre,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF28A745),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

