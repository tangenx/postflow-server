import 'dart:io';

import 'package:postflow_server/di.dart';
import 'package:postflow_server/routes/router.dart';
import 'package:shelf/shelf_io.dart';

void main(List<String> args) async {
  registerDependencies();

  final handler = buildRouter();

  final ip = InternetAddress.anyIPv4;

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
