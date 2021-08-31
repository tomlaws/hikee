import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/mutation_builder.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/services/user.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

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
                Routemaster.of(context).pop();
              },
              onError: (err) {
                _passwordController.error = err.getFieldError('password');
              },
              mutation: () async {
                _passwordController.clearError();
                _confirmPasswordController.clearError();
                if (_passwordController.text !=
                    _confirmPasswordController.text) {
                  throw _confirmPasswordController.error =
                      'Password does not match';
                }
                var token = await context.read<AuthProvider>().getToken();
                await _userService.changePassword(token!,
                    password: _passwordController.text);
              },
            ),
            Button(
                child: Text('CANCEL'),
                backgroundColor: Colors.grey,
                onPressed: () {
                  Routemaster.of(context).pop();
                })
          ],
        ),
      ],
    );
  }
}
