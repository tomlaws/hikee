import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/mutation_builder.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/models/token.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextInputController _emailController = TextInputController();
  TextInputController _passwordController = TextInputController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var auth = context.watch<AuthProvider>();
    if (auth.loggedIn) {
      Future.microtask(() => Routemaster.of(context).pop());
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
                  controller: _emailController,
                ),
                Container(
                  height: 16,
                ),
                TextInput(
                  hintText: 'Password',
                  obscureText: true,
                  controller: _passwordController,
                ),
                Container(
                  height: 32,
                ),
                SizedBox(
                  width: 200,
                  child: MutationBuilder<Token?>(
                    mutation: () {
                      _emailController.clearError();
                      _passwordController.clearError();
                      var email = _emailController.text;
                      var password = _passwordController.text;
                      return context.read<AuthProvider>().signIn(email, password);
                    },
                    onDone: (token) {},
                    onError: (error) {
                      _emailController.error = error.getFieldError('email');
                      _passwordController.error =
                          error.getFieldError('password');
                      if (error.statusCode == 401)
                        _passwordController.error = 'Incorrect password';
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
                    Routemaster.of(context).replace('/register');
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
