import 'package:flutter/material.dart';

class MesaIconWidget extends StatelessWidget {
  final bool isOcupada;
  final double width;
  final double height;
  final Color? customColor;

  const MesaIconWidget({
    super.key,
    required this.isOcupada,
    this.width = 110,
    this.height = 70,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    // Verde esmeralda idéntico a la referencia si está ocupada, o gris neutro si está disponible
    final Color colorMesa = customColor ??
        (isOcupada
            ? const Color(0xFF28A745)
            : const Color(0xFFA0AEC0));

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _MesaVisualPainter(color: colorMesa),
      ),
    );
  }
}

class _MesaVisualPainter extends CustomPainter {
  final Color color;

  _MesaVisualPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final double w = size.width;
    final double h = size.height;

    // Dimensiones de la mesa central
    final double tableW = w * 0.54;
    final double tableH = h * 0.44;
    final double tableLeft = (w - tableW) / 2;
    final double tableTop = (h - tableH) / 2;
    final double tableRight = tableLeft + tableW;
    final double tableBottom = tableTop + tableH;

    // 1. Dibujar mesa central redondeada
    final tableRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tableLeft, tableTop, tableW, tableH),
      const Radius.circular(8),
    );
    canvas.drawRRect(tableRRect, paint);

    // Dimensiones y separación de las sillas
    final double gap = h * 0.07;
    final double chairThickness = h * 0.16;
    final double chairSpanHorizontal = tableW * 0.32;
    final double chairSpanVertical = tableH * 0.45;
    final double chairRadius = 3.5;

    // 2. Sillas superiores (2 sillas)
    final double topChairY = tableTop - gap - chairThickness;
    // Silla sup izquierda
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          tableLeft + (tableW * 0.12),
          topChairY,
          chairSpanHorizontal,
          chairThickness,
        ),
        Radius.circular(chairRadius),
      ),
      paint,
    );
    // Silla sup derecha
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          tableRight - (tableW * 0.12) - chairSpanHorizontal,
          topChairY,
          chairSpanHorizontal,
          chairThickness,
        ),
        Radius.circular(chairRadius),
      ),
      paint,
    );

    // 3. Sillas inferiores (2 sillas)
    final double bottomChairY = tableBottom + gap;
    // Silla inf izquierda
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          tableLeft + (tableW * 0.12),
          bottomChairY,
          chairSpanHorizontal,
          chairThickness,
        ),
        Radius.circular(chairRadius),
      ),
      paint,
    );
    // Silla inf derecha
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          tableRight - (tableW * 0.12) - chairSpanHorizontal,
          bottomChairY,
          chairSpanHorizontal,
          chairThickness,
        ),
        Radius.circular(chairRadius),
      ),
      paint,
    );

    // 4. Silla lateral izquierda (1 silla)
    final double leftChairX = tableLeft - gap - chairThickness;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          leftChairX,
          (h - chairSpanVertical) / 2,
          chairThickness,
          chairSpanVertical,
        ),
        Radius.circular(chairRadius),
      ),
      paint,
    );

    // 5. Silla lateral derecha (1 silla)
    final double rightChairX = tableRight + gap;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          rightChairX,
          (h - chairSpanVertical) / 2,
          chairThickness,
          chairSpanVertical,
        ),
        Radius.circular(chairRadius),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _MesaVisualPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

