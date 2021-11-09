import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/pages/topics/topic_categories_controller.dart';

class TopicCategories extends GetView<TopicCategoriesController> {
  final controller = Get.find<TopicCategoriesController>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.defaultDialog(
          titlePadding: EdgeInsets.symmetric(vertical: 16),
          title: 'Categories',
          titleStyle: TextStyle(fontWeight: FontWeight.bold),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: controller.obx(
                (state) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: state!.length,
                    itemBuilder: (_, i) => GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            controller.setCategory(state[i].id);
                            Get.back();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(state[i].name_en,
                                    style: TextStyle(
                                        fontWeight:
                                            controller.currentCategory.value ==
                                                    state[i].id
                                                ? FontWeight.bold
                                                : FontWeight.normal)),
                                Icon(Icons.chevron_right, color: Colors.black26)
                              ],
                            ),
                          ),
                        )),
                onLoading: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 4,
                    itemBuilder: (_, i) => GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Shimmer(
                                  width: 88,
                                ),
                                Icon(Icons.chevron_right, color: Colors.black26)
                              ],
                            ),
                          ),
                        ))),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            controller.obx(
                (state) => Obx(
                      () => Text(
                          controller.currentCategory.value == null
                              ? state![0].name_en
                              : state!
                                  .firstWhere((element) =>
                                      element.id ==
                                      controller.currentCategory.value)
                                  .name_en,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                onLoading: Shimmer(
                  fontSize: 18,
                  width: 88,
                )),
            SizedBox(width: 8),
            Icon(Icons.keyboard_arrow_down, color: Get.theme.iconTheme.color)
          ],
        ),
      ),
    );
  }
}
