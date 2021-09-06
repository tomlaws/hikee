import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikee/screens/faq/faq.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class DropdownMenu extends StatefulWidget {
  DropdownMenu({Key? key}) : super(key: key);

  @override
  _DropdownMenuState createState() => _DropdownMenuState();
}

class _DropdownMenuState extends State<DropdownMenu> {
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) => {
        if (value == 'FAQ')
          Navigator.of(context)
              .push(CupertinoPageRoute(builder: (_) => FAQScreen()))
      },
      icon: Icon(
        LineAwesomeIcons.bars,
        size: 32,
        color: Colors.white,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        const PopupMenuItem(
          value: 'Map',
          child: ListTile(
            leading: Icon(LineAwesomeIcons.map),
            title: Text('Map'),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'FAQ',
          child: ListTile(
            leading: Icon(Icons.article),
            title: Text('FAQ'),
          ),
        ),
      ],
    );
  }
}
