import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:star_mesas_app/app/config/constantes.dart';
import 'package:star_mesas_app/app/config/preferences/datosVarios.dart';
import 'package:star_mesas_app/app/config/provider/configInicioProvider.dart';

class Redirigir extends ConsumerStatefulWidget {
  const Redirigir({super.key});

  @override
  ConsumerState<Redirigir> createState() => _RedirigirState();
}

class _RedirigirState extends ConsumerState<Redirigir>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  bool _navegando = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.90, end: 1.10).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _evaluarEstadoApp() {
    if (_navegando) return;
    _navegando = true;

    // Pequeño delay opcional para que se vea la animación si fue muy rápido
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      context.go("/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    final conexionEstado = ref.watch(confiRestProvider);

    // Escuchamos los cambios para navegar cuando termine la inicialización
    ref.listen(confiRestProvider, (previous, next) {
      if (next.hasValue || next.hasError) {
        _evaluarEstadoApp();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: conexionEstado.when(
          data: (_) {
            return _buildLoadingAnimation();
          },
          error: (error, stackTrace) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_off_rounded,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Problemas de conexión",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextButton(
                      onPressed: _evaluarEstadoApp,
                      child: const Text(
                        "Continuar sin conexión (Modo Local)",
                        style: TextStyle(fontFamily: "Poppins", fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => _buildLoadingAnimation(),
        ),
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: colorGeneralStar.withOpacity(0.15),
                    blurRadius: 40,
                    spreadRadius: 15,
                  ),
                ],
              ),
              child: ClipOval(
                child: DatosVarios().logoPrin.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: DatosVarios().logoPrin,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) {
                          return Image.asset(
                            "assets/images/logo.png",
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const SizedBox.shrink(),
                          );
                        },
                      )
                    : Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          Text(
            "StarSystem",
            style: TextStyle(
              fontSize: 32,
              color: colorGeneralStar,
              fontWeight: FontWeight.w800,
              fontFamily: "Poppins",
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Iniciando plataforma...",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 35),
          SizedBox(
            width: 45,
            height: 45,
            child: CircularProgressIndicator(
              color: colorGeneralStar,
              strokeWidth: 3.5,
              strokeCap: StrokeCap.round,
            ),
          ),
        ],
      ),
    );
  }
}
