import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/shimmer.dart';
import 'package:hikees/models/trail_category.dart';
import 'package:hikees/themes.dart';

class TrailCategoryTile extends StatelessWidget {
  const TrailCategoryTile({Key? key, this.category}) : super(key: key);

  final TrailCategory? category;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [Themes.boxShadow]),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              if (category != null)
                Get.toNamed('/trails/categories/${category!.id}',
                    arguments: {'categoryName': category!.name});
            },
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AspectRatio(
                    aspectRatio: 2,
                    child: Container(
                      child: category == null
                          ? Shimmer()
                          : Icon(
                              _iconData(category!.id),
                              size: 36,
                              color: _color(category!.id),
                            ),
                    ),
                  ),
                  SizedBox(height: 8),
                  category == null
                      ? Shimmer()
                      : SizedBox(
                          height: 32,
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                category!.name,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        )
                ],
              ),
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
