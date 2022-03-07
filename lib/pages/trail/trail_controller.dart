import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hikees/components/core/app_bar.dart';
import 'package:hikees/components/core/infinite_scroller.dart';
import 'package:hikees/components/core/rating_input.dart';
import 'package:hikees/components/core/text_input.dart';
import 'package:hikees/components/trails/trail_review_tile.dart';
import 'package:hikees/controllers/shared/pagination.dart';
import 'package:hikees/models/trail_review.dart';
import 'package:hikees/pages/account/bookmarks/account_bookmarks_controller.dart';
import 'package:hikees/providers/bookmark.dart';
import 'package:hikees/utils/dialog.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikees/models/trail.dart';
import 'package:hikees/providers/trail.dart';
import 'package:hikees/utils/geo.dart';

class TrailController extends GetxController with StateMixin<Trail> {
  final _trailProvider = Get.put(TrailProvider());
  final _bookmarkProvider = Get.put(BookmarkProvider());
  late GetPaginationController<TrailReview> trailReviewsController;
  late ScrollController scrollController;

  late int id;
  MapController? mapController;
  PageController carouselController = PageController();
  final carouselPage = 0.0.obs;
  final bookmarked = false.obs;
  final points = Rxn<List<LatLng>>();

  final int takeReviews = 5;

  @override
  void onInit() {
    super.onInit();
    id = int.parse(Get.parameters['trailId'] ?? Get.parameters['id'] ?? '');
    append(() => _loadTrail);
    scrollController = ScrollController();
    trailReviewsController = Get.put(GetPaginationController((queries) {
      return _trailProvider.getTrailReviews(id, queries);
    }));
    carouselController.addListener(() {
      double page = carouselController.page ?? 0;
      carouselPage.value = page;
    });
  }

  void refreshTrail() {
    change(null, status: RxStatus.loading());
    append(() => _loadTrail);
  }

  Future<Trail> _loadTrail() async {
    var trail = await _trailProvider.getTrail(id);
    bookmarked.value = trail.bookmark != null;
    points.value = GeoUtils.decodePath(trail.path);
    return trail;
  }

  void viewMoreReviews() {
    var _trailReviewsController = Get.put(GetPaginationController((queries) {
      return _trailProvider.getTrailReviews(id, queries);
    }), tag: 'trails-$id-reviews');
    Get.to(Scaffold(
      appBar: HikeeAppBar(title: Text('reviews'.tr)),
      body: InfiniteScroller(
        controller: _trailReviewsController,
        separator: SizedBox(height: 16),
        builder: (TrailReview trailReview) {
          return TrailReviewTile(trailReview: trailReview);
        },
      ),
    ));
  }

  Future<void> toggleBookmark() async {
    if (state == null) return;
    if (state!.bookmark == null) {
      var bm = await _bookmarkProvider.createBookmark(id);
      state!.bookmark = bm;
      change(state, status: RxStatus.success());
    } else {
      _bookmarkProvider.removeBookmark(id);
      state!.bookmark = null;
      change(state, status: RxStatus.success());

      var abc = Get.find<AccountBookmarksController>();
      abc.remove(state!.id);
    }
  }

  Future<dynamic> addReview() async {
    final formkey = GlobalKey<FormState>();
    int _rating = 0;
    String _content = '';
    final result = await DialogUtils.showActionDialog(
        'review'.tr,
        Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingInput(
                label: 'rating'.tr,
                invalidRatingMessage: 'pleaseRateTheTrail'.tr,
                onSaved: (rating) => _rating = rating ?? 0,
              ),
              SizedBox(
                height: 16,
              ),
              TextInput(
                maxLines: 5,
                label: 'review'.tr,
                initialValue: _content,
                onSaved: (v) {
                  _content = v ?? '';
                },
                validator: (v) {
                  if (v == null || v.length == 0) {
                    return "fieldCannotBeEmpty"
                        .trParams({'field': 'review'.tr});
                  }
                  return null;
                },
              )
            ],
          ),
        ), onOk: () async {
      if (formkey.currentState?.validate() == true) {
        formkey.currentState?.save();
        await _submitReview(rating: _rating, content: _content);
        return true;
      } else {
        throw new Error();
      }
    });
    return result;
  }

  Future<void> _submitReview(
      {required int rating, required String content}) async {
    final newReview = await _trailProvider.createTrailReview(
        id: id, rating: rating, content: content);
    var reviewsState = trailReviewsController.state;
    reviewsState!..data.insert(0, newReview);
    // check if exceeds
    if (reviewsState.data.length > takeReviews) {
      reviewsState.hasMore = true;
    }
    trailReviewsController.forceUpdate(reviewsState);
  }

  @override
  void onClose() {
    carouselController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
