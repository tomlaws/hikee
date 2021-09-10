import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/future_selector.dart';
import 'package:hikee/components/dialog/route_review.dart';
import 'package:hikee/components/core/infinite_scroll.dart';
import 'package:hikee/components/route_info.dart';
import 'package:hikee/components/route_review_tile.dart';
import 'package:hikee/components/core/shimmer.dart';
import 'package:hikee/models/active_hiking_route.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/models/route_review.dart';
import 'package:hikee/providers/auth.dart';
import 'package:hikee/providers/bookmarks.dart';
import 'package:hikee/providers/route.dart';
import 'package:hikee/providers/route_reviews.dart';
import 'package:hikee/utils/dialog.dart';
import 'package:hikee/utils/geo.dart';
import 'package:hikee/utils/map_marker.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class RouteScreen extends StatefulWidget {
  final int id;
  const RouteScreen({Key? key, required this.id}) : super(key: key);

  @override
  _RouteScreenState createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  PageController _carouselController = PageController();
  ValueNotifier<double> _carouselPage = ValueNotifier<double>(0.0);
  ValueNotifier<bool> _bookmarked = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _carouselController.addListener(() {
      double page = _carouselController.page ?? 0;
      _carouselPage.value = page;
    });
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: FutureSelector<RouteProvider, HikingRoute>(
            init: (rp) => rp.getRoute(widget.id),
            selector: (_, rp) => rp.route,
            builder: (_, route, __) {
              _bookmarked.value = route.bookmark != null;
              var points = GeoUtils.decodePath(route.path);
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: 250.0,
                    backgroundColor: Colors.white,
                    actions: [
                      ValueListenableBuilder<bool>(
                        valueListenable: _bookmarked,
                        builder: (context, bookmarked, __) => Button(
                            backgroundColor: Colors.transparent,
                            icon: Icon(
                              bookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_outline,
                              color: Colors.amber,
                            ),
                            onPressed: () {
                              context.read<AuthProvider>().mustLogin(context,
                                  () {
                                if (bookmarked) {
                                  context
                                      .read<BookmarksProvider>()
                                      .deleteBookmark(route.bookmark!.id);
                                  _bookmarked.value = false;
                                } else {
                                  context
                                      .read<BookmarksProvider>()
                                      .createBookmark(route.id)
                                      .then((b) => route.bookmark?.id = b.id);
                                  _bookmarked.value = true;
                                }
                              });
                            }),
                      )
                    ],
                    flexibleSpace: Stack(
                      children: <Widget>[
                        Positioned.fill(
                            child: PageView(
                          controller: _carouselController,
                          children: route.images
                              .map((img) => CachedNetworkImage(
                                    placeholder: (_, __) => Shimmer(),
                                    imageUrl: img,
                                    fit: BoxFit.cover,
                                  ))
                              .toList(),
                        )),
                        Positioned(
                          bottom: 8,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: ValueListenableBuilder<double>(
                              valueListenable: _carouselPage,
                              builder: (_, value, ___) {
                                return SizedBox(
                                  height: 8,
                                  child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      separatorBuilder: (_, __) => Container(
                                            width: 8,
                                          ),
                                      itemCount: route.images.length,
                                      itemBuilder: (_, i) {
                                        bool active = value.round() == i;
                                        return AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 250),
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                              color: active
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.black38,
                                              borderRadius:
                                                  BorderRadius.circular(4.0)),
                                        );
                                      }),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(16.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    route.name(context),
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Container(
                                    height: 4,
                                  ),
                                  Text(
                                    route.region.name(context),
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xFFAAAAAA)),
                                  ),
                                ],
                              ),
                            ),
                            Button(
                              onPressed: () {
                                Provider.of<ActiveHikingRoute>(context,
                                        listen: false)
                                    .selectRoute(route);
                                Routemaster.of(context).push('/home');
                              },
                              child: Text('SELECT'),
                            )
                          ],
                        ),
                        Container(
                          height: 12,
                        ),
                        Divider(),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Description',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Container(
                                  height: 12,
                                ),
                                Text(
                                  route.description(context),
                                  style: TextStyle(height: 1.6),
                                ),
                              ],
                            )),
                        Container(
                          height: 8,
                        ),
                        RouteInfo(
                          route: route,
                          showRouteName: false,
                        ),
                        Container(
                          height: 16,
                        ),
                        Container(
                          height: 240,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0)),
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: points[(points.length / 5 * 2).floor()],
                              zoom: 13,
                            ),
                            gestureRecognizers:
                                <Factory<OneSequenceGestureRecognizer>>[
                              new Factory<OneSequenceGestureRecognizer>(
                                () => new EagerGestureRecognizer(),
                              ),
                            ].toSet(),
                            zoomControlsEnabled: true,
                            compassEnabled: false,
                            mapToolbarEnabled: false,
                            tiltGesturesEnabled: false,
                            scrollGesturesEnabled: false,
                            zoomGesturesEnabled: false,
                            rotateGesturesEnabled: false,
                            polylines: [
                              Polyline(
                                polylineId: PolylineId('polyLine1'),
                                color: Colors.amber.shade400,
                                zIndex: 2,
                                width: 4,
                                jointType: JointType.round,
                                startCap: Cap.roundCap,
                                endCap: Cap.roundCap,
                                points: points,
                              ),
                              Polyline(
                                polylineId: PolylineId('polyLine2'),
                                color: Colors.white,
                                width: 6,
                                jointType: JointType.round,
                                startCap: Cap.roundCap,
                                endCap: Cap.roundCap,
                                zIndex: 1,
                                points: points,
                              ),
                            ].toSet(),
                            markers: [
                              Marker(
                                markerId: MarkerId('marker-start'),
                                zIndex: 2,
                                icon: MapMarker().start,
                                position: points.first,
                              ),
                              Marker(
                                markerId: MarkerId('marker-end'),
                                zIndex: 1,
                                icon: MapMarker().end,
                                position: points.last,
                              )
                            ].toSet(),
                            onMapCreated: (GoogleMapController controller) {
                              controller.setMapStyle(
                                  '[ { "elementType": "geometry.stroke", "stylers": [ { "color": "#798b87" } ] }, { "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "elementType": "labels.text.stroke", "stylers": [ { "visibility": "off" } ] }, { "featureType": "landscape", "elementType": "geometry", "stylers": [ { "color": "#c2d1c2" } ] }, { "featureType": "poi", "elementType": "geometry", "stylers": [ { "color": "#97be99" } ] }, { "featureType": "road", "stylers": [ { "color": "#d0ddd9" } ] }, { "featureType": "road", "elementType": "geometry.stroke", "stylers": [ { "color": "#919c99" } ] }, { "featureType": "road", "elementType": "labels.text", "stylers": [ { "color": "#446c79" } ] }, { "featureType": "road.local", "elementType": "geometry.fill", "stylers": [ { "color": "#cedade" } ] }, { "featureType": "road.local", "elementType": "geometry.stroke", "stylers": [ { "color": "#8b989c" } ] }, { "featureType": "water", "stylers": [ { "color": "#6da0b0" } ] } ]');

                              controller.moveCamera(
                                  CameraUpdate.newLatLngBounds(
                                      GeoUtils.getPathBounds(points), 40));
                            },
                          ),
                        )
                      ]),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.all(16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Divider(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Reviews',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold)),
                                    Button(
                                        backgroundColor: Colors.transparent,
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.black38,
                                        ),
                                        onPressed: () async {
                                          await routeReviewDialog();
                                        })
                                  ]),
                              Container(
                                height: 8,
                              ),
                              _reviewList(3),
                              Selector<RouteReviewsProvider, bool>(
                                  builder: (context, more, __) {
                                    if (!more) return SizedBox();
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Button(
                                            child: Text('SHOW MORE'),
                                            secondary: true,
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .push(CupertinoPageRoute(
                                                      builder: (_) => Container(
                                                            color: Colors.white,
                                                            child: Column(
                                                                children: [
                                                                  HikeeAppBar(
                                                                    title: Text(
                                                                        'Reviews'),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        16.0),
                                                                    child:
                                                                        _reviewList(
                                                                            null),
                                                                  ),
                                                                ]),
                                                          )));
                                            }),
                                      ),
                                    );
                                  },
                                  selector: (_, p) => p.items.length > 3)
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }));
  }

  Future<Map<String, dynamic>?> routeReviewDialog() async {
    return await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (BuildContext context) {
        return RouteReviewDialog(
          routeId: widget.id,
        );
      },
    );
  }

  Widget _reviewList(int? take) {
    return InfiniteScroll<RouteReviewsProvider, RouteReview>(
        take: take,
        init: take != null,
        empty: 'No reviews yet',
        shrinkWrap: true,
        selector: (p) => p.items,
        padding: EdgeInsets.zero,
        separator: SizedBox(height: 8),
        builder: (routeReview) {
          return RouteReviewTile(
            routeReview: routeReview,
          );
        },
        fetch: (next) {
          return context.read<RouteReviewsProvider>().fetch(next);
        });
  }
}
