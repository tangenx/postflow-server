import 'package:drift_postgres/drift_postgres.dart';
import 'package:postflow_server/utils/request_validation.dart';
import 'package:shelf/shelf.dart';

import '../services/schedule_service.dart';
import '../utils/api_response.dart';

class ScheduleHandler {
  final ScheduleService _scheduleService;

  ScheduleHandler(this._scheduleService);

  /// GET /api/schedules/posts/:postId
  Future<Response> getByPost(Request request, String postId) async {
    final userId = request.context['userId'] as UuidValue;

    final schedules = await _scheduleService.getByPostId(
      UuidValue.withValidation(postId),
      userId,
    );

    return ApiResponse.ok(schedules.map((s) => s.toJson()).toList());
  }

  /// POST /api/schedules/posts/:postId
  /// {
  ///   "schedules": [
  ///     "socialAccountTargetId": "00000000-0000-0000-0000-000000000000",
  ///     "scheduledAt": "2022-01-01T00:00:00.000Z",
  ///     "templateId": "00000000-0000-0000-0000-000000000000",
  ///     "captionBody": "Hello, world!",
  ///     "templateVariables": {
  ///       "character": "John Doe"
  ///     }
  ///   ]
  /// }
  Future<Response> createSchedules(Request request, String postId) async {
    final userId = request.context['userId'] as UuidValue;
    final validPostId = UuidValue.withValidation(postId);
    final body = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );

    final requestsBody = body['schedules'] as List<dynamic>;
    final requests = requestsBody
        .map((r) => CreateScheduleRequest.fromJson(r as Map<String, dynamic>))
        .toList();

    final schedules = await _scheduleService.createSchedules(
      userId: userId,
      postId: validPostId,
      requests: requests,
    );

    return ApiResponse.ok(schedules.map((s) => s.toJson()).toList());
  }

  /// POST /api/schedules/:postScheduleId/retry
  /// { "scheduledAt": "2022-01-01T00:00:00.000Z" }
  Future<Response> retrySchedule(Request request, String postScheduleId) async {
    final userId = request.context['userId'] as UuidValue;
    final validPostScheduleId = UuidValue.withValidation(postScheduleId);
    final body = RequestValidation.parseJsonObject(
      await request.readAsString(),
    );

    final bodyScheduledAt = RequestValidation.requiredString(
      body,
      'scheduledAt',
    );
    final scheduledAt = DateTime.parse(bodyScheduledAt).toUtc();

    final schedule = await _scheduleService.retrySchedule(
      postScheduleId: validPostScheduleId,
      userId: userId,
      scheduledAt: scheduledAt,
    );

    return ApiResponse.ok(schedule.toJson());
  }

  /// POST /api/schedules/:postScheduleId/cancel
  Future<Response> cancelSchedule(
    Request request,
    String postScheduleId,
  ) async {
    final userId = request.context['userId'] as UuidValue;
    final validPostScheduleId = UuidValue.withValidation(postScheduleId);

    await _scheduleService.cancelSchedule(validPostScheduleId, userId);

    return ApiResponse.ok(null);
  }
}
