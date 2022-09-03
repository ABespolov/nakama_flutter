import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nakama/nakama.dart';
import 'package:simple_multiplayer_web/widgets/sign_in_box.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: _HomeScreen(),
  ));
}

class _HomeScreen extends StatefulWidget {
  _HomeScreen({Key? key}) : super(key: key);

  @override
  __HomeScreenState createState() => __HomeScreenState();
}

class __HomeScreenState extends State<_HomeScreen> {
  late final NakamaBaseClient _nakamaClient;
  late final NakamaWebsocketClient _websocketClient;

  Session? _session;
  late final MatchData _matchData;

  @override
  void initState() {
    super.initState();

    _nakamaClient = getNakamaClient(
      host: 'dev.fineadviser.com',
      httpPort: 3000,
      ssl: false,
      serverKey: 'defaultkey',
    );
  }

  _startListenWs() {
    _websocketClient = NakamaWebsocketClient.init(
        host: "dev.fineadviser.com",
        ssl: false,
        roomId: "_matchData.roomId",
        processId: "_matchData.processId",
        sessionId: " _matchData.sessionId");

/*    _websocketClient.onMatchData.listen((event) {}).onData((data) {
      print("data");
      print(data);
    });*/
  }

  @override
  void dispose() {
    _websocketClient.close();
    super.dispose();
  }

  void _signIn(String deviceId, String username) async {
    final session = await _nakamaClient.authenticateDevice(
      deviceId: deviceId,
      userName: username,
    );
    _session = session;
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Column(
              children: [
                Text('${_session?.token}'),
                Text('${_session?.expiresAt}'),
                Text('${_session?.refreshToken}'),
                Text('${_session?.refreshExpiresAt}'),
              ],
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          );
        });
  }

  void _refreshSession() async {
    final refreshToken = _session?.refreshToken;
    if (refreshToken != null) {
      final newSession =
          await _nakamaClient.refreshSession(token: refreshToken);
      _session = newSession;
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              content: Column(
                children: [
                  Text('${_session?.token}'),
                  Text('${_session?.expiresAt}'),
                  Text('${_session?.refreshToken}'),
                  Text('${_session?.refreshExpiresAt}'),
                ],
              ),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  void _joinOrCreateMatch() async {
    _matchData = await _nakamaClient.joinOrCreateMatch();
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Column(
              children: [
                Text('${_matchData.sessionId}'),
                Text('${_matchData.roomId}'),
                Text('${_matchData.processId}'),
              ],
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nakama Flutter Demo')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SignInBox(onSignIn: _signIn),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text('Refresh Token'),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () => _refreshSession(), child: Text('Refresh')),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text('GetMatchData'),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () => _joinOrCreateMatch(),
                    child: Text('GetMatchData')),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text('Start Ws'),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () => _startListenWs(), child: Text('Start Ws')),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text('Send to Ws'),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      var message = Uint8List(1);
                      var bytedata = ByteData.view(message.buffer);
                      bytedata.setUint8(0, 10);
                      print(message);
                      _websocketClient.sendMatchData(message);
                    },
                    child: Text('Send 10 to Ws')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
