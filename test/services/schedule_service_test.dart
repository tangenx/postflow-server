import 'package:drift_postgres/drift_postgres.dart';
import 'package:test/test.dart' hide isNotNull;
import 'package:postflow_server/core/exceptions.dart';
import 'package:postflow_server/database/database.dart';
import 'package:postflow_server/database/tables/posts.dart';
import 'package:postflow_server/database/tables/post_schedules.dart' show ScheduleStatus;
import 'package:postflow_server/services/caption_service.dart';
import 'package:postflow_server/services/schedule_service.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class FakeScheduleDao implements ScheduleDao {
  List<PostSchedule> createdSchedules = [];
  List<PostCaption> createdCaptions = [];
  int createScheduleCallCount = 0;
  int createCaptionCallCount = 0;

  PostSchedule? retryResult;
  UuidValue? retryPostScheduleId;
  UuidValue? retryUserId;
  DateTime? retryScheduledAt;

  int cancelCalled = 0;
  UuidValue? cancelPostScheduleId;
  UuidValue? cancelUserId;

  List<ScheduleWithDetails>? findSchedulesForPostResult;
  List<ScheduleWithDetails> Function(UuidValue postId, UuidValue userId)?
      findSchedulesForPostFn;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<PostSchedule> createSchedule({
    required UuidValue postId,
    required UuidValue socialAccountTargetId,
    required DateTime scheduledAt,
  }) async {
    createScheduleCallCount++;
    final schedule = PostSchedule(
      id: UuidValue.fromString(
        '44444444-4444-4444-4444-4444444444${createScheduleCallCount.toString().padLeft(2, '0')}',
      ),
      postId: postId,
      socialAccountTargetId: socialAccountTargetId,
      scheduledAt: PgDateTime(scheduledAt),
      status: ScheduleStatus.pending,
      createdAt: PgDateTime(DateTime.utc(2025, 1, 1)),
      updatedAt: PgDateTime(DateTime.utc(2025, 1, 1)),
    );
    createdSchedules.add(schedule);
    return schedule;
  }

  @override
  Future<PostCaption> createCaption({
    required UuidValue postScheduleId,
    required String renderedBody,
    UuidValue? templateId,
    Map<String, dynamic>? templateVariables,
  }) async {
    createCaptionCallCount++;
    final caption = PostCaption(
      id: UuidValue.fromString(
        '88888888-8888-8888-8888-8888888888${createCaptionCallCount.toString().padLeft(2, '0')}',
      ),
      postScheduleId: postScheduleId,
      renderedBody: renderedBody,
      templateId: templateId,
      variableOverrides: templateVariables ?? {},
    );
    createdCaptions.add(caption);
    return caption;
  }

  @override
  Future<List<ScheduleWithDetails>> findSchedulesForPost(
    UuidValue postId,
    UuidValue userId,
  ) async =>
      findSchedulesForPostFn?.call(postId, userId) ??
      (findSchedulesForPostResult ?? []);

  @override
  Future<PostSchedule> retry({
    required UuidValue postScheduleId,
    required UuidValue userId,
    required DateTime scheduledAt,
  }) async {
    retryPostScheduleId = postScheduleId;
    retryUserId = userId;
    retryScheduledAt = scheduledAt;
    return retryResult!;
  }

  @override
  Future<void> cancel(UuidValue postScheduleId, UuidValue userId) async {
    cancelCalled++;
    cancelPostScheduleId = postScheduleId;
    cancelUserId = userId;
  }
}

class FakeSocialAccountTargetsDao implements SocialAccountTargetsDao {
  bool belongsToUserResult = true;
  UuidValue? belongsToUserTargetId;
  UuidValue? belongsToUserUserId;
  int belongsToUserCallCount = 0;

  SocialAccountTarget? findByIdResult;
  UuidValue? findByIdArg;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<bool> belongsToUser(UuidValue targetId, UuidValue userId) async {
    belongsToUserCallCount++;
    belongsToUserTargetId = targetId;
    belongsToUserUserId = userId;
    return belongsToUserResult;
  }

  @override
  Future<SocialAccountTarget?> findById(UuidValue id) async {
    findByIdArg = id;
    return findByIdResult;
  }
}

class FakePostsDao implements PostsDao {
  PostWithRelations? findPostWithRelationsResult;
  UuidValue? findPostWithRelationsId;
  UuidValue? findPostWithRelationsUserId;

  Post? findPostByIdResult;
  UuidValue? findPostByIdId;
  UuidValue? findPostByIdUserId;

  PostStatus? updatePostStatus;
  UuidValue? updatePostId;
  UuidValue? updatePostUserId;
  int updatePostCallCount = 0;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<PostWithRelations?> findPostWithRelationsById(
    UuidValue id,
    UuidValue userId,
  ) async {
    findPostWithRelationsId = id;
    findPostWithRelationsUserId = userId;
    return findPostWithRelationsResult;
  }

  @override
  Future<Post?> findPostById(UuidValue id, UuidValue userId) async {
    findPostByIdId = id;
    findPostByIdUserId = userId;
    return findPostByIdResult;
  }

  @override
  Future<Post> updatePost({
    required UuidValue id,
    required UuidValue userId,
    String? internalNote,
    String? description,
    PostStatus? status,
  }) async {
    updatePostCallCount++;
    updatePostId = id;
    updatePostUserId = userId;
    updatePostStatus = status;
    return Post(
      id: id,
      createdBy: userId,
      status: status ?? PostStatus.draft,
      createdAt: PgDateTime(DateTime.utc(2025, 1, 1)),
      updatedAt: PgDateTime(DateTime.utc(2025, 1, 1)),
    );
  }
}

class FakeCaptionTemplatesDao implements CaptionTemplatesDao {
  CaptionTemplate? findByIdResult;
  UuidValue? findByIdArg;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<CaptionTemplate?> findById(UuidValue id) async {
    findByIdArg = id;
    return findByIdResult;
  }
}

class FakeCaptionService implements CaptionService {
  String? lastTemplateBody;
  PostWithRelations? lastPost;
  SocialAccountTarget? lastTarget;
  Map<String, Object>? lastCustomVariables;
  String renderResult = 'Rendered caption';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  String renderWithCustomVariables({
    required String templateBody,
    required PostWithRelations post,
    required SocialAccountTarget target,
    required Map<String, Object> customVariables,
  }) {
    lastTemplateBody = templateBody;
    lastPost = post;
    lastTarget = target;
    lastCustomVariables = customVariables;
    return renderResult;
  }

  @override
  String render({
    required String templateBody,
    required Map<String, String> variables,
  }) => renderResult;

  @override
  Map<String, String> buildVariables({
    required PostWithRelations post,
    required SocialAccountTarget target,
  }) => {};
}

class FakeDatabase implements PostflowDatabase {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == Symbol('transaction')) {
      final fn = invocation.positionalArguments[0] as Future Function();
      return fn();
    }
    return super.noSuchMethod(invocation);
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _userId = 'a10e8400-e29b-41d4-a716-446655440000';
const _postId = 'b20e8400-e29b-41d4-a716-446655440001';
const _targetId = 'c30e8400-e29b-41d4-a716-446655440002';
const _scheduleId = 'd40e8400-e29b-41d4-a716-446655440003';
const _templateId = 'e50e8400-e29b-41d4-a716-446655440004';
const _accountId = 'f60e8400-e29b-41d4-a716-446655440005';
const _networkId = 'a70e8400-e29b-41d4-a716-446655440006';

final _scheduledAt = DateTime.utc(2025, 6, 15, 12, 0, 0);

final _testPost = Post(
  id: UuidValue.fromString(_postId),
  createdBy: UuidValue.fromString(_userId),
  status: PostStatus.draft,
  createdAt: PgDateTime(DateTime.utc(2025, 1, 1)),
  updatedAt: PgDateTime(DateTime.utc(2025, 1, 1)),
);

final _testPostWithRelations = PostWithRelations(
  post: _testPost,
  media: [],
  artists: [],
  characters: [],
  franchises: [],
);

final _testTarget = SocialAccountTarget(
  id: UuidValue.fromString(_targetId),
  userSocialAccountId: UuidValue.fromString(_accountId),
  targetType: 'user',
  targetId: '12345',
  targetLabel: 'Test Target',
  shortLink: 'test_link',
  isActive: true,
);

final _testAccount = UserSocialAccount(
  id: UuidValue.fromString(_accountId),
  userId: UuidValue.fromString(_userId),
  socialNetworkId: UuidValue.fromString(_networkId),
  externalAccountId: 'ext_123',
  screenName: 'testuser',
  accessToken: 'token',
  refreshToken: 'refresh',
  tokenExpiresAt: PgDateTime(DateTime.utc(2026)),
  isActive: true,
  createdAt: PgDateTime(DateTime.utc(2025)),
);

final _testNetwork = SocialNetwork(
  id: UuidValue.fromString(_networkId),
  slug: 'test_network',
  displayName: 'Test Network',
  capabilities: '{}',
  isActive: true,
);

final _testSchedule = PostSchedule(
  id: UuidValue.fromString(_scheduleId),
  postId: UuidValue.fromString(_postId),
  socialAccountTargetId: UuidValue.fromString(_targetId),
  scheduledAt: PgDateTime(_scheduledAt),
  status: ScheduleStatus.pending,
  createdAt: PgDateTime(DateTime.utc(2025, 1, 1)),
  updatedAt: PgDateTime(DateTime.utc(2025, 1, 1)),
);

final _testScheduleWithDetails = ScheduleWithDetails(
  schedule: _testSchedule,
  target: _testTarget,
  account: _testAccount,
  network: _testNetwork,
);

final _testTemplate = CaptionTemplate(
  id: UuidValue.fromString(_templateId),
  ownerId: UuidValue.fromString(_userId),
  name: 'Test Template',
  body: 'Hello {{character}}!',
  variables: [
    TemplateVariable(name: 'character', asHashtag: false),
  ],
  isGlobal: false,
  createdAt: PgDateTime(DateTime.utc(2025)),
  updatedAt: PgDateTime(DateTime.utc(2025)),
);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late FakeScheduleDao fakeScheduleDao;
  late FakeSocialAccountTargetsDao fakeTargetsDao;
  late FakePostsDao fakePostsDao;
  late FakeCaptionTemplatesDao fakeTemplatesDao;
  late FakeCaptionService fakeCaptionService;
  late FakeDatabase fakeDb;
  late ScheduleService service;

  setUp(() {
    fakeScheduleDao = FakeScheduleDao();
    fakeTargetsDao = FakeSocialAccountTargetsDao();
    fakePostsDao = FakePostsDao();
    fakeTemplatesDao = FakeCaptionTemplatesDao();
    fakeCaptionService = FakeCaptionService();
    fakeDb = FakeDatabase();
    service = ScheduleService(
      scheduleDao: fakeScheduleDao,
      postsDao: fakePostsDao,
      db: fakeDb,
      socialAccountTargetsDao: fakeTargetsDao,
      captionService: fakeCaptionService,
      captionTemplatesDao: fakeTemplatesDao,
    );
  });

  group('ScheduleService', () {
    group('createSchedules', () {
      test('creates schedules and returns them', () async {
        fakePostsDao.findPostWithRelationsResult = _testPostWithRelations;
        fakeScheduleDao.findSchedulesForPostFn =
            (postId, userId) => fakeScheduleDao.createdSchedules.map(
              (s) => ScheduleWithDetails(
                schedule: s,
                target: _testTarget,
                account: _testAccount,
                network: _testNetwork,
              ),
            ).toList();

        final result = await service.createSchedules(
          userId: UuidValue.fromString(_userId),
          postId: UuidValue.fromString(_postId),
          requests: [
            CreateScheduleRequest(
              socialAccountTargetId: UuidValue.fromString(_targetId),
              scheduledAt: _scheduledAt,
            ),
          ],
        );

        expect(result, hasLength(1));
        expect(fakeScheduleDao.createScheduleCallCount, 1);
        expect(fakeTargetsDao.belongsToUserCallCount, 1);
      });

      test('throws NotFoundException when post not found', () {
        fakePostsDao.findPostWithRelationsResult = null;

        expect(
          () => service.createSchedules(
            userId: UuidValue.fromString(_userId),
            postId: UuidValue.fromString(_postId),
            requests: [
              CreateScheduleRequest(
                socialAccountTargetId: UuidValue.fromString(_targetId),
                scheduledAt: _scheduledAt,
              ),
            ],
          ),
          throwsA(
            isA<NotFoundException>().having(
              (e) => e.message,
              'message',
              contains('Post not found'),
            ),
          ),
        );
      });

      test('throws NotFoundException when target does not belong to user', () {
        fakePostsDao.findPostWithRelationsResult = _testPostWithRelations;
        fakeTargetsDao.belongsToUserResult = false;

        expect(
          () => service.createSchedules(
            userId: UuidValue.fromString(_userId),
            postId: UuidValue.fromString(_postId),
            requests: [
              CreateScheduleRequest(
                socialAccountTargetId: UuidValue.fromString(_targetId),
                scheduledAt: _scheduledAt,
              ),
            ],
          ),
          throwsA(
            isA<NotFoundException>().having(
              (e) => e.message,
              'message',
              contains('Social account target not found'),
            ),
          ),
        );
      });

      test('calls captionService when templateId provided', () async {
        fakePostsDao.findPostWithRelationsResult = _testPostWithRelations;
        fakeScheduleDao.findSchedulesForPostFn =
            (postId, userId) => fakeScheduleDao.createdSchedules.map(
              (s) => ScheduleWithDetails(
                schedule: s,
                target: _testTarget,
                account: _testAccount,
                network: _testNetwork,
              ),
            ).toList();
        fakeTemplatesDao.findByIdResult = _testTemplate;
        fakeTargetsDao.findByIdResult = _testTarget;

        await service.createSchedules(
          userId: UuidValue.fromString(_userId),
          postId: UuidValue.fromString(_postId),
          requests: [
            CreateScheduleRequest(
              socialAccountTargetId: UuidValue.fromString(_targetId),
              scheduledAt: _scheduledAt,
              templateId: UuidValue.fromString(_templateId),
            ),
          ],
        );

        expect(fakeCaptionService.lastTemplateBody, _testTemplate.body);
        expect(fakeCaptionService.lastPost, _testPostWithRelations);
        expect(fakeCaptionService.lastTarget, _testTarget);
        expect(fakeScheduleDao.createCaptionCallCount, 1);
      });

      test('uses captionBody directly when provided', () async {
        fakePostsDao.findPostWithRelationsResult = _testPostWithRelations;
        fakeScheduleDao.findSchedulesForPostFn =
            (postId, userId) => fakeScheduleDao.createdSchedules.map(
              (s) => ScheduleWithDetails(
                schedule: s,
                target: _testTarget,
                account: _testAccount,
                network: _testNetwork,
              ),
            ).toList();

        await service.createSchedules(
          userId: UuidValue.fromString(_userId),
          postId: UuidValue.fromString(_postId),
          requests: [
            CreateScheduleRequest(
              socialAccountTargetId: UuidValue.fromString(_targetId),
              scheduledAt: _scheduledAt,
              captionBody: 'Direct caption',
            ),
          ],
        );

        // captionService should NOT be called when captionBody is provided
        expect(fakeCaptionService.lastTemplateBody, isNull);
        expect(fakeScheduleDao.createCaptionCallCount, 1);
        expect(fakeScheduleDao.createdCaptions.first.renderedBody, 'Direct caption');
      });

      test('creates caption with rendered body', () async {
        fakePostsDao.findPostWithRelationsResult = _testPostWithRelations;
        fakeScheduleDao.findSchedulesForPostFn =
            (postId, userId) => fakeScheduleDao.createdSchedules.map(
              (s) => ScheduleWithDetails(
                schedule: s,
                target: _testTarget,
                account: _testAccount,
                network: _testNetwork,
              ),
            ).toList();
        fakeTemplatesDao.findByIdResult = _testTemplate;
        fakeTargetsDao.findByIdResult = _testTarget;
        fakeCaptionService.renderResult = 'Rendered: Hello World!';

        await service.createSchedules(
          userId: UuidValue.fromString(_userId),
          postId: UuidValue.fromString(_postId),
          requests: [
            CreateScheduleRequest(
              socialAccountTargetId: UuidValue.fromString(_targetId),
              scheduledAt: _scheduledAt,
              templateId: UuidValue.fromString(_templateId),
            ),
          ],
        );

        expect(
          fakeScheduleDao.createdCaptions.first.renderedBody,
          'Rendered: Hello World!',
        );
      });

      test('updates post status to ready after creation', () async {
        fakePostsDao.findPostWithRelationsResult = _testPostWithRelations;
        fakeScheduleDao.findSchedulesForPostFn =
            (postId, userId) => fakeScheduleDao.createdSchedules.map(
              (s) => ScheduleWithDetails(
                schedule: s,
                target: _testTarget,
                account: _testAccount,
                network: _testNetwork,
              ),
            ).toList();

        await service.createSchedules(
          userId: UuidValue.fromString(_userId),
          postId: UuidValue.fromString(_postId),
          requests: [
            CreateScheduleRequest(
              socialAccountTargetId: UuidValue.fromString(_targetId),
              scheduledAt: _scheduledAt,
            ),
          ],
        );

        expect(fakePostsDao.updatePostCallCount, 1);
        expect(fakePostsDao.updatePostStatus, PostStatus.ready);
        expect(fakePostsDao.updatePostId, UuidValue.fromString(_postId));
        expect(fakePostsDao.updatePostUserId, UuidValue.fromString(_userId));
      });

      test('wraps everything in a transaction', () async {
        fakePostsDao.findPostWithRelationsResult = _testPostWithRelations;
        fakeScheduleDao.findSchedulesForPostFn =
            (postId, userId) => fakeScheduleDao.createdSchedules.map(
              (s) => ScheduleWithDetails(
                schedule: s,
                target: _testTarget,
                account: _testAccount,
                network: _testNetwork,
              ),
            ).toList();

        // FakeDatabase runs transaction callbacks inline,
        // so this just verifies no crash.
        final result = await service.createSchedules(
          userId: UuidValue.fromString(_userId),
          postId: UuidValue.fromString(_postId),
          requests: [
            CreateScheduleRequest(
              socialAccountTargetId: UuidValue.fromString(_targetId),
              scheduledAt: _scheduledAt,
            ),
          ],
        );

        expect(result, isNotEmpty);
        expect(fakeScheduleDao.createScheduleCallCount, 1);
        expect(fakePostsDao.updatePostCallCount, 1);
      });
    });

    group('getByPostId', () {
      test('returns schedules from DAO', () async {
        fakePostsDao.findPostByIdResult = _testPost;
        fakeScheduleDao.findSchedulesForPostResult = [_testScheduleWithDetails];

        final result = await service.getByPostId(
          UuidValue.fromString(_postId),
          UuidValue.fromString(_userId),
        );

        expect(result, hasLength(1));
        expect(result.first.schedule.id, UuidValue.fromString(_scheduleId));
      });

      test('throws NotFoundException when post not found', () {
        fakePostsDao.findPostByIdResult = null;

        expect(
          () => service.getByPostId(
            UuidValue.fromString(_postId),
            UuidValue.fromString(_userId),
          ),
          throwsA(
            isA<NotFoundException>().having(
              (e) => e.message,
              'message',
              contains('Post not found'),
            ),
          ),
        );
      });
    });

    group('retrySchedule', () {
      test('delegates to DAO retry and returns result', () async {
        fakeScheduleDao.retryResult = _testSchedule;

        final result = await service.retrySchedule(
          postScheduleId: UuidValue.fromString(_scheduleId),
          userId: UuidValue.fromString(_userId),
          scheduledAt: _scheduledAt,
        );

        expect(result, _testSchedule);
        expect(
          fakeScheduleDao.retryPostScheduleId,
          UuidValue.fromString(_scheduleId),
        );
        expect(
          fakeScheduleDao.retryUserId,
          UuidValue.fromString(_userId),
        );
        expect(fakeScheduleDao.retryScheduledAt, _scheduledAt);
      });
    });

    group('cancelSchedule', () {
      test('delegates to DAO cancel', () async {
        await service.cancelSchedule(
          UuidValue.fromString(_scheduleId),
          UuidValue.fromString(_userId),
        );

        expect(fakeScheduleDao.cancelCalled, 1);
        expect(
          fakeScheduleDao.cancelPostScheduleId,
          UuidValue.fromString(_scheduleId),
        );
        expect(
          fakeScheduleDao.cancelUserId,
          UuidValue.fromString(_userId),
        );
      });
    });
  });
}
