import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/section_button.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/components/events/event_carousel.dart';
import 'package:hikee/controllers/event_categories.dart';
import 'package:hikee/pages/events/events_controller.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class EventsPage extends StatelessWidget {
  final controller = Get.find<EventsController>();
  final _eventCategoriesController = Get.find<EventCategoriesController>();
  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: SizedBox(
          //     height: 40,
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: SectionButton(
          //             text: 'My Events',
          //             iconData: LineAwesomeIcons.calendar,
          //             color: Colors.green[400],
          //             textColor: Colors.white,
          //           ),
          //         ),
          //         SizedBox(width: 8),
          //         Expanded(
          //           child: SectionButton(
          //             text: 'New Event',
          //             iconData: LineAwesomeIcons.calendar_plus,
          //             color: Colors.orange[400],
          //             textColor: Colors.white,
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextInput(
                hintText: 'Search...',
                textInputAction: TextInputAction.search,
                icon: Icon(Icons.search),
                onTap: () {
                  Get.toNamed('/search', id: 2);
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
            child: SizedBox(
              height: 112,
              child: Row(
                children: [
                  Expanded(
                    child: SectionButton(
                      text: 'STARGAZING',
                      textAlignment: Alignment.center,
                      textColor: Colors.white,
                      background: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0)),
                        clipBehavior: Clip.antiAlias,
                        child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: 'https://i.imgur.com/Vr6Qzw3.png'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SectionButton(
                            text: 'WOOD',
                            textColor: Colors.white,
                            background: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0)),
                              clipBehavior: Clip.antiAlias,
                              child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: 'https://i.imgur.com/pBwT5Jd.png'),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Expanded(
                          child: SectionButton(
                            text: 'SEA',
                            textColor: Colors.white,
                            background: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0)),
                              clipBehavior: Clip.antiAlias,
                              child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: 'https://i.imgur.com/gkAnOCi.png'),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          // Container(
          //     height: 98,
          //     child: _eventCategoriesController.obx(
          //       (state) => ListView.builder(
          //         padding: EdgeInsets.symmetric(horizontal: 18),
          //         physics: AlwaysScrollableScrollPhysics(),
          //         scrollDirection: Axis.horizontal,
          //         itemCount: state!.length,
          //         itemBuilder: (_, i) {
          //           return Container(
          //             decoration: BoxDecoration(
          //               color: Colors.green,
          //               borderRadius: BorderRadius.circular(20),
          //             ),
          //             height: 100,
          //             width: 100,
          //             alignment: Alignment.center,
          //             child: Text(state[i].name_en,
          //                 style: TextStyle(color: Colors.white, fontSize: 16)),
          //           );
          //         },
          //       ),
          //       onLoading: Center(child: CircularProgressIndicator()),
          //     )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Latest events',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          SizedBox(
            height: 16,
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
