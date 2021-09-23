import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/hiking_route_tile.dart';
import 'package:hikee/components/core/infinite_scroll.dart';
import 'package:hikee/models/bookmark.dart';
import 'package:hikee/old_providers/bookmarks.dart';
import 'package:hikee/pages/route.dart';
import 'package:provider/provider.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            HikeeAppBar(
              title: Text('Bookmarks'),
            ),
            Expanded(
                child: InfiniteScroll<BookmarksProvider, Bookmark>(
              selector: (p) => p.items,
              builder: (bookmark) {
                return Container(
                    child: HikingRouteTile(
                  route: bookmark.route!,
                  onTap: () {
                    //Routemaster.of(context).push('/routes/${bookmark.routeId}');
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (_) => RouteScreen(
                              id: bookmark.route!.id,
                            )));
                  },
                ));
              },
              fetch: (next) => context.read<BookmarksProvider>().fetch(next),
            ))
          ],
        ));
  }
}
