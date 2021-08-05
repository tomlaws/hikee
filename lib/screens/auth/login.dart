import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/mutation_builder.dart';
import 'package:hikee/components/text_input.dart';
import 'package:hikee/models/auth.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/screens/auth/register.dart';
import 'package:hikee/services/auth.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var auth = context.watch<Auth>();
    if (auth.loggedIn) {
      Future.microtask(() => Navigator.of(context).pop());
      return Container();
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 100,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextInput(
                  hintText: 'Email',
                  textEditingController: _emailController,
                ),
                Container(
                  height: 16,
                ),
                TextInput(
                  hintText: 'Password',
                  obscureText: true,
                  textEditingController: _passwordController,
                ),
                Container(
                  height: 32,
                ),
                SizedBox(
                  width: 200,
                  child: MutationBuilder<Token>(
                    mutation: () {
                      var email = _emailController.text;
                      var password = _passwordController.text;
                      return context.read<Auth>().signIn(email, password);
                    },
                    builder: (mutate, loading) {
                      return Button(
                          child: Text('LOGIN'),
                          loading: loading,
                          onPressed: mutate);
                    },
                  ),
                ),
                Container(
                  height: 16,
                ),
                GestureDetector(
                  child: Text('Or sign up now'),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(builder: (_) => RegisterScreen()));
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
