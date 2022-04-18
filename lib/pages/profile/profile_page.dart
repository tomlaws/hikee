import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/account/account_header.dart';
import 'package:hikees/components/account/record_tile.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/components/core/shimmer.dart';
import 'package:hikees/components/topics/topic_tile.dart';
import 'package:hikees/components/trails/trail_tile.dart';
import 'package:hikees/models/record.dart';
import 'package:hikees/models/topic.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/pages/profile/profile_controller.dart';
import 'package:hikees/pages/trail/trail_controller.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfilePage extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: Color(0xffffffff),
          appBar: HikeeAppBar(
            title: Obx(() => controller.user.value != null
                ? Text(controller.user.value!.nickname)
                : Shimmer(width: 48)),
          ),
          body: Column(
            children: [
              Expanded(
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        floating: true,
                        pinned: true,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.grey,
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        bottom: TabBar(
                            labelColor: Get.theme.primaryColor,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Get.theme.primaryColor,
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            tabs: [
                              Tab(
                                icon: Icon(LineAwesomeIcons.trophy),
                              ),
                              Tab(
                                icon: Icon(LineAwesomeIcons.route),
                              ),
                              Tab(
                                icon: Icon(LineAwesomeIcons.comment_dots),
                              )
                            ]),
                        expandedHeight: 416,
                        flexibleSpace: FlexibleSpaceBar(
                          collapseMode: CollapseMode.pin,
                          background: Column(children: [
                            Obx(
                              () => AccountHeader(user: controller.user.value),
                            ),
                          ]),
                        ),
                      )
                    ];
                  },
                  body: Builder(builder: (BuildContext context) {
                    final innerScrollController =
                        PrimaryScrollController.of(context);
                    return TabBarView(children: [
                      Obx(() => controller.user.value?.isPrivate != false
                          ? Center(child: Text('trailRecordsAreHidden'.tr))
                          : InfiniteScroller<Record>(
                              controller: controller,
                              scrollController: innerScrollController,
                              separator: SizedBox(
                                height: 16,
                              ),
                              pure: true,
                              empty: 'noRecords'.tr,
                              loadingItemCount: 5,
                              loadingBuilder: RecordTile(record: null),
                              builder: (record) {
                                return RecordTile(record: record);
                              })),
                      InfiniteScroller<Trail>(
                          controller: controller.trailsController,
                          scrollController: innerScrollController,
                          separator: SizedBox(
                            height: 16,
                          ),
                          pure: true,
                          empty: 'noData'.tr,
                          loadingItemCount: 5,
                          loadingBuilder: TrailTile(trail: null),
                          builder: (trail) {
                            return TrailTile(trail: trail);
                          }),
                      InfiniteScroller<Topic>(
                          controller: controller.topicsController,
                          scrollController: innerScrollController,
                          separator: SizedBox(
                            height: 16,
                          ),
                          pure: true,
                          empty: 'noData'.tr,
                          loadingItemCount: 5,
                          loadingBuilder: TopicTile(topic: null),
                          builder: (topic) {
                            return TopicTile(topic: topic);
                          }),
                    ]);
                  }),
                ),
              )
            ],
          )),
    );
  }
}
