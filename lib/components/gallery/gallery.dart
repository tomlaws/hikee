import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/gallery/gallery_controller.dart';
import 'package:hikees/utils/image.dart';
import 'package:photo_view/photo_view.dart';

class Gallery extends GetView<GalleryController> {
  const Gallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HikeeAppBar(title: Text("gallery".tr)),
      backgroundColor: Colors.black,
      body: (controller.images.length == 0)
          ? SizedBox()
          : Column(children: [
              Expanded(
                child: CarouselSlider(
                  options: CarouselOptions(
                      enableInfiniteScroll: false,
                      viewportFraction: 1,
                      initialPage: controller.images.indexOf(controller.image),
                      height: double.infinity),
                  items: controller.images
                      .map((e) => Container(
                            key: Key(e.hashCode.toString()),
                            child: PhotoView(
                              imageProvider: CachedNetworkImageProvider(
                                  ImageUtils.imageLink(e)),
                            ),
                          ))
                      .toList(),
                ),
              )
            ]),
    );
  }
}
