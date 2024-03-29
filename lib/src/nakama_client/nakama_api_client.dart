import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:nakama/nakama.dart';
import 'package:nakama/src/rest/apigrpc.swagger.dart';
import 'package:nakama/src/session.dart' as model;

import 'nakama_client.dart';

const _kDefaultAppKey = 'default';

/// Base class for communicating with Nakama via gRPC.
/// [NakamaGrpcClient] abstracts the gRPC calls and handles authentication
/// for you.
class NakamaRestApiClient extends NakamaBaseClient {
  static final Map<String, NakamaRestApiClient> _clients = {};

  late final ChopperClient _chopperClient;

  /// The key used to authenticate with the server without a session.
  /// Defaults to "defaultkey".
  late final String serverKey;

  /// Temporarily holds the current valid session to use in the Chopper
  /// interceptor for JWT auth.
  model.Session? _session = null;

  /// Either inits and returns a new instance of [NakamaRestApiClient] or
  /// returns a already initialized one.
  factory NakamaRestApiClient.init({
    String? host,
    String? serverKey,
    String key = _kDefaultAppKey,
    int port = 7350,
    bool ssl = false,
  }) {
    if (_clients.containsKey(key)) {
      return _clients[key]!;
    }

    // Not yet initialized -> check if we've got all parameters to do so
    if (host == null || serverKey == null) {
      throw Exception(
        'Not yet initialized, need parameters [host] and [serverKey] to initialize.',
      );
    }

    // Create a new instance of this with given parameters.
    return _clients[key] = NakamaRestApiClient._(
      host: host,
      port: port,
      serverKey: serverKey,
      ssl: ssl,
    );
  }

  NakamaRestApiClient._({
    required String host,
    required String serverKey,
    required int port,
    required bool ssl,
  }) {
    _chopperClient = ChopperClient(
      converter: JsonSerializableConverter(),
      baseUrl: Uri(
        host: host,
        scheme: ssl ? 'https' : 'http',
        port: port,
      ).toString(),
      services: [Apigrpc.create()],
      interceptors: [
        // Auth Interceptor
        (Request request) async {
          // Server Key Auth
          if (_session == null) {
            return applyHeader(
              request,
              'Authorization',
              'Basic ' + base64Encode('$serverKey:'.codeUnits),
            );
          }

          // User's JWT auth
          return applyHeader(
            request,
            'Authorization',
            'Bearer ${_session!.token}',
          );
        },
      ],
    );
  }

  Apigrpc get _api => _chopperClient.getService<Apigrpc>();

  @override
  Future<String> getMatch(model.Session session) async {
    /* _session = session;
    final res = await _api.matchCreate();

    if (res.error != null) {
      throw FormatException('Authentication failed.', res.error);
    }

    final data = res.body!;
    final matchId = json.decode(data.payload ?? '')['matchId'];

    return matchId;*/
    return '';
  }

/*  @override
  Future<model.Session> authenticateEmail({
    required String email,
    required String password,
    bool create = true,
    String? username,
    Map<String, String>? vars,
  }) async {
    final res = await _api.nakamaAuthenticateEmail(
      body: ApiAccountEmail(
        email: email,
        password: password,
        vars: vars,
      ),
      create: create,
      username: username,
    );

    if (res.error != null) {
      throw FormatException('Authentication failed.', res.error);
    }

    final data = res.body!;

    return model.Session(
      created: data.created ?? false,
      token: data.token!,
      refreshToken: data.refreshToken,
    );
  }*/

  @override
  Future<model.Session> authenticateDevice({
    required String deviceId,
    required String userName,
  }) async {
    final res = await _api.colyseusAuthenticateDevice(
      body: ApiAccountDeviceColyseus(
        deviceId: deviceId,
        username: userName,
      ),
    );

    if (res.error != null) {
      throw FormatException('Authentication failed.', res.error);
    }

    final data = res.body!.data!;

    final newSession = model.Session(
        token: data.token!,
        expiresAt: data.expiresAt!,
        refreshToken: data.refreshToken!,
        refreshExpiresAt: data.refreshExpiresAt!);

    _session = newSession;

    return newSession;
  }

  @override
  Future<model.Session> refreshSession({
    required String token,
  }) async {
    final res = await _api.colyseusSessionRefresh(
      body: ApiSessionRefreshRequest(refreshToken: token),
    );

    if (res.error != null) {
      throw FormatException('RefreshSession failed.', res.error);
    }

    final data = res.body!.data!;

    _session = model.Session(
        token: data.token!,
        expiresAt: data.expiresAt!,
        refreshToken: data.refreshToken!,
        refreshExpiresAt: data.refreshExpiresAt!);

    return _session!;
  }

  @override
  Future<MatchData> joinOrCreateMatch() async {
    final res = await _api.colyseusJoinOrCreateMatch(
        body: ApiJoinOrCreateMatchRequest(token: _session?.token));

    if (res.error != null) {
      throw FormatException('joinOrCreateMatch failed.', res.error);
    }

    final roomId = res.body?.room?.roomId;
    final processId = res.body?.room?.processId;
    final sessionId = res.body?.sessionId;

    if (roomId != null && processId != null && sessionId != null) {
      return model.MatchData(
          roomId: roomId, processId: processId, sessionId: sessionId);
    } else {
      throw FormatException(
          'Not received roomId || processId || sessionId', res.error);
    }
  }

  /* @override
  Future<model.Session> authenticateFacebook({
    required String token,
    bool create = true,
    String? username,
    Map<String, String>? vars,
    bool import = false,
  }) async {
    _session = null;
    final res = await _api.nakamaAuthenticateFacebook(
      body: ApiAccountFacebook(
        token: token,
        vars: vars,
      ),
      $sync: import,
      create: create,
      username: username,
    );

    if (res.error != null) {
      throw FormatException('Authentication failed.', res.error);
    }

    final data = res.body!;

    return model.Session(
      created: data.created ?? false,
      token: data.token!,
      refreshToken: data.refreshToken,
    );
  }

  @override
  Future<model.Session> authenticateGoogle({
    required String token,
    bool create = true,
    String? username,
    Map<String, String>? vars,
  }) async {
    _session = null;
    final res = await _api.nakamaAuthenticateGoogle(
      body: ApiAccountGoogle(
        token: token,
        vars: vars,
      ),
      create: create,
      username: username,
    );

    if (res.error != null) {
      throw FormatException('Authentication failed.', res.error);
    }

    final data = res.body!;

    return model.Session(
      created: data.created ?? false,
      token: data.token!,
      refreshToken: data.refreshToken,
    );
  }

  @override
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
  }) async {
    _session = null;
    final res = await _api.nakamaAuthenticateGameCenter(
      body: ApiAccountGameCenter(
        playerId: playerId,
        bundleId: bundleId,
        timestampSeconds: timestampSeconds.toString(),
        salt: salt,
        signature: signature,
        publicKeyUrl: publicKeyUrl,
        vars: vars,
      ),
      create: create,
      username: username,
    );

    if (res.error != null) {
      throw FormatException('Authentication failed.', res.error);
    }

    final data = res.body!;

    return model.Session(
      created: data.created ?? false,
      token: data.token!,
      refreshToken: data.refreshToken,
    );
  }

  @override
  Future<model.Session> authenticateSteam({
    required String token,
    bool create = true,
    String? username,
    Map<String, String>? vars,
  }) async {
    final res = await _api.nakamaAuthenticateSteam(
      body: ApiAccountSteam(token: token, vars: vars),
      create: create,
      username: username,
    );

    if (res.error != null) {
      throw FormatException('Authentication failed.', res.error);
    }

    final data = res.body!;

    return model.Session(
      created: data.created ?? false,
      token: data.token!,
      refreshToken: data.refreshToken,
    );
  }

  @override
  Future<model.Session> authenticateApple({
    required String token,
    bool create = true,
    String? username,
    Map<String, String>? vars,
  }) async {
    _session = null;
    final res = await _api.nakamaAuthenticateApple(
      body: ApiAccountApple(token: token, vars: vars),
      create: create,
      username: username,
    );

    if (res.error != null) {
      throw FormatException('Authentication failed.', res.error);
    }

    final data = res.body!;

    return model.Session(
      created: data.created ?? false,
      token: data.token!,
      refreshToken: data.refreshToken,
    );
  }

  @override
  Future<model.Session> authenticateCustom({
    required String id,
    bool create = true,
    String? username,
    Map<String, String>? vars,
  }) async {
    final res = await _api.nakamaAuthenticateCustom(
      body: ApiAccountCustom(id: id, vars: vars),
      create: create,
      username: username,
    );

    if (res.error != null) {
      throw FormatException('Authentication failed.', res.error);
    }

    final data = res.body!;

    return model.Session(
      created: data.created ?? false,
      token: data.token!,
      refreshToken: data.refreshToken,
    );
  }

  @override
  Future<Account> getAccount(model.Session session) async {
    _session = session;
    final res = await _api.nakamaGetAccount();

    final acc = Account();
    // Some workaround here while protobuf expects the vars map to not be null
    acc.mergeFromProto3Json((res.body!.copyWith(
      devices: res.body!.devices!
          .map((e) => e.copyWith(
                vars: e.vars ?? {},
              ))
          .toList(),
    )).toJson());

    return acc;
  }

  @override
  Future<Users> getUsers({
    required model.Session session,
    List<String>? facebookIds,
    List<String>? ids,
    List<String>? usernames,
  }) async {
    _session = session;
    final res = await _api.nakamaGetUsers(
      facebookIds: facebookIds,
      ids: ids,
      usernames: usernames,
    );

    return Users()..mergeFromProto3Json(res.body!.toJson());
  }

  @override
  Future<void> writeStorageObject({
    String? collection,
    String? key,
    String? value,
    String? version,
    StorageWritePermission? writePermission,
    StorageReadPermission? readPermission,
  }) {
    return _api.nakamaWriteStorageObjects(
      body: ApiWriteStorageObjectsRequest(
        objects: [
          ApiWriteStorageObject(
            collection: collection,
            key: key,
            value: value,
            version: version,
            permissionWrite: writePermission != null
                ? StorageWritePermission.values.indexOf(writePermission)
                : null,
            permissionRead: readPermission != null
                ? StorageReadPermission.values.indexOf(readPermission)
                : null,
          ),
        ],
      ),
    );
  }

  @override
  Future<ApiSession> sessionRefreshRequest(
      {required String token, Map<String, String>? vars}) async {
    _session = null;
    final res = await _api.nakamaSessionRefresh(
      body: ApiSessionRefreshRequest(
        token: token,
        vars: vars,
      ),
    );

    if (res.error != null) {
      throw FormatException('SessionRefreshRequest failed.', res.error);
    }

    final data = res.body!;

    return ApiSession(
        created: data.created,
        token: data.token,
        refreshToken: data.refreshToken);
  }

  @override
  Future<dynamic> linkDevice(
      {required String? id,
      required model.Session session,
      Map<String, String>? vars}) async {
    _session = session;
    final res = await _api.nakamaLinkDevice(
      body: ApiAccountDevice(
        id: id,
        vars: vars,
      ),
    );

    if (res.error != null) {
      throw FormatException('Link Device failed.', res.error);
    }

    final data = res.body!;

    return data;
  }

  @override
  Future<dynamic> linkApple(
      {required String? token,
      required model.Session session,
      Map<String, String>? vars}) async {
    _session = session;
    final res = await _api.nakamaLinkApple(
      body: ApiAccountApple(
        token: token,
        vars: vars,
      ),
    );

    if (res.error != null) {
      throw FormatException('Link Apple failed.', res.error);
    }

    final data = res.body!;

    return data;
  }

  @override
  Future<dynamic> linkGoogle(
      {required String? token,
      required model.Session session,
      Map<String, String>? vars}) async {
    _session = session;
    final res = await _api.nakamaLinkGoogle(
      body: ApiAccountGoogle(
        token: token,
        vars: vars,
      ),
    );

    if (res.error != null) {
      throw FormatException('Link Google failed.', res.error);
    }

    final data = res.body!;

    return data;
  }

  @override
  Future<dynamic> linkFacebook(
      {required String? token,
      required model.Session session,
      Map<String, String>? vars}) async {
    _session = session;
    final res = await _api.nakamaLinkFacebook(
      body: ApiAccountFacebook(
        token: token,
        vars: vars,
      ),
    );

    if (res.error != null) {
      throw FormatException('Link Facebook failed.', res.error);
    }

    final data = res.body!;

    return data;
  }

  @override
  Future<dynamic> linkGameCenter(
      {String? playerId,
      String? bundleId,
      String? timestampSeconds,
      String? salt,
      String? signature,
      String? publicKeyUrl,
      Map<String, String>? vars}) async {
    final res = await _api.nakamaLinkGameCenter(
      body: ApiAccountGameCenter(
        playerId: playerId,
        bundleId: bundleId,
        timestampSeconds: timestampSeconds,
        salt: salt,
        signature: signature,
        publicKeyUrl: publicKeyUrl,
        vars: vars,
      ),
    );

    if (res.error != null) {
      throw FormatException('Link Facebook failed.', res.error);
    }

    final data = res.body!;

    return data;
  }

  @override
  Future<dynamic> sessionLogout({required model.Session session}) async {
    _session = session;
    final res = await _api.nakamaSessionLogout(
      body: ApiSessionLogoutRequest(),
    );

    if (res.error != null) {
      throw FormatException('Session Logout failed.', res.error);
    }

    final data = res.body!;

    return data;
  }
}
*/
}

NakamaBaseClient getNakamaClient({
  String? host,
  String? serverKey,
  String key = _kDefaultAppKey,
  int httpPort = 7350,
  int grpcPort = 7349,
  bool ssl = false,
}) =>
    NakamaRestApiClient.init(
      host: host,
      key: key,
      port: httpPort,
      serverKey: serverKey,
      ssl: ssl,
    );
