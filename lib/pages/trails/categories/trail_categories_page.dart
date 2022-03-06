import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/models/trail_category.dart';
import 'package:hikee/pages/trails/categories/trail_categories_controller.dart';
import 'package:hikee/themes.dart';

class TrailCategoriesPage extends GetView<TrailCategoriesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: HikeeAppBar(title: Text("categories".tr)),
        body: controller.obx(
          (state) => GridView.count(
            padding: EdgeInsets.all(16),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: state!.map((e) => _categoryTile(e)).toList(),
          ),
          onLoading: GridView.count(
            padding: EdgeInsets.all(16),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: List.generate(8, (index) => _categoryTile(null)),
          ),
        ));
  }

  Widget _categoryTile(TrailCategory? category) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32), boxShadow: [Themes.shadow]),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            if (category != null)
              Get.toNamed('/trails/categories/${category.id}',
                  arguments: {'categoryName': category.name});
          },
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 2,
                  child: Container(
                    child: category == null
                        ? Shimmer()
                        : Icon(
                            _iconData(category.id),
                            size: 48,
                            color: _color(category.id),
                          ),
                  ),
                ),
                SizedBox(height: 16),
                category == null ? Shimmer() : Text(category.name)
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconData(int id) {
    switch (id) {
      case 1:
        return Icons.add_road_rounded;
      case 2:
        return Icons.hiking_rounded;
      case 3:
        return Icons.family_restroom_rounded;
      case 4:
        return Icons.park_rounded;
      case 5:
        return Icons.emoji_nature_rounded;
      case 6:
        return Icons.terrain_rounded;
      case 7:
        return Icons.grade_rounded;
      default:
        return Icons.hiking_rounded;
    }
  }

  Color _color(int id) {
    switch (id) {
      case 1:
        return Color(0xffFF5D73);
      case 2:
        return Color(0xff429EA6);
      case 3:
        return Color(0xffF4A261);
      case 4:
        return Color(0xff9BCE8D);
      case 5:
        return Color(0xff52796F);
      case 6:
        return Color(0xffCC998D);
      case 7:
        return Color(0xffAB81CD);
      default:
        return Color(0xffAB81CD);
    }
  }
}
