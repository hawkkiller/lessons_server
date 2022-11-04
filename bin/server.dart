import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'feature/parse_lesson/handler/parse_html_handler.dart';

// Configure routes.
final _router = Router()..post('/parse-lesson', parseLessonHandler);

void main(List<String> args) => runZonedGuarded(
      () async {
        // Use any available host or container IP (usually `0.0.0.0`).
        final ip = InternetAddress.anyIPv4;

        // Configure a pipeline that logs requests.
        final handler = Pipeline().addMiddleware(logRequests()).addHandler(
              _router,
            );

        // For running in containers, we respect the PORT environment variable.
        final port = int.parse(Platform.environment['PORT'] ?? _throw());
        final server = await serve(handler, ip, port);
        print('Server listening on port ${server.port}');
      },
      (error, stack) {
        Zone.current.print('$error\n$stack');
      },
    );

Never _throw() => throw ArgumentError.notNull();
