import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/avatar.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/models/topic.dart';
import 'package:hikee/pages/topic/topic_controller.dart';
import 'package:hikee/themes.dart';
import 'package:hikee/utils/time.dart';
import 'package:photo_view/photo_view.dart';

class TopicPage extends GetView<TopicController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HikeeAppBar(
            title: controller.obx((state) => Text(state!.title),
                onLoading: Shimmer())),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _topic(),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([]),
            )
          ],
        ));
  }

  Widget _topic() {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [Themes.shadow],
          color: Colors.white,
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                controller.obx((state) => Avatar(user: state?.user, height: 48),
                    onLoading: Avatar(user: null, height: 48)),
                SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.obx((state) => Text(state!.user.nickname),
                        onLoading: Shimmer(
                          width: 88,
                        )),
                    SizedBox(
                      height: 4,
                    ),
                    controller.obx(
                        (state) => Text(
                            TimeUtils.timeAgoSinceDate(state!.createdAt),
                            style:
                                TextStyle(fontSize: 12, color: Colors.black54)),
                        onLoading: Shimmer(
                          width: 88,
                          fontSize: 12,
                        ))
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: controller.obx((state) => Text(state!.content),
                onLoading: Shimmer()),
          ),
          controller.obx(
              (state) => (state?.images == null || state?.images?.length == 0)
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
                        items: state!.images!
                            .map((e) => InkWell(
                                  onTap: () => _fullscreen(e),
                                  child: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16)),
                                    margin: const EdgeInsets.all(8.0),
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            'https://hikee.s3.ap-southeast-1.amazonaws.com/$e',
                                        fit: BoxFit.cover),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
              onLoading: SizedBox()),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  _fullscreen(String image) {
    var widget = Scaffold(
      appBar: HikeeAppBar(title: Text("Gallery")),
      backgroundColor: Colors.black,
      body: controller.obx(
          (state) => (state?.images == null || state?.images?.length == 0)
              ? SizedBox()
              : Column(children: [
                  Expanded(
                    child: CarouselSlider(
                      options: CarouselOptions(
                          enableInfiniteScroll: false,
                          viewportFraction: 1,
                          initialPage: state!.images!.indexOf(image),
                          height: double.infinity),
                      items: state.images!
                          .map((e) => Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(),
                                child: PhotoView(
                                  imageProvider: CachedNetworkImageProvider(
                                      'https://hikee.s3.ap-southeast-1.amazonaws.com/$e'),
                                ),
                              ))
                          .toList(),
                    ),
                  )
                ]),
          onLoading: SizedBox()),
    );
    Get.to(widget, transition: Transition.zoom, fullscreenDialog: true);
  }
}
