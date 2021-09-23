import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/components/events/event_carousel.dart';
import 'package:hikee/components/hiking_route_tile.dart';
import 'package:hikee/controllers/event_categories.dart';
import 'package:hikee/pages/events/events_controller.dart';
import 'package:hikee/pages/search.dart';

class EventsPage extends StatelessWidget {
  final controller = Get.find<EventsController>();
  final _eventCategoriesController = Get.find<EventCategoriesController>();
  @override
  Widget build(BuildContext context) {
    //super.build(context);
    controller.next();
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: TextInput(
                hintText: 'Search...',
                textInputAction: TextInputAction.search,
                icon: Icon(Icons.search),
                onTap: () {
                  Get.toNamed('/search', id: 2);
                }),
          ),
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
              'Latest',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          controller.obx((state) => EventCarousel(state!.data),
              onLoading: Center(
                child: CircularProgressIndicator(),
              ))
        ],
      ),
    );
  }
}
