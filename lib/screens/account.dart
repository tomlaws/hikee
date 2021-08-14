import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/change_password.dart';
import 'package:hikee/components/protected.dart';
import 'package:hikee/models/auth.dart';
import 'package:hikee/screens/account/bookmarks.dart';
import 'package:hikee/utils/dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ValueNotifier<List<Column>> _options = ValueNotifier([]);
  ValueNotifier<double> _page = ValueNotifier(0);
  PageController _pageController = PageController();
  File? _avatar;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      var page = _pageController.page;
      _page.value = page ?? 0;
      var roundedPage = _pageController.page!.round();
      if (page == roundedPage)
        _options.value = _options.value.take(roundedPage + 1).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _operations = {
      'Likes': null,
      'Bookmarks': (BuildContext ctx) {
        Navigator.of(ctx)
            .push(CupertinoPageRoute(builder: (_) => BookmarksPage()));
      },
      'Settings': {'Language': null},
      'Account': {
        'Change Password': _changePassword,
        'Delete Account': (ctx) {}
      },
      'Logout': (BuildContext ctx) {
        ctx.read<Auth>().logout();
      }
    };
    _options.value.clear();
    _addToOptions(_operations);
    _page.value = 0;
    return SafeArea(
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          Container(
            height: 16,
          ),
          Column(mainAxisSize: MainAxisSize.min, children: [
            GestureDetector(
              onTap: () async {
                final ImagePicker _picker = ImagePicker();
                final XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image == null) return;
                setState(() {
                  _avatar = File(image.path);
                });
              },
              child: Container(
                height: 128,
                width: 128,
                decoration: BoxDecoration(
                    image: _avatar == null
                        ? null
                        : DecorationImage(image: FileImage(_avatar!)),
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(64)),
              ),
            ),
          ]),
          _list(_operations)
        ],
      ),
    );
  }

  Widget _list(Map<String, dynamic> options) {
    return ValueListenableBuilder<double>(
      valueListenable: _page,
      builder: (BuildContext context, double value, Widget? child) {
        // calc height
        var left = value.floor();
        var right = value.ceil();
        var per = value - left;
        var leftHeight = _options.value[left].children.length * 56;
        var rightHeight = _options.value[right].children.length * 56;
        var height = leftHeight + (rightHeight - leftHeight) * per;
        return Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(16.0)),
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(16),
          height: height,
          //duration: const Duration(milliseconds: 250),
          child: ValueListenableBuilder<List<Column>>(
            valueListenable: _options,
            builder: (_, options, __) => PageView(
                children: options
                    .map((e) => SingleChildScrollView(
                          child: e,
                        ))
                    .toList(),
                controller: _pageController),
          ),
        );
      },
    );
  }

  void _addToOptions(Map<String, dynamic> options, {String? header}) {
    _options.value = [
      ..._options.value,
      Column(
          children: [
        if (header != null) ...[
          DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  bottom: Divider.createBorderSide(context),
                ),
              ),
              child: ListTile(
                horizontalTitleGap: 0,
                contentPadding: EdgeInsets.all(0),
                leading: Button(
                    icon: Icon(Icons.chevron_left),
                    backgroundColor: Colors.white,
                    onPressed: () {
                      _pageController.previousPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.linear);
                    }),
                title:
                    Text(header, style: TextStyle(fontWeight: FontWeight.bold)),
              ))
        ],
        ...ListTile.divideTiles(
            context: context,
            tiles: options.keys
                .map((key) => Material(
                      color: Colors.transparent,
                      child: ListTile(
                        title: Text(key),
                        trailing: options[key] is Map
                            ? Icon(Icons.chevron_right)
                            : null,
                        onTap: () {
                          if (options[key] == null) {
                            return;
                          }
                          if (options[key] is Function) {
                            options[key](context);
                          }
                          if (options[key] is Map) {
                            _addToOptions(options[key], header: key);
                            _pageController.nextPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.linear);
                          }
                        },
                      ),
                    ))
                .toList())
      ].toList())
    ];
  }

  Widget _likes() {
    return Container(
      child: Text('likes'),
    );
  }

  Widget _settings() {
    return Container(
      child: Text('settings'),
    );
  }

  void _changePassword(BuildContext context) {
    DialogUtils.show(context, ChangePassword(), title: 'Change Password',
        buttons: (_) {
      return [];
    });
  }
}
