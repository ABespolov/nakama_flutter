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
  api.Account? _account;
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
    print(session.token);
    print(session.expiresAt);
    print(session.refreshToken);
    print(session.refreshExpiresAt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nakama Flutter Demo')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _session != null && _account != null
            ? Column(
                children: [
                  Welcome(_account!),
                  if (_match == null)
                    Matchmaker(
                      onMatch: (m) => setState(() => _match = m),
                    ),
                  if (_match != null) MatchArea(_match!),
                ],
              )
            : SignInBox(onSignIn: _signIn),
      ),
    );
  }
}
