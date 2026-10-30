import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A wrapper around [FlutterSecureStorage] that serializes all operations
/// sequentially and provides auto-recovery if DPAPI decryption fails on Windows.
class SafeSecureStorage {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static Future<void>? _pending;

  Future<T> _runSequential<T>(Future<T> Function() op) async {
    final previous = _pending;
    final completer = Completer<void>();
    _pending = completer.future;

    if (previous != null) {
      try {
        await previous;
      } catch (_) {}
    }

    try {
      return await op();
    } catch (e) {
      if (_isCorruptionError(e)) {
        await _deleteCorruptFile();
        try {
          return await op();
        } catch (_) {
          rethrow;
        }
      }
      rethrow;
    } finally {
      completer.complete();
    }
  }

  bool _isCorruptionError(Object e) {
    final msg = e.toString().toLowerCase();
    return msg.contains('cryptunprotectdata') ||
        msg.contains('failed to decrypt') ||
        msg.contains('corrupt') ||
        msg.contains('bad decrypt');
  }

  static Future<void> _deleteCorruptFile() async {
    try {
      if (!kIsWeb && Platform.isWindows) {
        final appData = Platform.environment['APPDATA'] ?? '';
        if (appData.isNotEmpty) {
          final file = File(
            '$appData\\com.example\\starsystem_punto_venta\\flutter_secure_storage.dat',
          );
          if (await file.exists()) {
            await file.delete();
          }
        }
      }
    } catch (_) {}
  }

  Future<void> write({required String key, required String? value}) {
    return _runSequential(() => _storage.write(key: key, value: value));
  }

  Future<String?> read({required String key}) {
    return _runSequential(() => _storage.read(key: key));
  }

  Future<Map<String, String>> readAll() {
    return _runSequential(() => _storage.readAll());
  }

  Future<void> delete({required String key}) {
    return _runSequential(() => _storage.delete(key: key));
  }

  Future<void> deleteAll() {
    return _runSequential(() => _storage.deleteAll());
  }
}
