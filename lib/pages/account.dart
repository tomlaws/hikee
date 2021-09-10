import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/account/change_language.dart';
import 'package:hikee/components/account/change_nickname.dart';
import 'package:hikee/components/avatar.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/account/change_password.dart';
import 'package:hikee/models/user.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/providers/me.dart';
import 'package:hikee/pages/account/bookmarks.dart';
import 'package:hikee/utils/dialog.dart';
import 'package:hikee/utils/http.dart';
import 'package:hikee/utils/localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

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
    var loggedIn = context.select<AuthProvider, bool>((p) => p.loggedIn);
    Map<String, dynamic> _operations = {
      if (loggedIn)
        Localization.translate(context, (l) => l.bookmarks):
            (BuildContext ctx) {
          Navigator.of(ctx)
              .push(CupertinoPageRoute(builder: (_) => BookmarksPage()));
        }
      else
        Localization.translate(context, (l) => l.login): (BuildContext ctx) {
          Routemaster.of(context).push('/login');
        },
      if (loggedIn)
        Localization.translate(context, (l) => l.account): {
          'Change Nickname': _changeNickname,
          'Change Password': _changePassword,
          'Delete Account': (ctx) {}
        },
      Localization.translate(context, (l) => l.settings): {
        Localization.translate(context, (l) => l.language): _changeLanguage
      },
      if (loggedIn)
        Localization.translate(context, (l) => l.logout): (BuildContext ctx) {
          ctx.read<AuthProvider>().logout();
        }
    };
    _options.value.clear();
    _addToOptions(_operations);
    _page.value = 0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            if (loggedIn) ...[
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
                    _uploadIcon(File(image.path));
                  },
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Selector<MeProvider, User?>(
                        selector: (_, mp) => mp.user,
                        builder: (_, me, __) => Avatar(
                              user: me!,
                              height: 128,
                            ))
                  ]),
                ),
              ]),
              Container(
                height: 16,
              ),
              Selector<MeProvider, User?>(
                selector: (_, mp) => mp.user,
                builder: (_, me, __) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 48,
                        child: Center(
                          child: Text(me?.nickname ?? 'Unnamed',
                              style: TextStyle(fontSize: 24)),
                        ),
                      )
                    ]),
              ),
            ],
            _list(_operations)
          ],
        ),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 3)
              ]),
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(16),
          height: height,
          //duration: const Duration(milliseconds: 250),
          child: ValueListenableBuilder<List<Column>>(
            valueListenable: _options,
            builder: (_, options, __) => PageView(
                children: options
                    .asMap()
                    .map((i, e) => MapEntry(
                        i,
                        Opacity(
                          opacity: (1 - (value - i).abs()).clamp(0, 1),
                          child: SingleChildScrollView(
                            child: e,
                          ),
                        )))
                    .values
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
                minVerticalPadding: 0,
                leading: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Button(
                      icon: Icon(Icons.chevron_left),
                      backgroundColor: Colors.white,
                      onPressed: () {
                        _pageController.previousPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.linear);
                      }),
                ),
                title: Text(header, style: TextStyle()),
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

  void _changeNickname(BuildContext context) {
    DialogUtils.show(context, ChangeNickname(), title: 'Change Nickname',
        buttons: (_) {
      return [];
    });
  }

  void _changePassword(BuildContext context) {
    DialogUtils.show(context, ChangePassword(), title: 'Change Password',
        buttons: (_) {
      return [];
    });
  }

  void _uploadIcon(File file) {
    context.read<MeProvider>().changeIcon(file);
  }

  void _changeLanguage(BuildContext context) {
    DialogUtils.show(context, ChangeLanguage(),
        title: Localization.translate(context, (l) => l.language),
        buttons: (_) {
      return [];
    });
  }
}
