import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikee/components/button.dart';
import 'package:routemaster/routemaster.dart';

class LoginPrompt extends StatefulWidget {
  const LoginPrompt({Key? key}) : super(key: key);

  @override
  _LoginPromptState createState() => _LoginPromptState();
}

class _LoginPromptState extends State<LoginPrompt> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Join Hikee now',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Container(height: 32),
        SizedBox(
          width: 200,
          child: Button(
              child: Text('LOGIN'),
              onPressed: () {
                Routemaster.of(context).push('/login');
              }),
        ),
        
        Container(height: 16),
        SizedBox(
          width: 200,
          child: Button(
              child: Text('SIGN UP'),
              onPressed: () {
                Routemaster.of(context).push('/register');
              }),
        )
      ],
    );
  }
}
