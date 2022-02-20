import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/infinite_scroller.dart';
import 'package:hikee/components/core/rating_input.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/components/trails/trail_review_tile.dart';
import 'package:hikee/controllers/shared/pagination.dart';
import 'package:hikee/models/trail_review.dart';
import 'package:hikee/utils/dialog.dart';
import 'package:latlong2/latlong.dart';
import 'package:hikee/models/trail.dart';
import 'package:hikee/providers/trail.dart';
import 'package:hikee/utils/geo.dart';

class TrailController extends GetxController with StateMixin<Trail> {
  final _trailProvider = Get.put(TrailProvider());
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
    append(() => loadTrail);
    scrollController = ScrollController();
    trailReviewsController = Get.put(GetPaginationController((queries) {
      queries['order'] = 'DESC';
      return _trailProvider.getTrailReviews(id, queries);
    }));
    carouselController.addListener(() {
      double page = carouselController.page ?? 0;
      carouselPage.value = page;
    });
  }

  Future<Trail> loadTrail() async {
    var trail = await _trailProvider.getTrail(id);
    bookmarked.value = trail.bookmark != null;
    points.value = GeoUtils.decodePath(trail.path);
    return trail;
  }

  void viewMoreReviews() {
    Get.to(Scaffold(
      appBar: HikeeAppBar(title: Text('Reviews')),
      body: InfiniteScroller(
        controller: trailReviewsController,
        separator: SizedBox(height: 16),
        builder: (TrailReview trailReview) {
          return TrailReviewTile(trailReview: trailReview);
        },
      ),
    ));
  }

  Future<dynamic> addReview() async {
    final formkey = GlobalKey<FormState>();
    int _rating = 0;
    String _content = '';
    final result = await DialogUtils.showActionDialog(
        'Review',
        Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingInput(
                label: 'Rating',
                invalidRatingMessage: 'Please rate the trail',
                onSaved: (rating) => _rating = rating ?? 0,
              ),
              SizedBox(
                height: 16,
              ),
              TextInput(
                hintText: 'Leave your review here',
                maxLines: 5,
                label: 'Review',
                initialValue: _content,
                onSaved: (v) {
                  _content = v ?? '';
                },
                validator: (v) {
                  if (v == null || v.length == 0) {
                    return "Review cannot be empty";
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
    if (reviewsState?.hasMore == false) {
      reviewsState!..data.insert(0, newReview);
      // check if exceeds
      if (reviewsState.data.length > takeReviews) {
        reviewsState.hasMore = true;
      }
      trailReviewsController.forceUpdate(reviewsState);
    }
  }

  @override
  void onClose() {
    carouselController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
