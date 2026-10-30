import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// StreamProvider que emite la lista de tipos de conectividad activos.
/// Emite primero el estado actual obtenido mediante `checkConnectivity()`
/// y posteriormente emite cada cambio en tiempo real vía `onConnectivityChanged`.
final connectivityListProvider = StreamProvider<List<ConnectivityResult>>((
  ref,
) async* {
  final connectivity = Connectivity();
  try {
    final initial = await connectivity.checkConnectivity();
    yield initial;
  } catch (_) {
    yield [ConnectivityResult.none];
  }
  yield* connectivity.onConnectivityChanged;
});

/// Provider booleano simple que devuelve `true` si el dispositivo
/// tiene al menos una interfaz de red activa (WiFi, Móvil, Ethernet, VPN, etc.),
/// o `false` si no tiene ninguna (`ConnectivityResult.none` o lista vacía).
///
/// Uso:
/// ```dart
/// final isConnected = ref.watch(connectivityProvider);
/// if (!isConnected) { ... }
/// ```
final connectivityProvider = Provider<bool>((ref) {
  final connectivityAsync = ref.watch(connectivityListProvider);
  return connectivityAsync.maybeWhen(
    data: (results) =>
        results.isNotEmpty && results.any((r) => r != ConnectivityResult.none),
    orElse: () => true,
  );
});

/// Alias alternativo para mayor claridad semántica
final isConnectedProvider = connectivityProvider;

/// Provider que expone el estado como AsyncValue<bool>
/// por si se necesita reaccionar específicamente al estado de carga o error.
final connectivityStatusProvider = Provider<AsyncValue<bool>>((ref) {
  final connectivityAsync = ref.watch(connectivityListProvider);
  return connectivityAsync.whenData(
    (results) =>
        results.isNotEmpty && results.any((r) => r != ConnectivityResult.none),
  );
});

/// Servicio auxiliar para comprobaciones puntuales sin necesidad de Riverpod
class ConnectivityChecker {
  static Future<bool> hasConnection() async {
    try {
      final results = await Connectivity().checkConnectivity();
      return results.isNotEmpty &&
          results.any((r) => r != ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }
}
