import 'package:flutter_riverpod/legacy.dart';
import 'package:star_mesas_app/app/config/database/database.dart';
import 'package:star_mesas_app/app/config/provider/conexionProvider.dart';

class CacheState {
  final bool isLoading;
  final String? error;

  CacheState({this.isLoading = false, this.error});

  CacheState copyWith({bool? isLoading, String? error}) {
    return CacheState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class CacheNotifier extends StateNotifier<CacheState> {
  CacheNotifier() : super(CacheState()) {
    _init();
  }

  Future<void> _init() async {
    await loadFromCache();
  }

  Future<void> loadFromCache() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Error al cargar de caché local: $e",
      );
    }
  }

  /// Sincroniza desde las APIs, guarda en SQLite y actualiza el estado local
  Future<void> syncData() async {
    final hasNet = await ConnectivityChecker.hasConnection();
    if (!hasNet) {
      state = state.copyWith(
        isLoading: false,
        error: "Sin conexión a internet para sincronizar datos.",
      );
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      await loadFromCache();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Error sincronizando datos: $e",
      );
    }
  }

  Future<void> clearCache() async {
    await LocalDbService.instance.limpiarDatos();
    state = CacheState();
  }
}

final cacheProvider = StateNotifierProvider<CacheNotifier, CacheState>((ref) {
  return CacheNotifier();
});
