import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/components/events/event_carousel.dart';
import 'package:hikee/controllers/event_categories.dart';
import 'package:hikee/controllers/events.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final _eventCategoriesController = Get.put(EventCategoriesController());
  final _eventsController = Get.put(EventsController());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _eventsController.next();
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
                    // Navigator.of(context).push(CupertinoPageRoute(
                    //     builder: (_) =>
                    //         SearchPage<EventsProvider, Event>(builder: (event) {
                    //           return EventTile(event: event);
                    //         })));
                  }),
            ),
          ],
        ),
      ),
      body: ListView(
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
              child: _eventCategoriesController.obx(
                (state) => ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: state!.length,
                  itemBuilder: (_, i) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 100,
                      width: 100,
                      alignment: Alignment.center,
                      child: Text(state[i].name_en,
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    );
                  },
                ),
                onLoading: Center(child: CircularProgressIndicator()),
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              'Featured',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          //EventCarousel(paginated.data),
          _eventsController.obx((state) => EventCarousel(state!.data),
              onLoading: Center(
                child: CircularProgressIndicator(),
              ))
        ],
      ),
    );
  }
}
