import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/future_selector.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/components/event_tile.dart';
import 'package:hikee/components/events/event_carousel.dart';
import 'package:hikee/models/event.dart';
import 'package:hikee/models/event_category.dart';
import 'package:hikee/models/paginated.dart';
import 'package:hikee/providers/event.dart';
import 'package:hikee/providers/events.dart';
import 'package:hikee/pages/search.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HikeeAppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextInput(
                  hintText: 'Search...',
                  textInputAction: TextInputAction.search,
                  icon: Icon(Icons.search),
                  onTap: () {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (_) =>
                            SearchPage<EventsProvider, Event>(builder: (event) {
                              return EventTile(event: event);
                            })));
                  }),
            ),
          ],
        ),
      ),
      body: FutureSelector<EventsProvider, Paginated<Event>>(
        init: (p) => p.get(),
        builder: (_, paginated, __) => ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'Category',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            Container(
              height: 98,
              child: FutureSelector<EventsProvider, List<EventCategory>>(
                init: (p) => p.getCategories(),
                builder: (_, categories, __) => ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (_, i) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 100,
                      width: 100,
                      alignment: Alignment.center,
                      child: Text(categories[i].name_en,
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'Latest',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            EventCarousel(paginated.data),
          ],
        ),
      ),
    );
  }
}
