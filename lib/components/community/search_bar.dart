import 'package:flutter/material.dart';
import 'package:hikee/components/text_input.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({ Key? key }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      child: TextInput(
        hintText: "search",
      ),
    );
  }
}