import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/avatar.dart';
import 'package:hikees/components/core/bottom_bar.dart';
import 'package:hikees/components/core/button.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/components/core/shimmer.dart';
import 'package:hikees/components/core/text_may_overflow.dart';
import 'package:hikees/components/core/mutation_builder.dart';
import 'package:hikees/components/gallery/gallery.dart';
import 'package:hikees/models/topic_base.dart';
import 'package:hikees/models/topic_reply.dart';
import 'package:hikees/pages/topic/topic_controller.dart';
import 'package:hikees/themes.dart';
import 'package:hikees/utils/image.dart';
import 'package:hikees/utils/time.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:photo_view/photo_view.dart';

class TopicPage extends GetView<TopicController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HikeeAppBar(
          title: controller.obx((state) => TextMayOverflow(state!.title),
              onLoading: Shimmer()),
          actions: [
            controller.obx(
                (state) => MutationBuilder(
                    userOnly: true,
                    mutation: () {
                      return controller.toggleLike();
                    },
                    builder: (mutate, loading) {
                      return Container(
                        child: Button(
                            child: Row(children: [
                              Icon(
                                LineAwesomeIcons.thumbs_up,
                                color: state?.liked == true
                                    ? Colors.green
                                    : Colors.black54,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                state?.likeCount.toString() ?? '0',
                                style: TextStyle(
                                    color: state?.liked == true
                                        ? Colors.green
                                        : Colors.black54),
                              )
                            ]),
                            invert: true,
                            loading: loading,
                            onPressed: () {
                              mutate();
                            }),
                      );
                    }),
                onLoading: Shimmer(
                  width: 80,
                ))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: InfiniteScroller<TopicReply>(
                  refreshable: true,
                  controller: controller.topicReplyController,
                  scrollController: controller.scrollController,
                  empty: 'noReplies'.tr,
                  separator: SizedBox(height: 16),
                  headers: [
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 16.0, right: 16.0),
                        child: controller.obx((state) => _topic(state),
                            onLoading: _topic(null)))
                  ],
                  loadingItemCount: 10,
                  loadingBuilder: _topic(null),
                  builder: (reply) {
                    return Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: _topic(reply));
                  },
                ),
              ),
            ),
            BottomBar(
                child: Row(
              children: [
                Expanded(
                  child: Button(
                      onPressed: () {
                        if (controller.state != null)
                          Get.toNamed('/topics/${controller.state!.id}/reply');
                      },
                      child: Text('reply'.tr)),
                )
              ],
            ))
          ],
        ));
  }

  Widget _topic(TopicBase? topic) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [Themes.lightShadow],
          color: Colors.white,
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              children: [
                topic != null
                    ? Avatar(user: topic.user, height: 48)
                    : Avatar(user: null, height: 48),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    topic != null
                        ? Text(topic.user.nickname)
                        : Shimmer(
                            width: 88,
                          ),
                    SizedBox(
                      height: 4,
                    ),
                    topic != null
                        ? Text(TimeUtils.timeAgoSinceDate(topic.createdAt),
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54))
                        : Shimmer(
                            width: 88,
                            fontSize: 12,
                          )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8.0),
            child: topic == null ? Shimmer() : Text(topic.content),
          ),
          topic != null
              ? (topic.images == null || topic.images?.length == 0)
                  ? SizedBox()
                  : Container(
                      height: 240,
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      width: double.infinity,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          enableInfiniteScroll: false,
                          aspectRatio: 1,
                          viewportFraction: 0.8,
                        ),
                        items: topic.images!
                            .map((e) => InkWell(
                                  onTap: () => _fullscreen(topic.images!, e),
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    margin: const EdgeInsets.all(8.0),
                                    child: CachedNetworkImage(
                                        imageUrl: ImageUtils.imageLink(e),
                                        fit: BoxFit.cover),
                                  ),
                                ))
                            .toList(),
                      ),
                    )
              : SizedBox(),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  _fullscreen(List<String> images, String image) {
    Get.toNamed('/gallery', arguments: {'images': images, 'image': image});
  }
}
