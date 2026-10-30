import 'package:mysql_client_plus/mysql_client_plus.dart';
import 'package:riverpod/riverpod.dart';
import 'package:star_mesas_app/app/config/preferences/datosConexionBd.dart';

// ---------------------------------------------------------------------------
// Estado de la conexión
// ---------------------------------------------------------------------------
enum ConexionEstado { desconectado, conectando, conectado, error }

class ConexionState {
  // 1. Cambiamos MySQLConnection por MySQLConnectionPool
  final MySQLConnectionPool? pool;
  final ConexionEstado estado;
  final String? mensajeError;

  const ConexionState({
    this.pool,
    this.estado = ConexionEstado.desconectado,
    this.mensajeError,
  });

  bool get isConectado => estado == ConexionEstado.conectado && pool != null;

  ConexionState copyWith({
    MySQLConnectionPool? pool,
    ConexionEstado? estado,
    String? mensajeError,
  }) {
    return ConexionState(
      pool: pool ?? this.pool,
      estado: estado ?? this.estado,
      mensajeError: mensajeError ?? this.mensajeError,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier: gestiona el ciclo de vida de la conexión (Pool)
// ---------------------------------------------------------------------------
class ConexionNotifier extends AsyncNotifier<ConexionState> {
  MySQLConnectionPool? _pool;

  @override
  Future<ConexionState> build() async {
    // Intenta conectar automáticamente al inicializar el provider
    ref.onDispose(_cerrarPool);
    return _conectar();
  }

  // ----- Conectar ------------------------------------------------------------
  Future<ConexionState> _conectar() async {
    try {
      final db = DatosConexionBd();

      // 2. Instanciamos el Pool en lugar de una conexión única
      _pool = MySQLConnectionPool(
        host: db.ipBaseD,
        port: int.parse(db.puertoBaseD), // Mantenemos tu parseo
        userName: db.usuarioBD,
        password: db.contrasenaBD,
        databaseName: db.nombreBaseD,
        secure: false,
        maxConnections:
            10, // Límite de conexiones simultáneas (ajusta según necesites)
      );

      // 3. Hacemos un "ping" a la BD para asegurar que las credenciales son válidas.
      // El Pool es "lazy" (perezoso) y no arrojaría error hasta la primera consulta si no hacemos esto.
      await _pool!.execute('SELECT 1');

      final nuevoEstado = ConexionState(
        pool: _pool,
        estado: ConexionEstado.conectado,
      );
      return nuevoEstado;
    } catch (e) {
      print('ERROR CONEXION BD: $e');
      return ConexionState(
        estado: ConexionEstado.error,
        mensajeError: 'Error al conectar con la base de datos: $e',
      );
    }
  }

  // ----- Reconectar (útil para reintentos) -----------------------------------
  Future<void> reconectar() async {
    state = const AsyncValue.loading();
    await _cerrarPool();
    state = AsyncValue.data(await _conectar());
  }

  // ----- Cerrar conexión -----------------------------------------------------
  Future<void> _cerrarPool() async {
    try {
      await _pool?.close();
    } catch (_) {}
    _pool = null;
  }

  // ----- Acceso rápido al Pool activo ----------------------------------------
  /// Devuelve el pool si está activo, o lanza excepción.
  MySQLConnectionPool obtenerPool() {
    final s = state.value;
    if (s == null || !s.isConectado) {
      throw StateError(
        'No hay pool de conexiones activo con la base de datos.',
      );
    }
    return s.pool!;
  }
}

final conexionProvider = AsyncNotifierProvider<ConexionNotifier, ConexionState>(
  ConexionNotifier.new,
);

/// Provider de acceso directo a [MySQLConnectionPool].
/// Devuelve null si todavía no hay conexión disponible.
final mysqlProvider = Provider<MySQLConnectionPool?>((ref) {
  return ref.watch(conexionProvider).value?.pool;
});

/// Provider que expone si la BD está conectada.
final bdConectadaProvider = Provider<bool>((ref) {
  return ref.watch(conexionProvider).value?.isConectado ?? false;
});
