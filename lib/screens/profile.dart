import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/protected.dart';
import 'package:hikee/models/auth.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Protected(
      child: Scaffold(
        body: SafeArea(
          child: Container(
              child: Button(
            onPressed: () {
              context.read<Auth>().logout();
            },
            child: Text('Logout'),
          )),
        ),
      ),
    );
  }
}
