import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/mutation_builder.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/models/token.dart';
import 'package:hikee/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

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
                      _passwordController.clearError();
                      _confirmPasswordController.clearError();

                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        throw _confirmPasswordController.error =
                            'Password does not match';
                      }
                      var email = _emailController.text;
                      var password = _passwordController.text;
                      return context.read<AuthProvider>().register(email, password);
                    },
                    onError: (error) {
                      _emailController.error = error.getFieldError('email');
                      _passwordController.error = error.getFieldError('password');
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
                    Routemaster.of(context).replace('/login');
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
