import 'dart:convert';

import 'package:html/parser.dart' as parser show parse;
import 'package:shelf/shelf.dart';

import '../../../core/exceptions/request_exception.dart';

Future<Response> parseLessonHandler(Request req) async {
  try {
    final body = await req.readAsString();
    if (body.isEmpty) {
      throw BadRequest(
        message: 'Bad request: data is empty',
        data: body,
      );
    }
    final decoded = jsonDecode(body);

    if (decoded is! Map<String, dynamic>) {
      throw BadRequest(
        message: 'Bad request: data is not a Map<String, dynamic>',
        data: decoded,
      );
    }

    final lesson = decoded['textHtml'] as String?;

    if (lesson == null) {
      throw BadRequest(
        message: 'Bad request: field "textHtml" is not found',
        data: lesson,
      );
    }
    final doc = parser.parse(lesson);

    final importantData = doc.body?.text.split('.').take(2).join('. ') ?? '';
    return Response.ok(
      json.encode({
        'data': importantData.trim(),
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  } on RequestException catch (e) {
    return Response(e.statusCode, body: e.toString());
  } on Object catch (e) {
    return Response(500, body: 'Unknown exception was thrown: $e');
  }
}
