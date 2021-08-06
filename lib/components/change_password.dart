import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/mutation_builder.dart';
import 'package:hikee/components/text_input.dart';
import 'package:hikee/models/auth.dart';
import 'package:hikee/services/user.dart';
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  UserService _userService = GetIt.I<UserService>();
  TextInputController _passwordController = TextInputController();
  TextInputController _confirmPasswordController = TextInputController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextInput(
          hintText: 'Password',
          obscureText: true,
          controller: _passwordController,
        ),
        Container(height: 16),
        TextInput(
          hintText: 'Confirm Password',
          obscureText: true,
          controller: _confirmPasswordController,
        ),
        Container(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            MutationBuilder<bool>(
              builder: (mutate, loading) => Button(
                  child: Text('CONFIRM'),
                  loading: loading,
                  onPressed: () {
                    mutate();
                  }),
              onDone: (_) {
                Navigator.of(context).pop();
              },
              mutation: () async {
                if (_passwordController.text.length < 6 ||
                    _passwordController.text.length > 20) {
                  throw _confirmPasswordController.error =
                      'Length should within 6 and 20';
                }
                if (_passwordController.text !=
                    _confirmPasswordController.text) {
                  throw _confirmPasswordController.error =
                      'Password does not match';
                }
                var token = await context.read<Auth>().getToken();
                await _userService.changePassword(token!,
                    password: _passwordController.text);
              },
            ),
            Button(
                child: Text('CANCEL'),
                backgroundColor: Colors.grey,
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ),
      ],
    );
  }
}
