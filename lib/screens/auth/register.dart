import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/text_input.dart';
import 'package:hikee/services/auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthService get authService => GetIt.I<AuthService>();
  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');
  TextEditingController _confirmPasswordController =
      TextEditingController(text: '');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  height: 16,
                ),
                TextInput(
                  hintText: 'Confirm password',
                  obscureText: true,
                  textEditingController: _confirmPasswordController,
                ),
                Container(
                  height: 32,
                ),
                SizedBox(
                  width: 200,
                  child: Button(
                      child: Text('REGISTER'),
                      onPressed: () {
                        var email = _emailController.text;
                        var password = _passwordController.text;
                        authService.register(email, password);
                      }),
                ),
                Container(
                  height: 16,
                ),
                GestureDetector(
                  child: Text('Or sign in now'),
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
