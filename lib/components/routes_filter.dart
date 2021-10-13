// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:hikee/components/button.dart';
// import 'package:hikee/components/core/app_bar.dart';
// import 'package:hikee/old_providers/routes.dart';
// import 'package:provider/provider.dart';

// class RoutesFilter extends StatefulWidget {
//   const RoutesFilter({Key? key}) : super(key: key);

//   @override
//   _RoutesFilterState createState() => _RoutesFilterState();
// }

// class _RoutesFilterState extends State<RoutesFilter> {
//   late ValueNotifier<Region?> _region;
//   late ValueNotifier<RangeValues> _difficultyRange;
//   late ValueNotifier<RangeValues> _ratingRange;
//   late ValueNotifier<RangeValues> _durationRange;
//   late ValueNotifier<RangeValues> _lengthRange;

//   @override
//   void initState() {
//     super.initState();
//     var rp = context.read<RoutesProvider>();
//     _region = ValueNotifier(rp.region);
//     _difficultyRange = ValueNotifier(
//         RangeValues(rp.minDifficulty.toDouble(), rp.maxDifficulty.toDouble()));
//     _ratingRange = ValueNotifier(
//         RangeValues(rp.minRating.toDouble(), rp.maxRating.toDouble()));
//     _durationRange = ValueNotifier(
//         RangeValues(rp.minDuration.toDouble(), rp.maxDuration.toDouble()));
//     _lengthRange = ValueNotifier(
//         RangeValues(rp.minLength.toDouble(), rp.maxLength.toDouble()));
//   }

//   @override
//   void dispose() {
//     _region.dispose();
//     _difficultyRange.dispose();
//     _ratingRange.dispose();
//     _durationRange.dispose();
//     _lengthRange.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           HikeeAppBar(title: Text('Filters')),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Region',
//                       style: TextStyle(
//                           color: Theme.of(context).primaryColor,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold)),
//                   SizedBox(height: 16),
//                   Wrap(
//                     runSpacing: 8.0,
//                     spacing: 8.0,
//                     children: Region.values
//                         .map((r) => 
//                             ValueListenableBuilder<Region?>(
//                               valueListenable: _region,
//                               builder: (_, region, __) => Button(
//                                   secondary: region != r,
//                                   child: Text(r.name),
//                                   onPressed: () {
//                                     if (r == region)
//                                       _region.value = null;
//                                     else
//                                       _region.value = r;
//                                   }),
//                             ))
//                         .toList(),
//                   ),
//                   SizedBox(height: 16),
//                   Text('Rating',
//                       style: TextStyle(
//                           color: Theme.of(context).primaryColor,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold)),
//                   SizedBox(height: 16),
//                   ValueListenableBuilder<RangeValues>(
//                     valueListenable: _ratingRange,
//                     builder: (_, range, __) => Row(children: [
//                       SizedBox(
//                           width: 30,
//                           child: Center(
//                               child: Text(
//                                   (range.start.round() ~/ 1000).toString()))),
//                       Expanded(
//                         child: RangeSlider(
//                           values: RangeValues(range.start, range.end),
//                           min: 1,
//                           max: 5,
//                           divisions: 5,
//                           labels: RangeLabels(
//                             range.start.round().toString(),
//                             range.end.round().toString(),
//                           ),
//                           onChanged: (RangeValues values) {
//                             _ratingRange.value = values;
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                           width: 30,
//                           child: Center(
//                               child: Text(
//                                   (range.end.round() ~/ 1000).toString()))),
//                     ]),
//                   ),
//                   SizedBox(height: 16),
//                   Text('Difficulty',
//                       style: TextStyle(
//                           color: Theme.of(context).primaryColor,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold)),
//                   SizedBox(height: 16),
//                   ValueListenableBuilder<RangeValues>(
//                     valueListenable: _difficultyRange,
//                     builder: (_, range, __) => Row(children: [
//                       SizedBox(
//                           width: 30,
//                           child: Center(
//                               child: Text(
//                                   (range.start.round() ~/ 1000).toString()))),
//                       Expanded(
//                         child: RangeSlider(
//                           values: RangeValues(range.start, range.end),
//                           min: 1,
//                           max: 5,
//                           divisions: 5,
//                           labels: RangeLabels(
//                             range.start.round().toString(),
//                             range.end.round().toString(),
//                           ),
//                           onChanged: (RangeValues values) {
//                             _difficultyRange.value = values;
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                           width: 30,
//                           child: Center(
//                               child: Text(
//                                   (range.end.round() ~/ 1000).toString()))),
//                     ]),
//                   ),
//                   SizedBox(height: 16),
//                   Text('Duration (Hours)',
//                       style: TextStyle(
//                           color: Theme.of(context).primaryColor,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold)),
//                   SizedBox(height: 16),
//                   ValueListenableBuilder<RangeValues>(
//                     valueListenable: _durationRange,
//                     builder: (_, range, __) => Row(children: [
//                       SizedBox(
//                           width: 30,
//                           child: Center(
//                               child: Text(
//                                   (range.start.round() ~/ 1000).toString()))),
//                       Expanded(
//                         child: RangeSlider(
//                           values: RangeValues(range.start, range.end),
//                           min: 0,
//                           max: 720,
//                           divisions: 12,
//                           labels: RangeLabels(
//                             (range.start.round() ~/ 60).toString(),
//                             (range.end.round() ~/ 60).toString(),
//                           ),
//                           onChanged: (RangeValues values) {
//                             _durationRange.value = values;
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                           width: 30,
//                           child: Center(
//                               child: Text(
//                                   (range.end.round() ~/ 1000).toString()))),
//                     ]),
//                   ),
//                   SizedBox(height: 16),
//                   Text('Length (Km)',
//                       style: TextStyle(
//                           color: Theme.of(context).primaryColor,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold)),
//                   SizedBox(height: 16),
//                   ValueListenableBuilder<RangeValues>(
//                     valueListenable: _lengthRange,
//                     builder: (_, range, __) => Row(children: [
//                       SizedBox(
//                           width: 30,
//                           child: Center(
//                               child: Text(
//                                   (range.start.round() ~/ 1000).toString()))),
//                       Expanded(
//                         child: RangeSlider(
//                           values: RangeValues(range.start, range.end),
//                           min: 0,
//                           max: 20000,
//                           divisions: 20,
//                           labels: RangeLabels(
//                             (range.start.round() ~/ 1000).toString(),
//                             (range.end.round() ~/ 1000).toString(),
//                           ),
//                           onChanged: (RangeValues values) {
//                             _lengthRange.value = values;
//                           },
//                         ),
//                       ),
//                       SizedBox(
//                           width: 30,
//                           child: Center(
//                               child: Text(
//                                   (range.end.round() ~/ 1000).toString()))),
//                     ]),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             color: Colors.white,
//             padding: EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Expanded(
//                     child: Button(
//                         child: Text('APPLY'),
//                         onPressed: () {
//                           context.read<RoutesProvider>().applyFilters(
//                                 regionId: _region.value?.id,
//                                 minDifficulty:
//                                     _difficultyRange.value.start.toInt(),
//                                 maxDifficulty:
//                                     _difficultyRange.value.end.toInt(),
//                                 minRating: _ratingRange.value.start.toInt(),
//                                 maxRating: _ratingRange.value.end.toInt(),
//                                 minDuration: _durationRange.value.start.toInt(),
//                                 maxDuration: _durationRange.value.end.toInt(),
//                                 minLength: _lengthRange.value.start.toInt(),
//                                 maxLength: _lengthRange.value.end.toInt(),
//                               );
//                           Navigator.of(context).pop();
//                         })),
//                 SizedBox(
//                   width: 8,
//                 ),
//                 Expanded(
//                     child: Button(
//                         secondary: true,
//                         child: Text('CLEAR'),
//                         onPressed: () {
//                           context.read<RoutesProvider>().clearFilters();
//                           Navigator.of(context).pop();
//                         })),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
