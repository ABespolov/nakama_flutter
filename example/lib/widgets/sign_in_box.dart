import 'package:flutter/material.dart';

class SignInBox extends StatelessWidget {
  final _email = TextEditingController(text: 'someId');
  final _password = TextEditingController(text: 'newUser');

  final Function(String, String) onSignIn;

  SignInBox({
    Key? key,
    required this.onSignIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Device Id'),
                controller: _email,
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'user name'),
                controller: _password,
              ),
            ),
            ElevatedButton(
              onPressed: () => onSignIn.call(
                  "A4A39CF-1A53-4D87-9C9E-8D3D75F24442",
                  "A4A39CF-1A53-4D87-9C9E-8D3D75F24442"),
              child: Text('SigUp'),
            ),
          ],
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Please sign in.'),
            ),
          ),
        ),
      ],
    );
  }
}
