import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakama/nakama.dart';
import 'package:nakama/api.dart' as api;
import 'package:nakama/rtapi.dart' as rt;
import 'package:simple_multiplayer_web/widgets/match_area.dart';
import 'package:simple_multiplayer_web/widgets/matchmaker.dart';
import 'package:simple_multiplayer_web/widgets/sign_in_box.dart';
import 'package:simple_multiplayer_web/widgets/welcome.dart';

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

  Session? _session;
  rt.Match? _match;

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

  @override
  void dispose() {
    NakamaWebsocketClient.instance.close();
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
    MatchData matchData = await _nakamaClient.joinOrCreateMatch();
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            content: Column(
              children: [
                Text('${matchData.sessionId}'),
                Text('${matchData.roomId}'),
                Text('${matchData.processId}'),
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
            )
          ],
        ),
      ),
    );
  }
}
