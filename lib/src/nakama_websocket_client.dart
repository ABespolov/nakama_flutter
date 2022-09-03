import 'dart:async';
import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class NakamaWebsocketClient {
  static final Map<String, NakamaWebsocketClient> _clients = {};

  /// The host address of the server.
  final String host;

  /// The port number of the server. Defaults to 7349
  final int port;
  final bool ssl;

  /// The user's access token.
  final String roomId;
  final String processId;
  final String sessionId;

  final void Function()? onDone;
  final void Function(dynamic error)? onError;

  late final WebSocketChannel _channel;

  final _onMatchDataController = StreamController<List<int>>.broadcast();
  Stream<List<int>> get onMatchData => _onMatchDataController.stream;

  /// Returns the default instance.
  static NakamaWebsocketClient get instance {
    return NakamaWebsocketClient.instanceFor(key: 'default');
  }

  /// Returns the instance with given key.
  static NakamaWebsocketClient instanceFor({required String key}) {
    if (!_clients.containsKey(key)) {
      throw Exception('$key has not yet been initialized');
    }

    return _clients[key]!;
  }

  factory NakamaWebsocketClient.init({
    String key = 'default',
    required String host,
    int port = 3000,
    required bool ssl,
    required String roomId,
    required String processId,
    required String sessionId,
    Function()? onDone,
    Function(dynamic error)? onError,
  }) {
    // Has the client already been initialized? Then return it.
    if (_clients.containsKey(key)) {
      return instanceFor(key: key);
    }

    // Create new and return instance of this.
    return _clients[key] = NakamaWebsocketClient._(
      host: host,
      port: port,
      sessionId: sessionId,
      roomId: roomId,
      processId: processId,
      ssl: ssl,
      onDone: onDone,
      onError: onError,
    );
  }

  NakamaWebsocketClient._({
    required this.host,
    required this.sessionId,
    required this.roomId,
    required this.processId,
    this.port = 3000,
    required this.ssl,
    this.onDone,
    this.onError,
  }) {
    print('Connecting ${ssl ? 'WSS' : 'WS'} to $host:$port');
    print('Using token $sessionId');
    final uri = Uri(
      host: "demo.piesocket.com",
      // port: port,
      scheme: 'wss',
      path: '/v3/channel_1',
      queryParameters: {
        'api_key': 'VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV',
        "notify_self": "true",
      },
    );
    print(uri);
    _channel = IOWebSocketChannel.connect(uri,
        pingInterval: Duration(milliseconds: 500));

    _channel.stream.listen(
      _onData,
      onDone: () {
        print("on DONE");
        _clients.clear();

        if (onDone != null) {
          onDone!();
        }
      },
      onError: (err) {
        if (onError != null) {
          onError!(err);
        }
      },
      cancelOnError: false,
    );
  }

  Future<void> close() {
    return Future.wait([
      _onMatchDataController.close(),
    ]);
  }

  void _onData(msg) {
    print(msg);
  }

  Future<void> sendMatchData<S>(S data) async {
    _channel.sink.add(data);
  }
}

class NotificationController {
  static final NotificationController _singleton =
      NotificationController._internal();

  StreamController<String> streamController =
      StreamController.broadcast(sync: true);

  String wsUrl = 'ws://YOUR_WEBSERVICE_URL';

  late WebSocket channel;

  factory NotificationController() {
    return _singleton;
  }

  NotificationController._internal() {
    initWebSocketConnection();
  }

  initWebSocketConnection() async {
    print("conecting...");
    channel = await connectWs();
    print("socket connection initializied");
    await channel.done.then((dynamic _) => _onDisconnected());
    broadcastNotifications();
  }

  broadcastNotifications() {
    channel.listen((streamData) {
      streamController.add(streamData);
    }, onDone: () {
      print("conecting aborted");
      initWebSocketConnection();
    }, onError: (e) {
      print('Server error: $e');
      initWebSocketConnection();
    });
  }

  connectWs() async {
    try {
      return await WebSocket.connect(wsUrl);
    } catch (e) {
      print("Error! can not connect WS connectWs " + e.toString());
      await Future.delayed(Duration(milliseconds: 10000));
      return await connectWs();
    }
  }

  void _onDisconnected() {
    initWebSocketConnection();
  }
}
