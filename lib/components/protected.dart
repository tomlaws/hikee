import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/pages/auth/login.dart';
import 'package:provider/provider.dart';

class Protected extends StatefulWidget {
  const Protected({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _ProtectedState createState() => _ProtectedState();
}

class _ProtectedState extends State<Protected> {
  @override
  void initState() {
    super.initState();
    // var auth = context.read<Auth>();
    // if (!auth.loggedIn) {
    //   Future(() {
    //     Navigator.of(context)
    //         .push(CupertinoPageRoute(builder: (_) => LoginScreen()));
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    var auth = context.watch<AuthProvider>();
    if (auth.loggedIn) {
      return widget.child;
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Login to enjoy hiking',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          Container(height: 32),
          SizedBox(
            width: 200,
            child: Button(
                child: Text('LOGIN'),
                onPressed: () {
                  Navigator.of(context)
                      .push(CupertinoPageRoute(builder: (_) => LoginScreen()));
                }),
          )
        ],
      );
    }
  }
}
