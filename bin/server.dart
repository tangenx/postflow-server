import 'dart:io';

import 'package:postflow_server/config/app_config.dart';
import 'package:postflow_server/di.dart';
import 'package:postflow_server/routes/router.dart';
import 'package:postflow_server/services/publisher_service.dart';
import 'package:postflow_server/utils/logger.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';

const _log = Logger('Server');

void main(List<String> args) async {
  registerDependencies();

  withHotreload(
    () => createServer(),
    onReloaded: () => _log.info('Server reloaded'),
    onHotReloadNotAvailable: () => _log.warning('Hot reload not available'),
    onHotReloadAvailable: () => _log.info('Hot reload available'),
    onHotReloadLog: (log) => _log.info(log.message),
  );

  await PublisherService.spawn(sl.get<AppConfig>());
}

Future<HttpServer> createServer() {
  final ip = InternetAddress.anyIPv4;

  final handler = buildRouter();
  final port = int.parse(Platform.environment['SERVER_PORT'] ?? '8080');

  _log.info('Running server on http://${ip.address}:$port');

  return serve(handler, ip, port);
}
