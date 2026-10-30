import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:star_mesas_app/app/components/alertas.dart';
import 'package:star_mesas_app/app/components/fondoAnimado.dart';
import 'package:star_mesas_app/app/config/constantes.dart';
import 'package:star_mesas_app/app/config/preferences/datosConexionBd.dart';
import 'package:star_mesas_app/app/config/preferences/datosEmpresa.dart';
import 'package:star_mesas_app/app/config/provider/providerDatosPos.dart';
import 'package:star_mesas_app/app/presentation/auth/services/servicesLogin.dart';
import 'package:star_mesas_app/app/presentation/config/configRed.dart';
import 'package:star_mesas_app/app/widgets/botonGeneral.dart';
import 'package:star_mesas_app/app/widgets/textEditingGeneral.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _ctrlUsuario;
  late TextEditingController _ctrlPassword;
  late FocusNode _focusNode;
  bool cargar = false;
  String mensajeCarga = "Cargando...";
  DateTime fechaActual = DateTime.now();
  bool focusText = true;
  bool focusPassword = false;
  bool _mostrarConfigDesplegable = false;

  late FocusNode nombreFocus;
  late FocusNode passwordFocus;
  late FocusNode botonFocus;
  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _ctrlUsuario = TextEditingController();
    _ctrlPassword = TextEditingController();
    nombreFocus = FocusNode();
    passwordFocus = FocusNode();
    botonFocus = FocusNode();
    if (Platform.isWindows) {
      nombreFocus.requestFocus();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    nombreFocus.dispose();
    passwordFocus.dispose();
    botonFocus.dispose();
    _ctrlUsuario.dispose();
    _ctrlPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final posData = ref.watch(providerDatosPos);
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (KeyEvent event) async {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.f6) {
          AlertaClave.mostrarMensajeContra(
            context,
            posData: posData,
            accion: (value) {
              showDialog(
                barrierDismissible: true,
                context: context,
                builder: (BuildContext context) {
                  return const Configurarred();
                },
              );
            },
          );
        }

        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.escape) {
          exit(0);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: AnimatedBubblesBackground(
            showBooble: true,
            child: Stack(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Expanded(
                          child: isDesktop(context)
                              ? _buildDesktopLayout()
                              : isTablet(context)
                              ? _buildTabletLayout()
                              : _buildMobileLayout(),
                        ),
                        infoVaria(),
                      ],
                    ),
                  ),
                ),
                if (isMobile(context)) _buildMobileConfigPanel(),
                if (cargar)
                  Container(
                    color: Colors.black.withOpacity(0.7),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 6,
                          ),
                          const SizedBox(height: 25),
                          Text(
                            mensajeCarga,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Por favor, espere un momento...",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  98,
                  248,
                  250,
                  252,
                ), // Fondo casi blanco para contraste elegante
                border: Border(left: BorderSide(color: Colors.grey.shade200)),
              ),
              child: _buildInfoSection(),
            ),
          ),
        ),
        Container(
          color: Colors.grey.withOpacity(0.3),
          height: double.infinity,
          width: 1,
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: _buildLoginForm(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  98,
                  248,
                  250,
                  252,
                ), // Fondo casi blanco para contraste elegante
                border: Border(left: BorderSide(color: Colors.grey.shade200)),
              ),
              child: _buildInfoSection(),
            ),
          ),
        ),
        Container(
          color: Colors.grey.withOpacity(0.3),
          height: double.infinity,
          width: 1,
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: _buildLoginForm(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DatosConexionBd().logoPrin.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: DatosConexionBd().logoPrin,
                    height: 120,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const SizedBox(
                      height: 120,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) {
                      return Image.asset(
                        'assets/imagenes/logo.png',
                        height: 120,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.business_center_rounded,
                            size: 80,
                            color: colorGeneralStar,
                          );
                        },
                      );
                    },
                  )
                : Image.asset(
                    'assets/imagenes/logo.png',
                    height: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.business_center_rounded,
                        size: 80,
                        color: colorGeneralStar,
                      );
                    },
                  ),
            const SizedBox(height: 40),
            _buildLoginForm(),
            const SizedBox(height: 30),
            _buildPromoSection(isMobile: true),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    final String posNumero = DatosConexionBd().codigoPos.isNotEmpty
        ? DatosConexionBd().codigoPos
        : '1';

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 36),
          padding: const EdgeInsets.fromLTRB(20, 44, 20, 30),
          decoration: BoxDecoration(
            color: const Color.fromARGB(192, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.point_of_sale_rounded,
                      size: 80,
                      color: colorGeneralStar,
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'StarSystem Restaurant',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: colorGeneralStar,
                              letterSpacing: -0.5,
                            ),
                          ),
                          if (DatosEmpresa().nombreEmp.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              DatosEmpresa().nombreEmp.toUpperCase(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.grey.shade700,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '¡Bienvenido de nuevo!',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Ingresa tus credenciales para acceder al panel administrativo.',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 10),
              // Campo de Correo / Usuario
              _buildTextField(
                label: 'Usuario',
                hint: '',
                icon: Icons.email_outlined,
                controller: _ctrlUsuario,
                focusNode: nombreFocus,
                focusNodeNext: passwordFocus,
              ),
              const SizedBox(height: 20),
              // Campo de Contraseña
              _buildTextField(
                label: 'Contraseña',
                hint: '••••••••',
                icon: Icons.lock_outline,
                isPassword: true,
                controller: _ctrlPassword,
                focusNode: passwordFocus,
                focusNodeNext: botonFocus,
              ),

              const SizedBox(height: 30),
              // Botón de Ingresar
              MostrarBotonGuardar(
                colorBton: colorGeneralStar,
                texto: 'Iniciar Sesión',
                colorTexto: Colors.white,
                accion: () {
                  if (_formKey.currentState!.validate()) {
                    _validarInicioSesion();
                  }
                },
                icon: Icons.login,
                colorIcon: Colors.white,
                colorBorder: colorGeneralStar,
                focusNode: botonFocus,
                alto: 55,
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorGeneralStar,
                  colorGeneralStar.withValues(alpha: 0.85),
                ],
              ),
              border: Border.all(color: Colors.white, width: 3.5),
              boxShadow: [
                BoxShadow(
                  color: colorGeneralStar.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'POS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withValues(alpha: 0.88),
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    posNumero,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: posNumero.length > 3
                          ? 15
                          : (posNumero.length > 2 ? 18 : 22),
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    required FocusNode focusNode,
    required FocusNode focusNodeNext,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        EditorTextoGeneral(
          controller: controller,
          label: label,
          icon: icon,
          accentColor: colorGeneralStar,
          labelColor: colorGeneralStar,
          focusNode: focusNode,
          focusNodeNext: focusNodeNext,
          oscured: isPassword,
          keyboardType: isPassword
              ? TextInputType.visiblePassword
              : TextInputType.text,
          validator: (p0) {
            if (p0!.isEmpty) {
              return 'No puede estar vacio';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DatosConexionBd().logoPrin.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: DatosConexionBd().logoPrin,
                height: 120,
                fit: BoxFit.contain,
                placeholder: (context, url) => const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) {
                  return Image.asset(
                    'assets/imagenes/logo.png',
                    height: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.business_center_rounded,
                        size: 80,
                        color: colorGeneralStar,
                      );
                    },
                  );
                },
              )
            : Image.asset(
                'assets/imagenes/logo.png',
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.business_center_rounded,
                    size: 80,
                    color: colorGeneralStar,
                  );
                },
              ),
        const SizedBox(height: 50),
        Text(
          'Rapidez, precisión y cumplimiento en cada venta',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: colorGeneralStar,
            height: 1.2,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            'StarSystem POS simplifica y optimiza tus operaciones de caja en tiempo real. Diseñado para un alto rendimiento en ventas presenciales, integra facturación fiscal tradicional, facturación electrónica digital y control multimoneda ágil.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 60),
        // Características destacadas
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFeatureItem(Icons.bolt_rounded, 'Facturación\nUltra Rápida'),
            const SizedBox(width: 40),
            _buildFeatureItem(
              Icons.currency_exchange_rounded,
              'Cobros\nMultimoneda',
            ),
            const SizedBox(width: 40),
            _buildFeatureItem(Icons.print_rounded, 'Factura Fiscal\ny Digital'),
          ],
        ),
        const SizedBox(height: 50),
        _buildPromoSection(isMobile: false),
      ],
    );
  }

  Widget _buildPromoSection({required bool isMobile}) {
    final promoContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Soporte & Comunidad',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorGeneralStar,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Escanea el QR o contáctanos para recibir soporte técnico y conocer las novedades.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        // Redes
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFDF2F8),
                shape: BoxShape.circle,
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedInstagram,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Síguenos en Instagram',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    '@STARSYSTEM.VE',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFECFDF5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.phone_android_rounded,
                color: Color(0xFF059669),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WhatsApp Ventas & Soporte',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      const Text(
                        'Ing. Carlos Gomez',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        '+58 424-7781199',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      const Text(
                        'Ing. Oswaldo Mendoza',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        '+58 0424-7369732',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );

    final qrWidget = Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/imagenes/qr.png',
          height: 120,
          width: 120,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 120,
              width: 120,
              color: Colors.grey.shade100,
              child: const Icon(
                Icons.qr_code_2_rounded,
                size: 50,
                color: Colors.grey,
              ),
            );
          },
        ),
      ),
    );

    if (isMobile) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 0.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(167, 255, 255, 255),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: colorGeneralStar.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: colorGeneralStar.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            promoContent,
            const SizedBox(height: 20),
            Center(child: qrWidget),
          ],
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 40.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(167, 255, 255, 255),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: colorGeneralStar.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: colorGeneralStar.withValues(alpha: 0.04),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: promoContent),
            const SizedBox(width: 20),
            qrWidget,
          ],
        ),
      );
    }
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorGeneralStar.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(icon, size: 32, color: colorGeneralStar),
        ),
        const SizedBox(height: 16),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorGeneralStar,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileConfigPanel() {
    final posData = ref.watch(providerDatosPos);
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _mostrarConfigDesplegable ? 75 : 0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                if (_mostrarConfigDesplegable)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
              ],
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(16),
              ),
            ),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorGeneralStar,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(
                          Icons.wifi_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: const Text(
                          'Red (F6)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          setState(() => _mostrarConfigDesplegable = false);
                          AlertaClave.mostrarMensajeContra(
                            posData: posData,
                            context,
                            accion: (value) {
                              showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return const Configurarred();
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _mostrarConfigDesplegable = !_mostrarConfigDesplegable;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _mostrarConfigDesplegable
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.settings_rounded,
                    size: 16,
                    color: colorGeneralStar,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _mostrarConfigDesplegable ? 'Ocultar' : 'Configuraciones',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colorGeneralStar,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoVaria() {
    if (isMobile(context)) {
      return Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '© ${DateTime.now().year} StarSystem. Todos los derechos reservados.',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorGeneralStar,
                height: 1.3,
              ),
            ),
            Text(
              'Versión 1.56.0',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '© ${DateTime.now().year} StarSystem. Todos los derechos reservados.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorGeneralStar,
              height: 1.3,
            ),
          ),
          Text(
            'POS: ${DatosConexionBd().codigoPos}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          Text(
            'Versión 1.56.0',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _validarInicioSesion() async {
    if (cargar) return;
    setState(() {
      cargar = true;
      mensajeCarga = "Validando credenciales...";
    });

    final validarLoginService = ref.read(servicesloginProvider);
    final resultado = await validarLoginService.validarLogin(
      usuario: _ctrlUsuario.text,
      contrasena: _ctrlPassword.text,
      pos: DatosConexionBd().codigoPos,
      ref: ref,
    );

    if (resultado['ok'] == true) {
      final Map<String, dynamic> datos = Map<String, dynamic>.from(
        resultado['data'],
      );
      final posData = ref.read(providerDatosPos);
      final res = await posData.cargarDatosDesdeBD(ref);
      if (!res['ok']) {
        if (mounted) {
          MostrarMensajeAceptacion.mostrarMensajeAceptacion(
            context,
            titulo: "Error en Datos",
            subtitulo:
                res['message']?.toString() ??
                'Error al Iniciar Sesión en la Caja',
            icono: Icons.warning,
            dosBotones: false,
            accion: (asd) {},
          );
          setState(() {
            nombreFocus.requestFocus();
            cargar = false;
          });
        }
        return;
      }

      await exito(datos);
      return;
    } else {
      if (mounted) {
        MostrarMensajeAceptacion.mostrarMensajeAceptacion(
          context,
          titulo: "Error",
          subtitulo:
              resultado['message']?.toString() ?? 'Error al Iniciar Sesión',
          icono: Icons.warning,
          dosBotones: false,
          accion: (asd) {},
        );
      }
    }

    if (mounted) {
      setState(() {
        nombreFocus.requestFocus();
        cargar = false;
      });
    }
  }

  Future<void> exito(Map<String, dynamic> datos) async {
    if (!mounted) return;
    final posData = ref.read(providerDatosPos);
    posData.usuario = datos['nombre'].toString();
    posData.cedusu = datos['cedusu'].toString();
    posData.supervisor = datos['supervisor'].toString() == '1' ? true : false;
    posData.master = datos['master'].toString() == '1' ? true : false;
    if (!mounted) return;
    posData.contra = _ctrlPassword.text;
    posData.tipoDeposito = "DP";
    posData.valNuevaFactura = true;
    posData.valNotaCredito = false;
    posData.valNotaDebito = false;
    context.go('/ventanaPrincipal');
  }
}
