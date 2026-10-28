import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

// Standalone regression checks: dart run tool/security_smoke_test.dart
Future<void> main() async {
  final sandbox = Directory.systemTemp.createTempSync('hikee-security-');
  try {
    final output = Directory(path.join(sandbox.path, 'output'))..createSync();
    final archive = Archive()
      ..addFile(ArchiveFile('safe.txt', 1, [66]))
      ..addFile(ArchiveFile('../escaped.txt', 1, [65]));
    extractArchiveToDisk(archive, output.path);
    if (File(path.join(output.path, 'safe.txt')).readAsStringSync() != 'B') {
      throw StateError('Valid archive entries failed to extract');
    }
    if (File(path.join(sandbox.path, 'escaped.txt')).existsSync()) {
      throw StateError('Archive extraction escaped its output directory');
    }

    final client = Dio();
    try {
      await client.request('http://127.0.0.1:1/',
          options: Options(method: 'GET\r\nX-Injected: yes'));
      throw StateError('Dio accepted an invalid HTTP method');
    } on DioException catch (error) {
      if (error.error is! ArgumentError && error.error is! FormatException) {
        rethrow;
      }
    } on ArgumentError {
      // Invalid method rejected before network I/O.
    } finally {
      client.close(force: true);
    }
    stdout.writeln('Archive traversal and HTTP method injection checks passed.');
  } finally {
    sandbox.deleteSync(recursive: true);
  }
}
