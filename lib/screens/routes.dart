import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/account/change_nickname.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/hiking_route_tile.dart';
import 'package:hikee/components/infinite_scroll.dart';
import 'package:hikee/components/routes_filter.dart';
import 'package:hikee/components/text_input.dart';
import 'package:hikee/data/districtValues.dart';
import 'package:hikee/data/sortValues.dart';
import 'package:hikee/data/filterValues.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/providers/route.dart';
import 'package:hikee/providers/routes.dart';
import 'package:hikee/utils/dialog.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({Key? key}) : super(key: key);

  @override
  _RoutesScreenState createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  TextEditingController _searchController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
  }

  // void fetchMore(
  //     {String? query, int? after, String? sort, String? order}) async {
  //   setState(() {
  //     _loading = true;
  //   });
  //   int? after = _hikingRoutes.isEmpty ? null : _hikingRoutes.last.id;
  //   List<HikingRoute> routes = await _routeService.getRoutes(
  //       query: query, after: after, sort: sort, order: order);
  //   if (mounted) {
  //     setState(() {
  //       if (routes.length > 0)
  //         _hikingRoutes.addAll(routes);
  //       else
  //         _hasMore = false;
  //       _loading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // List<String> filterValue = [];
    // Color filterColor = (_libraryFilter.isEmpty())
    //     ? Colors.grey
    //     : Theme.of(context).primaryColor;
    // Color districtColor = (_libraryDistrict.isEmpty())
    //     ? Colors.grey
    //     : Theme.of(context).primaryColor;

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextInput(
                textEditingController: _searchController,
                hintText: 'Search...',
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: Offset(0, 6), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Button(
                      backgroundColor: Color(0xFFF5F5F5),
                      child: Selector<RoutesProvider, List<String>>(
                        selector: (_, p) => [p.sortStr, p.order],
                        builder: (_, sortAndOrder, __) => Row(
                          children: [
                            sortAndOrder[1] == 'DESC'
                                ? Icon(Icons.sort)
                                : Transform.rotate(
                                    angle: 180 * pi / 180,
                                    child: Icon(Icons.sort)),
                            Expanded(
                              child: Center(
                                child: Text(
                                  sortAndOrder[0],
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      onPressed: () {
                        _showSortMenu();
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Button(
                      backgroundColor: Color(0xFFF5F5F5),
                      onPressed: () {
                        _showFilter();
                      },
                      child: Text('Filters',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color)),
                    ),
                  )
                ],
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.grey.withOpacity(0.2),
            //         spreadRadius: 3,
            //         blurRadius: 3,
            //         offset: Offset(0, 6), // changes position of shadow
            //       ),
            //     ],
            //   ),
            //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceAround,
            //     children: <Widget>[
            //       //Sort Button
            //       TextButton(
            //           onPressed: () async {
            //             String newSortValue = await _showSortDialog(context);
            //             print(newSortValue);
            //             /*if (newSortValue.compareTo(sortValues[0]) == 0) {
            //                 sort = 'name_en';
            //                 order = 'ASC';
            //               }
            //               if (newSortValue.compareTo(sortValues[1]) == 0) {
            //                 sort = 'name_en';
            //                 order = 'DESC';
            //               }*/
            //             if (newSortValue.compareTo(sortValues[0]) == 0) {
            //               sort = 'length';
            //               order = 'ASC';
            //             }
            //             if (newSortValue.compareTo(sortValues[1]) == 0) {
            //               sort = 'length';
            //               order = 'DESC';
            //             }
            //             if (newSortValue.compareTo(sortValues[2]) == 0) {
            //               sort = 'difficulty';
            //               order = 'ASC';
            //             }
            //             if (newSortValue.compareTo(sortValues[3]) == 0) {
            //               sort = 'difficulty';
            //               order = 'DESC';
            //             }
            //             setState(() {
            //               _hikingRoutes.clear();
            //               fetchMore(query: query, sort: sort, order: order);
            //             });
            //           },
            //           style: TextButton.styleFrom(
            //               primary: Theme.of(context).primaryColor),
            //           child: Row(
            //             children: [
            //               Icon(Icons.sort),
            //               Text(
            //                 "Sorting",
            //                 style: TextStyle(fontSize: 15),
            //               ),
            //             ],
            //           )),

            //       // Filter Button
            //       TextButton(
            //           onPressed: () => {
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (context) => FilterPage()))
            //               },
            //           style: TextButton.styleFrom(
            //             primary: filterColor,
            //           ),
            //           child: Row(
            //             children: [
            //               Icon(Icons.filter_list),
            //               Text(
            //                 "Filter",
            //                 style: TextStyle(fontSize: 15),
            //               ),
            //             ],
            //           )),

            //       //District Button
            //       TextButton(
            //           onPressed: () => {
            //                 Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (context) => DistrictPage()))
            //               },
            //           style: TextButton.styleFrom(
            //             primary: districtColor,
            //           ),
            //           child: Row(
            //             children: [
            //               Icon(Icons.map),
            //               Text(
            //                 "District",
            //                 style: TextStyle(fontSize: 15),
            //               ),
            //             ],
            //           ))
            //     ],
            //   ),
            // ),
            Expanded(
              child: InfiniteScroll<RoutesProvider, HikingRoute>(
                selector: (p) => p.items,
                builder: (route) {
                  return HikingRouteTile(
                    route: route,
                    onTap: () {
                      Routemaster.of(context).push('/routes/${route.id}');
                    },
                  );
                },
                fetch: (next) {
                  return context.read<RoutesProvider>().fetch(next);
                },
              ),
              //     child: CustomScrollView(
              //   controller: _scrollController,
              //   slivers: [
              //     SliverPadding(
              //       padding: EdgeInsets.all(16),
              //       sliver: SliverList(
              //         delegate: SliverChildBuilderDelegate((context, index) {
              //           return HikingRouteTile(
              //             route: _hikingRoutes[index],
              //             onTap: () {
              //               Routemaster.of(context).push('/routes/${_hikingRoutes[index].id}');
              //             },
              //           );
              //         }, childCount: _hikingRoutes.length),
              //       ),
              //     ),
              //     if (_loading && _hasMore)
              //       SliverFillRemaining(
              //         hasScrollBody: false,
              //         fillOverscroll: true,
              //         child: Center(
              //             child: Padding(
              //           padding: const EdgeInsets.only(bottom: 32.0),
              //           child: CircularProgressIndicator(),
              //         )),
              //       ),
              //   ],
              // )
            ),
          ]),
        ),
      ),
    );
  }

  _showSortMenu() {
    DialogUtils.show(
        context,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Sort'),
            ),
            Selector<RoutesProvider, String>(
              selector: (_, p) => p.sort,
              builder: (_, sort, __) => Row(
                children: [
                  Button(
                    backgroundColor:
                        sort == 'difficulty' ? null : Color(0xFFF5F5F5),
                    child: Text('Difficulty',
                        style: sort == 'difficulty'
                            ? null
                            : TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color)),
                    onPressed: () {
                      context.read<RoutesProvider>().sort = 'difficulty';
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Button(
                    backgroundColor:
                        sort == 'length' ? null : Color(0xFFF5F5F5),
                    child: Text('Length',
                        style: sort == 'length'
                            ? null
                            : TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color)),
                    onPressed: () {
                      context.read<RoutesProvider>().sort = 'length';
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Button(
                    backgroundColor:
                        sort == 'duration' ? null : Color(0xFFF5F5F5),
                    child: Text('Duration',
                        style: sort == 'duration'
                            ? null
                            : TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color)),
                    onPressed: () {
                      context.read<RoutesProvider>().sort = 'duration';
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Order'),
            ),
            Selector<RoutesProvider, String>(
              selector: (_, p) => p.order,
              builder: (_, order, __) => Row(
                children: [
                  Button(
                    backgroundColor: order == 'ASC' ? null : Color(0xFFF5F5F5),
                    child: Text('Ascending',
                        style: order == 'ASC'
                            ? null
                            : TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color)),
                    onPressed: () {
                      context.read<RoutesProvider>().order = 'ASC';
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Button(
                    backgroundColor: order == 'DESC' ? null : Color(0xFFF5F5F5),
                    child: Text('Descending',
                        style: order == 'DESC'
                            ? null
                            : TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color)),
                    onPressed: () {
                      context.read<RoutesProvider>().order = 'DESC';
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  _showFilter() {
    Navigator.of(context).push(CupertinoPageRoute(builder: (_) => RoutesFilter()));
  }
}

class LibraryFilter extends ChangeNotifier {
  List<String> _selectedFilter;

  LibraryFilter(this._selectedFilter);

  RangeValues _rangeValues = RangeValues(0, 12);

  List<String> get selectedFilter => _selectedFilter;

  bool isEmpty() {
    return _selectedFilter.isEmpty;
  }

  clear() {
    _selectedFilter.clear();
    notifyListeners();
  }

  bool isFiltered(String value) => _selectedFilter.contains(value);

  RangeValues getRangeValues() {
    return _rangeValues;
  }

  setRangeValues(RangeValues rangeValues) {
    this._rangeValues = rangeValues;
    notifyListeners();
  }

  addFilter(String value) {
    if (!isFiltered(value)) {
      _selectedFilter.add(value);
      notifyListeners();
    }
  }

  removeFilter(String value) {
    if (isFiltered(value)) {
      _selectedFilter.remove(value);
      notifyListeners();
    }
  }
}

class LibraryDistrict extends ChangeNotifier {
  List<String> _selectedDistrict;

  LibraryDistrict(this._selectedDistrict);

  List<String> get selectedDistrict => _selectedDistrict;

  bool isEmpty() {
    return _selectedDistrict.isEmpty;
  }

  clear() {
    _selectedDistrict.clear();
    notifyListeners();
  }

  bool isHaveDistrict(String value) => _selectedDistrict.contains(value);

  addDistrict(String value) {
    if (!isHaveDistrict(value)) {
      _selectedDistrict.add(value);
      notifyListeners();
    }
  }

  removeDistrict(String value) {
    if (isHaveDistrict(value)) {
      _selectedDistrict.remove(value);
      notifyListeners();
    }
  }
}

//=============District=====
class DistrictPage extends StatefulWidget {
  const DistrictPage({Key? key}) : super(key: key);

  @override
  _DistrictPageState createState() => _DistrictPageState();
}

class _DistrictPageState extends State<DistrictPage> {
  @override
  Widget build(BuildContext context) {
    final _libraryDistrict = Provider.of<LibraryDistrict>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Select District(s)')),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kowloon :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Wrap(
              spacing: 5.0,
              runSpacing: 2.0,
              children: kowloonValues
                  .map((e) => FilterChip(
                        label: Text(e),
                        selectedColor: Theme.of(context).primaryColor,
                        onSelected: (value) {
                          setState(() {
                            value
                                ? _libraryDistrict.addDistrict(e)
                                : _libraryDistrict.removeDistrict(e);
                          });
                        },
                        selected: _libraryDistrict.isHaveDistrict(e),
                      ))
                  .toList(),
            ),
            Divider(),
            Text(
              "New Territories :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Wrap(
              spacing: 5.0,
              runSpacing: 2.0,
              children: newTerriValues
                  .map((e) => FilterChip(
                        label: Text(e),
                        selectedColor: Theme.of(context).primaryColor,
                        onSelected: (value) {
                          setState(() {
                            value
                                ? _libraryDistrict.addDistrict(e)
                                : _libraryDistrict.removeDistrict(e);
                          });
                        },
                        selected: _libraryDistrict.isHaveDistrict(e),
                      ))
                  .toList(),
            ),
            Divider(),
            Text(
              "Hong Kong Island :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Wrap(
              spacing: 5.0,
              runSpacing: 2.0,
              children: hkIslandValues
                  .map((e) => FilterChip(
                        label: Text(e),
                        selectedColor: Theme.of(context).primaryColor,
                        onSelected: (value) {
                          setState(() {
                            value
                                ? _libraryDistrict.addDistrict(e)
                                : _libraryDistrict.removeDistrict(e);
                          });
                        },
                        selected: _libraryDistrict.isHaveDistrict(e),
                      ))
                  .toList(),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: Button(
                      child: Text("Clear"),
                      backgroundColor: Colors.grey.withOpacity(0.6),
                      onPressed: () {
                        setState(() {
                          _libraryDistrict.clear();
                          //districtColor = Colors.grey;
                        });
                      }),
                ),
                Container(width: 5),
                Expanded(
                  child: Button(
                      child: Text("Apply"),
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {}),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  RangeLabels labels = RangeLabels("1", "12");

  @override
  Widget build(BuildContext context) {
    final _libraryFilter = Provider.of<LibraryFilter>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Select Filter(s)')),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Duration (hour) :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Row(
              children: [
                Text("0"),
                Expanded(
                  child: RangeSlider(
                    activeColor: Theme.of(context).primaryColor,
                    min: 0,
                    max: 12,
                    divisions: 12,
                    labels: labels,
                    values: _libraryFilter.getRangeValues(),
                    onChanged: (value) {
                      _libraryFilter.setRangeValues(value);
                      setState(() {
                        labels = RangeLabels(value.start.toInt().toString(),
                            value.end.toInt().toString());
                      });
                    },
                  ),
                ),
                Text("12")
              ],
            ),
            Divider(),
            Text(
              "View :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Wrap(
              spacing: 5.0,
              runSpacing: 2.0,
              children: View.map((e) => FilterChip(
                    label: Text(e),
                    selectedColor: Theme.of(context).primaryColor,
                    onSelected: (value) {
                      setState(() {
                        value
                            ? _libraryFilter.addFilter(e)
                            : _libraryFilter.removeFilter(e);
                      });
                    },
                    selected: _libraryFilter.isFiltered(e),
                  )).toList(),
            ),
            Divider(),
            Text(
              "Facilities :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Wrap(
              spacing: 5.0,
              runSpacing: 2.0,
              children: Facilities.map((e) => FilterChip(
                    label: Text(e),
                    selectedColor: Theme.of(context).primaryColor,
                    onSelected: (value) {
                      setState(() {
                        value
                            ? _libraryFilter.addFilter(e)
                            : _libraryFilter.removeFilter(e);
                      });
                    },
                    selected: _libraryFilter.isFiltered(e),
                  )).toList(),
            ),
            Divider(),
            Text(
              "Activities :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Wrap(
              spacing: 5.0,
              runSpacing: 2.0,
              children: Activities.map((e) => FilterChip(
                    label: Text(e),
                    selectedColor: Theme.of(context).primaryColor,
                    onSelected: (value) {
                      setState(() {
                        value
                            ? _libraryFilter.addFilter(e)
                            : _libraryFilter.removeFilter(e);
                      });
                    },
                    selected: _libraryFilter.isFiltered(e),
                  )).toList(),
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: Button(
                      child: Text("Clear"),
                      backgroundColor: Colors.grey.withOpacity(0.6),
                      onPressed: () {
                        setState(() {
                          _libraryFilter.clear();
                          //districtColor = Colors.grey;
                        });
                      }),
                ),
                Container(width: 5),
                Expanded(
                  child: Button(
                      child: Text("Apply"),
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {}),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
