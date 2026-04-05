import 'package:drift_postgres/drift_postgres.dart';

class ScheduleService {}

class CreateScheduleRequest {
  final UuidValue socialAccountTargetId;
  final DateTime scheduledAt;
  final UuidValue? templateId;
  final String? captionBody;
  final Map<String, dynamic>? templateVariables;

  const CreateScheduleRequest({
    required this.socialAccountTargetId,
    required this.scheduledAt,
    this.templateId,
    this.captionBody,
    this.templateVariables = const {},
  });

  factory CreateScheduleRequest.fromJson(Map<String, dynamic> json) {
    return CreateScheduleRequest(
      socialAccountTargetId: UuidValue.withValidation(
        json['social_account_target_id'] as String,
      ),
      scheduledAt: DateTime.parse(json['scheduled_at'] as String).toUtc(),
      templateId: json['template_id'] != null
          ? UuidValue.withValidation(json['template_id'] as String)
          : null,
      captionBody: json['caption_body'] as String?,
      templateVariables:
          json['template_variables'] as Map<String, dynamic>? ?? {},
    );
  }
}
