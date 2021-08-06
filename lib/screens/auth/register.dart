import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/mutation_builder.dart';
import 'package:hikee/components/text_input.dart';
import 'package:hikee/models/auth.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/screens/auth/login.dart';
import 'package:hikee/services/auth.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthService get authService => GetIt.I<AuthService>();
  TextInputController _emailController = TextInputController(text: '');
  TextInputController _passwordController = TextInputController(text: '');
  TextInputController _confirmPasswordController =
      TextInputController(text: '');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                  height: 16,
                ),
                TextInput(
                  hintText: 'Confirm password',
                  obscureText: true,
                  controller: _confirmPasswordController,
                ),
                Container(
                  height: 32,
                ),
                SizedBox(
                  width: 200,
                  child: MutationBuilder<Token?>(
                    mutation: () {
                      _emailController.clearError();
                      if (_emailController.text == '') {
                        throw _emailController.error = 'Please enter email';
                      }
                      if (_passwordController.text == '') {
                        throw _passwordController.error =
                            'Please enter password';
                      }

                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        throw _confirmPasswordController.error =
                            'Password does not match';
                      }
                      var email = _emailController.text;
                      var password = _passwordController.text;
                      return context.read<Auth>().register(email, password);
                    },
                    onDone: (token) {
                      if (token == null) {
                        //_emailController.error = '';
                      }
                    },
                    builder: (mutate, loading) {
                      return Button(
                          child: Text('REGISTER'),
                          loading: loading,
                          onPressed: mutate);
                    },
                  ),
                ),
                Container(
                  height: 16,
                ),
                GestureDetector(
                  child: Text('Or sign in now'),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        CupertinoPageRoute(builder: (_) => LoginScreen()));
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
