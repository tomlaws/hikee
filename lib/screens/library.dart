import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/library/card.dart';
import 'package:hikee/components/text_input.dart';
import 'package:hikee/data/routes.dart';
import 'package:hikee/screens/route.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
          child: Column(children: [
            TextInput(
              hintText: "Search...",
            ),
            Expanded(
                child: ListView(
              children: [
                GestureDetector(
                  child: LibraryCard(),
                  onTapDown: (_) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => RouteScreen(id: 1)));
                  },
                ),
                LibraryCard(),
                LibraryCard(),
                LibraryCard(),
              ],
            ))
          ]),
        ),
      ),
    );
  }
}
