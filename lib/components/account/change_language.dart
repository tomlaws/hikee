import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/mutation_builder.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/old_providers/auth.dart';
import 'package:hikee/old_providers/locale.dart';
import 'package:hikee/services/user.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({Key? key}) : super(key: key);

  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: double.infinity,
            child: Button(
              secondary: true,
              onPressed: () {
                context.read<LocaleProvider>().locale = Locale('en');
                Navigator.of(context).pop();
              },
              child: Text('English'),
            )),
        SizedBox(
          height: 8,
        ),
        SizedBox(
            width: double.infinity,
            child: Button(
              secondary: true,
              onPressed: () {
                context.read<LocaleProvider>().locale = Locale('zh');
                Navigator.of(context).pop();
              },
              child: Text('繁體中文'),
            )),
        SizedBox(
          height: 8,
        ),
        SizedBox(
            width: double.infinity,
            child: Button(
              secondary: true,
              onPressed: () {
                context.read<LocaleProvider>().locale = Locale('zh', 'CN');
                Navigator.of(context).pop();
              },
              child: Text('簡體中文'),
            ))
      ],
    );
  }
}
