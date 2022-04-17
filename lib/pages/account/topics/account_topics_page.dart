import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/components/topics/topic_tile.dart';
import 'package:hikees/components/trails/trail_tile.dart';
import 'package:hikees/models/topic.dart';
import 'package:hikees/pages/account/topics/account_topics_controller.dart';

class AccountTopicsPage extends GetView<AccountTopicsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HikeeAppBar(
        title: Text('topics'.tr),
      ),
      body: InfiniteScroller<Topic>(
        controller: controller,
        empty: Center(
          child: Text('noData'.tr),
        ),
        separator: SizedBox(
          height: 16,
        ),
        loadingItemCount: 10,
        loadingBuilder: TopicTile(topic: null),
        builder: (topic) {
          return TopicTile(
            topic: topic,
          );
        },
      ),
    );
  }
}
