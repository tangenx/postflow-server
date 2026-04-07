import 'package:shelf_router/shelf_router.dart';

import '../handlers/social_account_target_handler.dart';
import '../handlers/user_social_account_handler.dart';

Router socialRoutes(
  SocialAccountTargetHandler socialAccountTargetHandler,
  UserSocialAccountHandler userSocialAccountHandler,
) {
  final router = Router();

  router.get('/', userSocialAccountHandler.getAccounts);
  router.get('/<id>', userSocialAccountHandler.getAccount);
  router.post('/', userSocialAccountHandler.create);
  router.put('/<id>', userSocialAccountHandler.update);
  router.delete('/<id>', userSocialAccountHandler.delete);

  router.get('/<accountId>/targets', socialAccountTargetHandler.getTargets);
  router.post('/<accountId>/targets', socialAccountTargetHandler.create);
  router.put('/targets/<targetId>', socialAccountTargetHandler.update);
  router.delete('/targets/<targetId>', socialAccountTargetHandler.delete);

  return router;
}
