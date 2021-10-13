import 'package:flutter/material.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/mutation_builder.dart';
import 'package:hikee/components/core/text_input.dart';

class ChangeNickname extends StatefulWidget {
  const ChangeNickname({Key? key}) : super(key: key);

  @override
  _ChangeNicknameState createState() => _ChangeNicknameState();
}

class _ChangeNicknameState extends State<ChangeNickname> {
  TextInputController _nicknameController = TextInputController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextInput(
          hintText: 'Nickname',
          controller: _nicknameController,
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
              onDone: (_) {},
              onError: (err) {
                _nicknameController.error = err.getFieldError('nickname');
              },
              mutation: () async {
                _nicknameController.clearError();
                //await context
                //   .read<MeProvider>()
                //  .changeNickname(_nicknameController.text);
              },
            ),
            Button(
                child: Text('CANCEL'),
                backgroundColor: Colors.grey,
                onPressed: () {})
          ],
        ),
      ],
    );
  }
}
