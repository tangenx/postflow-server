import 'package:shelf_router/shelf_router.dart';

import '../handlers/schedule_handler.dart';

Router scheduleRoutes(ScheduleHandler handler) {
  final router = Router();

  // for posts
  router.post('/posts/:postId', handler.createSchedules);
  router.get('/posts/:postId', handler.getByPost);

  // control created schedules
  router.post('/:postScheduleId/retry', handler.retrySchedule);
  router.post('/:postScheduleId/cancel', handler.cancelSchedule);

  return router;
}
