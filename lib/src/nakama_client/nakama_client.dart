import 'package:nakama/src/session.dart' as model;

const _kDefaultAppKey = 'default';

/// This defines the interface to communicate with Nakama API. It is a little
/// tricky to support web (via REST) and io (via gRPC) with just one codebase
/// so please don't use this directly but get your fitting instance with
/// [getNakamaClient()].
abstract class NakamaBaseClient {
  NakamaBaseClient.init({
    String? host,
    String? serverKey,
    String key = _kDefaultAppKey,
    int httpPort = 7350,
    int grpcPort = 7349,
    bool ssl = false,
  });

  NakamaBaseClient();

  Future<String> getMatch(model.Session session);

/*  Future<model.Session> authenticateEmail({
    required String email,
    required String password,
    bool create = false,
    String? username,
    Map<String, String>? vars,
  });*/

  Future<model.Session> authenticateDevice({
    required String deviceId,
    required String userName
  });

  Future<model.Session> refreshSession({
    required String token,
  });
}

  /*Future<model.Session> authenticateFacebook({
    required String token,
    bool create = true,
    String? username,
    Map<String, String>? vars,
    bool import = false,
  });

  Future<model.Session> authenticateGoogle({
    required String token,
    bool create = true,
    String? username,
    Map<String, String>? vars,
  });

  Future<model.Session> authenticateGameCenter({
    required String playerId,
    required String bundleId,
    required int timestampSeconds,
    required String salt,
    required String signature,
    required String publicKeyUrl,
    bool create = true,
    String? username,
    Map<String, String>? vars,
  });

  Future<model.Session> authenticateSteam({
    required String token,
    bool create = true,
    String? username,
    Map<String, String>? vars,
  });

  Future<model.Session> authenticateApple({
    required String token,
    bool create = true,
    String? username,
    Map<String, String>? vars,
  });

  Future<model.Session> authenticateCustom({
    required String id,
    bool create = true,
    String? username,
    Map<String, String>? vars,
  });

  Future<Account> getAccount(model.Session session);

  Future<Users> getUsers({
    required model.Session session,
    List<String>? facebookIds,
    List<String>? ids,
    List<String>? usernames,
  });

  Future<void> writeStorageObject({
    String? collection,
    String? key,
    String? value,
    String? version,
    StorageWritePermission? writePermission,
    StorageReadPermission? readPermission,
  });

  Future<ApiSession> sessionRefreshRequest({
    required String token,
    Map<String, String>? vars,
  });

  Future<dynamic> linkDevice({
    required String id,
    required model.Session session,
    Map<String, String>? vars,
  });

  Future<dynamic> linkApple({
    required String token,
    required model.Session session,
    Map<String, String>? vars,
  });

  Future<dynamic> linkGoogle({
    required String token,
    required model.Session session,
    Map<String, String>? vars,
  });

  Future<dynamic> linkFacebook({
    required String token,
    required model.Session session,
    Map<String, String>? vars,
  });

  Future<dynamic> sessionLogout({ required model.Session session});

  Future<dynamic> linkGameCenter(
      {String? playerId,
      String? bundleId,
      String? timestampSeconds,
      String? salt,
      String? signature,
      String? publicKeyUrl,
      Map<String, String>? vars});
}
*/